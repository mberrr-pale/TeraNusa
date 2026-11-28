import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/contributor_req_remote_datasource.dart';
import '../../data/repositories/contributor_req_repository_impl.dart';
import '../../domain/entities/contributor_request.dart';
import '../../domain/repositories/contributor_req_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final contributorRequestRemoteProvider =
    Provider<ContributorRequestRemoteDataSource>((ref) {
      return ContributorRequestRemoteDataSource(
        ref.watch(supabaseClientProvider),
      );
    });

final contributorRequestRepositoryProvider =
    Provider<ContributorRequestRepository>((ref) {
      return ContributorRequestRepositoryImpl(
        ref.watch(contributorRequestRemoteProvider),
      );
    });

// Get pengajuan milik user.
final myContributorApplicationProvider = FutureProvider<ContributorRequest?>((
  ref,
) async {
  return ref.watch(contributorRequestRepositoryProvider).getMyApplication();
});

// Realtime pengajuan milik user.
final myContributorApplicationStreamProvider =
    StreamProvider<List<ContributorRequest>>((ref) {
      return ref
          .watch(contributorRequestRepositoryProvider)
          .watchMyApplication();
    });
