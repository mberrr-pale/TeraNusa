import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/supabase_config.dart';

import '../../data/datasources/region_remote_datasource.dart';
import '../../data/repositories/region_repository_impl.dart';
import '../../domain/repositories/region_repository.dart';

final regionRemoteDataSourceProvider = Provider<RegionRemoteDataSource>((ref) {
  return RegionRemoteDataSource(SupabaseConfig.client);
});

final regionRepositoryProvider = Provider<RegionRepository>((ref) {
  return RegionRepositoryImpl(ref.watch(regionRemoteDataSourceProvider));
});
