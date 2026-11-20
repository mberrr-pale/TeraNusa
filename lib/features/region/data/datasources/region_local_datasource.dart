import 'package:drift/drift.dart';

import '../../../../data/local/app_database.dart';
import '../../../../data/models/region_model.dart';

class RegionLocalDataSource {
  final AppDatabase database;

  RegionLocalDataSource(this.database);

  Future<List<RegionModel>> getRegions({
    String search = '',
    int page = 0,
    int limit = 20,
  }) async {
    final keyword = search.trim();

    final query = database.select(database.regions);

    if (keyword.isNotEmpty) {
      query.where((tbl) {
        return tbl.province.contains(keyword) |
            tbl.city.contains(keyword) |
            tbl.district.contains(keyword) |
            tbl.village.contains(keyword);
      });
    }

    query
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.village)])
      ..limit(limit, offset: page * limit);

    final response = await query.get();

    return response.map((item) {
      return RegionModel(
        regionId: item.regionId,
        province: item.province,
        city: item.city,
        district: item.district,
        village: item.village,
      );
    }).toList();
  }

  Future<RegionModel?> getRegionById(String regionId) async {
    final query = database.select(database.regions)
      ..where((tbl) => tbl.regionId.equals(regionId))
      ..limit(1);

    final response = await query.getSingleOrNull();

    if (response == null) return null;

    return RegionModel(
      regionId: response.regionId,
      province: response.province,
      city: response.city,
      district: response.district,
      village: response.village,
    );
  }

  Future<void> saveRegions(List<RegionModel> regions) async {
    await database.batch((batch) {
      batch.insertAllOnConflictUpdate(
        database.regions,
        regions.map((region) {
          return RegionsCompanion.insert(
            regionId: region.regionId,
            province: region.province,
            city: region.city,
            district: region.district,
            village: region.village,
          );
        }).toList(),
      );
    });
  }

  Future<void> saveRegion(RegionModel region) async {
    await database
        .into(database.regions)
        .insertOnConflictUpdate(
          RegionsCompanion.insert(
            regionId: region.regionId,
            province: region.province,
            city: region.city,
            district: region.district,
            village: region.village,
          ),
        );
  }
}
