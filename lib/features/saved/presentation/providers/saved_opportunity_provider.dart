import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_provider.dart';
import '../../../../core/providers/internet_provider.dart';
import '../../../../data/models/opportunity.dart';
import '../../../../data/repositories/local_saved_opportunity_repository.dart';
import '../../../../data/repositories/saved_opportunity_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// ============================================================
// REPOSITORY PROVIDERS
// ============================================================

final savedOpportunityRepositoryProvider = Provider<SavedOpportunityRepository>(
  (ref) {
    final supabase = ref.watch(supabaseProvider);
    return SavedOpportunityRepository(supabase);
  },
);

final localSavedOpportunityRepositoryProvider =
    Provider<LocalSavedOpportunityRepository>((ref) {
      return LocalSavedOpportunityRepository(ref.watch(databaseProvider));
    });

class OfflineSavedActionException implements Exception {
  const OfflineSavedActionException();
}

// ============================================================
// SAVED OPPORTUNITY IDS PROVIDER
// ============================================================

final savedOpportunityIdsProvider =
    AsyncNotifierProvider<SavedOpportunityNotifier, Set<String>>(
      SavedOpportunityNotifier.new,
    );

class SavedOpportunityNotifier extends AsyncNotifier<Set<String>> {
  final Set<String> _syncingUsers = {};

  @override
  Future<Set<String>> build() async {
    String? activeUserId;

    // Dengarkan perubahan koneksi tanpa menunggu koneksi
    // sebelum data lokal ditampilkan.
    ref.listen(internetStatusProvider, (previous, next) {
      final userId = activeUserId;

      if (userId != null && next.asData?.value == true) {
        unawaited(_syncSavedOpportunities(userId));
      }
    });

    final user = await ref.watch(authProvider.future);

    if (user == null) return {};

    activeUserId = user.userId;

    final localRepository = ref.watch(localSavedOpportunityRepositoryProvider);

    // Ambil data lokal terlebih dahulu.
    final localIds = await localRepository.getSavedOpportunityIds(user.userId);

    // Jika internet sudah tersedia, sinkronisasi di belakang.
    if (ref.read(internetStatusProvider).asData?.value == true) {
      unawaited(_syncSavedOpportunities(user.userId));
    }

    return localIds;
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

  Future<void> _syncSavedOpportunities(String userId) async {
    if (_syncingUsers.contains(userId)) return;

    if (ref.read(internetStatusProvider).asData?.value != true) {
      return;
    }

    _syncingUsers.add(userId);

    try {
      final currentUser = ref.read(authProvider).asData?.value;

      // Cegah data akun lain masuk ke state aktif.
      if (currentUser?.userId != userId) return;

      final remoteRepository = ref.read(savedOpportunityRepositoryProvider);
      final localRepository = ref.read(localSavedOpportunityRepositoryProvider);

      final remoteIds = await remoteRepository.getSavedOpportunityIds(userId);

      final remoteOpportunities = await remoteRepository.getSavedOpportunities(
        userId,
      );

      // Pastikan akun belum berubah selama proses sinkronisasi.
      final latestUser = ref.read(authProvider).asData?.value;

      if (latestUser?.userId != userId) return;

      // Ambil data lokal sebelum proses pembaruan.
      final localIds = await localRepository.getSavedOpportunityIds(userId);

      final localOpportunities = await localRepository.getSavedOpportunities(
        userId,
      );

      final localOpportunitiesById = {
        for (final item in localOpportunities)
          if (item.opportunityId != null) item.opportunityId!: item,
      };

      // Hapus cache yang memang sudah tidak tersimpan di Supabase.
      final removedIds = localIds.difference(remoteIds);

      for (final id in removedIds) {
        await localRepository.removeSavedOpportunity(
          userId: userId,
          opportunityId: id,
        );
      }

      // Perbarui detail peluang beserta cache gambarnya.
      for (final opportunity in remoteOpportunities) {
        final opportunityId = opportunity.opportunityId;

        if (opportunityId == null || opportunityId.trim().isEmpty) {
          continue;
        }

        final existing = localOpportunitiesById[opportunityId];

        Uint8List? imageBytes;

        // Gunakan gambar lokal jika URL belum berubah
        // dan gambar sebelumnya sudah tersimpan.
        if (existing?.imageUrl == opportunity.imageUrl &&
            existing?.localImageBytes?.isNotEmpty == true) {
          imageBytes = existing!.localImageBytes;
        } else {
          // Unduh gambar jika belum tersedia atau URL berubah.
          imageBytes = await _downloadImageBytes(opportunity.imageUrl);
        }

        await localRepository.saveOpportunity(
          opportunity: opportunity,
          savedByUserId: userId,
          localImageBytes: imageBytes,
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

  // ==========================================================
  // SAVE / UNSAVE
  // ==========================================================

  Future<void> toggleSavedOpportunity(String opportunityId) async {
    if (opportunityId.trim().isEmpty) {
      throw ArgumentError('ID peluang tidak boleh kosong.');
    }

    final user = await ref.read(authProvider.future);

    if (user == null) {
      throw StateError('Pengguna belum login.');
    }

    // Simpan dan hapus hanya dapat dilakukan saat online.
    if (ref.read(internetStatusProvider).asData?.value != true) {
      throw const OfflineSavedActionException();
    }

    final currentIds = state.asData?.value ?? await future;
    final isSaved = currentIds.contains(opportunityId);

    final remoteRepository = ref.read(savedOpportunityRepositoryProvider);
    final localRepository = ref.read(localSavedOpportunityRepositoryProvider);

    if (isSaved) {
      await remoteRepository.removeSavedOpportunity(
        userId: user.userId,
        opportunityId: opportunityId,
      );

      await localRepository.removeSavedOpportunity(
        userId: user.userId,
        opportunityId: opportunityId,
      );

      state = AsyncData({...currentIds}..remove(opportunityId));
    } else {
      await remoteRepository.saveOpportunity(
        userId: user.userId,
        opportunityId: opportunityId,
      );

      state = AsyncData({...currentIds, opportunityId});

      // Ambil detail terbaru dari Supabase dan simpan ke Drift.
      await _syncSavedOpportunities(user.userId);
    }
  }
}

// ============================================================
// SAVED OPPORTUNITIES PROVIDER
// ============================================================

final savedOpportunitiesProvider = FutureProvider<List<Opportunity>>((
  ref,
) async {
  // Dengarkan perubahan ID agar daftar ikut diperbarui
  // setelah proses sinkronisasi atau save/unsave.
  ref.watch(savedOpportunityIdsProvider);

  final user = await ref.watch(authProvider.future);

  if (user == null) return [];

  final localRepository = ref.watch(localSavedOpportunityRepositoryProvider);

  // Tampilan daftar selalu mengambil data dari Drift.
  final opportunities = await localRepository.getSavedOpportunities(
    user.userId,
  );

  return opportunities;
});
