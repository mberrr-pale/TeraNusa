import '../../../../../data/models/region_model.dart';
import '../repositories/region_repository.dart';

class GetRegionById {
  final RegionRepository repository;

  GetRegionById(this.repository);

  Future<RegionModel?> call(String regionId) {
    return repository.getRegionById(regionId);
  }
}
