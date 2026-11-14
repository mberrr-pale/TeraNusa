import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../data/models/region_model.dart';

class RegionRemoteDataSource {
  final SupabaseClient supabase;

  RegionRemoteDataSource(this.supabase);

  Future<List<RegionModel>> getRegions({
    String search = '',
    int page = 0,
    int limit = 20,
  }) async {
    final start = page * limit;
    final end = start + limit - 1;

    var query = supabase
        .from('regions')
        .select('region_id, province, city, district, village');

    if (search.trim().isNotEmpty) {
      final keyword = search.trim();

      query = query.or(
        'province.ilike.%$keyword%,'
        'city.ilike.%$keyword%,'
        'district.ilike.%$keyword%,'
        'village.ilike.%$keyword%',
      );
    }

    final response = await query
        .order('village', ascending: true)
        .range(start, end);

    return response
        .map<RegionModel>((json) => RegionModel.fromJson(json))
        .toList();
  }
}
