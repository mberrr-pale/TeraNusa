import '../../../../../data/models/region_model.dart';

abstract class RegionRepository {
  Future<List<RegionModel>> getRegions({
    String search = '',
    int page = 0,
    int limit = 20,
  });
}
