import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/supabase_config.dart';

import '../../data/datasources/region_remote_datasource.dart';
import '../../data/repositories/region_repository_impl.dart';
import '../../domain/repositories/region_repository.dart';
import '../../domain/usecases/get_region_by_id.dart';
import '../../../../data/models/region_model.dart';

final regionRemoteDataSourceProvider = Provider<RegionRemoteDataSource>((ref) {
  return RegionRemoteDataSource(SupabaseConfig.client);
});

final regionRepositoryProvider = Provider<RegionRepository>((ref) {
  return RegionRepositoryImpl(ref.watch(regionRemoteDataSourceProvider));
});

final getRegionByIdUseCaseProvider = Provider<GetRegionById>((ref) {
  return GetRegionById(ref.watch(regionRepositoryProvider));
});

final getRegionByIdProvider = FutureProvider.family<RegionModel?, String>((
  ref,
  regionId,
) async {
  if (regionId.isEmpty) return null;

  final useCase = ref.watch(getRegionByIdUseCaseProvider);

  return useCase(regionId);
});
