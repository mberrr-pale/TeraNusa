import '../../domain/repositories/region_repository.dart';
import '../datasources/region_remote_datasource.dart';
import '../datasources/region_local_datasource.dart';

import '../../../../../data/models/region_model.dart';

class RegionRepositoryImpl implements RegionRepository {
  final RegionRemoteDataSource remoteDataSource;
  final RegionLocalDataSource localDataSource;

  RegionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<RegionModel>> getRegions({
    String search = '',
    int page = 0,
    int limit = 20,
  }) async {
    try {
      final remoteRegions = await remoteDataSource.getRegions(
        search: search,
        page: page,
        limit: limit,
      );

      // Simpan hasil remote ke database lokal.
      await localDataSource.saveRegions(remoteRegions);

      return remoteRegions;
    } catch (e) {
      // Jika gagal, gunakan data lokal.
      return localDataSource.getRegions(
        search: search,
        page: page,
        limit: limit,
      );
    }
  }

  @override
  Future<RegionModel?> getRegionById(String regionId) async {
    try {
      final remoteRegion = await remoteDataSource.getRegionById(regionId);

      if (remoteRegion != null) {
        await localDataSource.saveRegion(remoteRegion);
        return remoteRegion;
      }

      return null;
    } catch (e) {
      return localDataSource.getRegionById(regionId);
    }
  }
}
