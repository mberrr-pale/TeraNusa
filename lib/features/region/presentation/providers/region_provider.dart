import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/supabase_config.dart';
import '../../../../data/local/app_database.dart';

import '../../data/datasources/region_remote_datasource.dart';
import '../../data/datasources/region_local_datasource.dart';
import '../../data/repositories/region_repository_impl.dart';
import '../../domain/repositories/region_repository.dart';
import '../../domain/usecases/get_region_by_id.dart';
import '../../../../data/models/region_model.dart';

// Database
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  ref.onDispose(database.close);

  return database;
});

// Remote DataSource
final regionRemoteDataSourceProvider = Provider<RegionRemoteDataSource>((ref) {
  return RegionRemoteDataSource(SupabaseConfig.client);
});

// Local DataSource
final regionLocalDataSourceProvider = Provider<RegionLocalDataSource>((ref) {
  return RegionLocalDataSource(ref.watch(appDatabaseProvider));
});

// Repository
final regionRepositoryProvider = Provider<RegionRepository>((ref) {
  return RegionRepositoryImpl(
    remoteDataSource: ref.watch(regionRemoteDataSourceProvider),
    localDataSource: ref.watch(regionLocalDataSourceProvider),
  );
});

// UseCase
final getRegionByIdUseCaseProvider = Provider<GetRegionById>((ref) {
  return GetRegionById(ref.watch(regionRepositoryProvider));
});

// Get Regions
final getRegionsProvider =
    FutureProvider.family<
      List<RegionModel>,
      ({String search, int page, int limit})
    >((ref, params) async {
      final repository = ref.watch(regionRepositoryProvider);

      return repository.getRegions(
        search: params.search,
        page: params.page,
        limit: params.limit,
      );
    });

// Get Region By ID
final getRegionByIdProvider = FutureProvider.family<RegionModel?, String>((
  ref,
  regionId,
) async {
  if (regionId.isEmpty) return null;

  final useCase = ref.watch(getRegionByIdUseCaseProvider);

  return useCase(regionId);
});
