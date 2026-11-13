import '../../domain/repositories/region_repository.dart';
import '../datasources/region_remote_datasource.dart';
import '../../../../../data/models/region_model.dart';

class RegionRepositoryImpl implements RegionRepository {
  final RegionRemoteDataSource remoteDataSource;

  RegionRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<RegionModel>> getRegions({
    String search = '',
    int page = 0,
    int limit = 20,
  }) {
    return remoteDataSource.getRegions(
      search: search,
      page: page,
      limit: limit,
    );
  }
}
