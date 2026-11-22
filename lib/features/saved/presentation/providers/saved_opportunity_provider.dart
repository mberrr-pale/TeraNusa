import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../data/models/opportunity.dart';
import '../../../../data/repositories/saved_opportunity_repository.dart';

// Repository provider.
final savedOpportunityRepositoryProvider = Provider<SavedOpportunityRepository>(
  (ref) {
    final supabase = ref.watch(supabaseProvider);
    return SavedOpportunityRepository(supabase);
  },
);

// Mengelola ID peluang yang sudah disimpan.
final savedOpportunityIdsProvider =
    AsyncNotifierProvider<SavedOpportunityNotifier, Set<String>>(
      SavedOpportunityNotifier.new,
    );

class SavedOpportunityNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    final user = await ref.watch(authProvider.future);

    if (user == null) return {};

    final repository = ref.watch(savedOpportunityRepositoryProvider);

    return repository.getSavedOpportunityIds(user.userId);
  }

  // Menyimpan atau membatalkan penyimpanan peluang.
  Future<void> toggleSavedOpportunity(String opportunityId) async {
    if (opportunityId.trim().isEmpty) {
      throw ArgumentError('ID peluang tidak boleh kosong.');
    }

    final user = await ref.read(authProvider.future);

    if (user == null) {
      throw StateError('Pengguna belum login.');
    }

    final repository = ref.read(savedOpportunityRepositoryProvider);
    final currentIds = state.value ?? await future;

    final isSaved = currentIds.contains(opportunityId);

    if (isSaved) {
      await repository.removeSavedOpportunity(
        userId: user.userId,
        opportunityId: opportunityId,
      );
    } else {
      await repository.saveOpportunity(
        userId: user.userId,
        opportunityId: opportunityId,
      );
    }

    final updatedIds = {...currentIds};

    if (isSaved) {
      updatedIds.remove(opportunityId);
    } else {
      updatedIds.add(opportunityId);
    }

    state = AsyncData(updatedIds);

    // Segarkan daftar pada halaman Tersimpan.
    ref.invalidate(savedOpportunitiesProvider);
  }
}

// Mengambil detail seluruh peluang yang tersimpan.
final savedOpportunitiesProvider = FutureProvider<List<Opportunity>>((
  ref,
) async {
  final user = await ref.watch(authProvider.future);

  if (user == null) return [];

  final repository = ref.watch(savedOpportunityRepositoryProvider);

  return repository.getSavedOpportunities(user.userId);
});
