import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/contributor_application_repository_impl.dart';
import '../../data/datasources/contributor_application_remote_datasource.dart';
import '../../domain/repositories/contributor_application_repository.dart';

final contributorApplicationRemoteDataSourceProvider =
    Provider<ContributorApplicationRemoteDataSource>((ref) {
      throw UnimplementedError('Remote datasource belum dikonfigurasi');
    });

final Provider<ContributorApplicationRepository>
contributorApplicationRepositoryProvider =
    Provider<ContributorApplicationRepository>((ref) {
      final dataSource = ref.watch(
        contributorApplicationRemoteDataSourceProvider,
      );

      return ContributorApplicationRepositoryImpl(dataSource);
    });
