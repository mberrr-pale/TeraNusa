import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/contributor_remote_datasource.dart';
import '../../data/repositories/contributor_repository_impl.dart';
import '../../domain/repositories/contributor_repository.dart';

final contributorRemoteDataSourceProvider =
    Provider<ContributorRemoteDataSource>((ref) {
      return ContributorRemoteDataSourceImpl(Supabase.instance.client);
    });

final contributorRepositoryProvider = Provider<ContributorRepository>((ref) {
  return ContributorRepositoryImpl(
    ref.watch(contributorRemoteDataSourceProvider),
  );
});
