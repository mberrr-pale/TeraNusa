import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_provider.dart';
import '../../../../core/providers/internet_provider.dart';
import '../../../../data/models/opportunity.dart';
import '../../../../data/repositories/local_archived_opportunity_repository.dart';
import '../../../../data/repositories/opportunity_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// ============================================================
// REPOSITORY PROVIDERS
// ============================================================

final archivedOpportunitySourceProvider = Provider<OpportunityRepository>((
  ref,
) {
  final supabase = ref.watch(supabaseProvider);
  return OpportunityRepository(supabase);
});

final localArchivedOpportunityRepositoryProvider =
    Provider<LocalArchivedOpportunityRepository>((ref) {
      return LocalArchivedOpportunityRepository(ref.watch(databaseProvider));
    });

// ============================================================
// ARCHIVED OPPORTUNITY IDS PROVIDER
// ============================================================

final archivedOpportunityIdsProvider =
    AsyncNotifierProvider<ArchivedOpportunityNotifier, Set<String>>(
      ArchivedOpportunityNotifier.new,
    );

class ArchivedOpportunityNotifier extends AsyncNotifier<Set<String>> {
  final Set<String> _syncingUsers = {};

  @override
  Future<Set<String>> build() async {
    String? activeUserId;

    // Dengarkan perubahan koneksi.
    ref.listen(internetStatusProvider, (previous, next) {
      final userId = activeUserId;

      if (userId != null && next.asData?.value == true) {
        unawaited(_syncArchivedOpportunities(userId));
      }
    });

    final user = await ref.watch(authProvider.future);

    if (user == null) return {};

    activeUserId = user.userId;

    final localRepository = ref.watch(
      localArchivedOpportunityRepositoryProvider,
    );

    // Tampilkan data lokal terlebih dahulu.
    final localIds = await localRepository.getArchivedOpportunityIds(
      user.userId,
    );

    // Sinkronisasi berjalan di belakang jika online.
    if (ref.read(internetStatusProvider).asData?.value == true) {
      unawaited(_syncArchivedOpportunities(user.userId));
    }

    return localIds;
  }

  // ==========================================================
  // REFRESH
  // ==========================================================

  Future<void> refresh() async {
    final user = await ref.read(authProvider.future);

    if (user == null) return;

    // Sinkronisasi hanya dilakukan jika sedang online.
    if (ref.read(internetStatusProvider).asData?.value != true) {
      return;
    }

    await _syncArchivedOpportunities(user.userId);

    // Baca ulang data terbaru dari Drift.
    ref.invalidate(archivedOpportunitiesProvider);
  }

  // ==========================================================
  // DOWNLOAD IMAGE UNTUK OFFLINE
  // ==========================================================

  Future<Uint8List?> _downloadImageBytes(String? imageUrl) async {
    if (imageUrl == null || imageUrl.trim().isEmpty) {
      return null;
    }

    try {
      final uri = Uri.tryParse(imageUrl);

      if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
        return null;
      }

      final byteData = await NetworkAssetBundle(uri)
          .load(uri.toString())
          .timeout(const Duration(seconds: 15));

      return byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );
    } catch (e) {
      return null;
    }
  }

  // ==========================================================
  // SYNC SUPABASE -> DRIFT
  // ==========================================================

  Future<void> _syncArchivedOpportunities(String userId) async {
    if (_syncingUsers.contains(userId)) return;

    if (ref.read(internetStatusProvider).asData?.value != true) {
      return;
    }

    _syncingUsers.add(userId);

    try {
      final currentUser = ref.read(authProvider).asData?.value;

      // Pastikan akun yang aktif masih sama.
      if (currentUser?.userId != userId) return;

      final remoteRepository = ref.read(archivedOpportunitySourceProvider);

      final localRepository = ref.read(
        localArchivedOpportunityRepositoryProvider,
      );

      // Pengambilan data server harus berhasil sebelum cache diubah.
      final remoteOpportunities = await remoteRepository
          .getArchivedOpportunities();

      final latestUser = ref.read(authProvider).asData?.value;

      if (latestUser?.userId != userId) return;

      // Ambil data lokal sebelum pembaruan.
      final localIds = await localRepository.getArchivedOpportunityIds(userId);

      final localOpportunities = await localRepository.getArchivedOpportunities(
        userId,
      );

      final localOpportunitiesById = {
        for (final item in localOpportunities)
          if (item.opportunityId != null) item.opportunityId!: item,
      };

      // ID arsip yang tersedia di server.
      final remoteIds = remoteOpportunities
          .map((item) => item.opportunityId)
          .whereType<String>()
          .where((id) => id.trim().isNotEmpty)
          .toSet();

      // Perbarui detail dan cache gambar.
      for (final opportunity in remoteOpportunities) {
        final latestAccount = ref.read(authProvider).asData?.value;

        if (latestAccount?.userId != userId) return;

        final opportunityId = opportunity.opportunityId;

        if (opportunityId == null || opportunityId.trim().isEmpty) {
          continue;
        }

        final existing = localOpportunitiesById[opportunityId];

        Uint8List? imageBytes;

        // Pertahankan gambar lokal jika URL tidak berubah.
        if (existing?.imageUrl == opportunity.imageUrl &&
            existing?.localImageBytes?.isNotEmpty == true) {
          imageBytes = existing!.localImageBytes;
        } else {
          // Unduh jika gambar belum tersedia atau URL berubah.
          imageBytes = await _downloadImageBytes(opportunity.imageUrl);
        }

        // Periksa kembali akun sebelum menyimpan.
        final verifiedAccount = ref.read(authProvider).asData?.value;

        if (verifiedAccount?.userId != userId) return;

        await localRepository.saveArchivedOpportunity(
          opportunity: opportunity,
          userId: userId,
          localImageBytes: imageBytes,
        );
      }

      // Hapus cache yang sudah tidak tersedia di server.
      final removedIds = localIds.difference(remoteIds);

      for (final id in removedIds) {
        final verifiedAccount = ref.read(authProvider).asData?.value;

        if (verifiedAccount?.userId != userId) return;

        await localRepository.removeArchivedOpportunity(
          userId: userId,
          opportunityId: id,
        );
      }

      final verifiedUser = ref.read(authProvider).asData?.value;

      if (verifiedUser?.userId != userId) return;

      state = AsyncData(remoteIds);
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
    } finally {
      _syncingUsers.remove(userId);
    }
  }
}

// ============================================================
// ARCHIVED OPPORTUNITIES PROVIDER
// ============================================================

final archivedOpportunitiesProvider = FutureProvider<List<Opportunity>>((
  ref,
) async {
  // Dengarkan perubahan ID setelah sinkronisasi.
  ref.watch(archivedOpportunityIdsProvider);

  final user = await ref.watch(authProvider.future);

  if (user == null) return [];

  final localRepository = ref.watch(localArchivedOpportunityRepositoryProvider);

  // Daftar arsip selalu dibaca dari Drift.
  final opportunities = await localRepository.getArchivedOpportunities(
    user.userId,
  );

  return opportunities;
});
