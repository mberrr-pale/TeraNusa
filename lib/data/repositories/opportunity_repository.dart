import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/opportunity.dart';

class OpportunityRepository {
  final SupabaseClient _supabase;

  OpportunityRepository(this._supabase);

  /// Mengambil peluang aktif yang belum melewati tanggal berakhir.
  Future<List<Opportunity>> getFeedOpportunities() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final response = await _supabase
        .from('opportunities')
        .select('*, regions(province, city)')
        .eq('status', 'active')
        .gte('end_date', today)
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => Opportunity.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  /// Mencari peluang berdasarkan judul, deskripsi, dan sumber.
  Future<List<Opportunity>> searchOpportunities(String query) async {
    final opportunities = await getFeedOpportunities();

    final keyword = query.trim().toLowerCase();

    if (keyword.isEmpty) {
      return opportunities;
    }

    return opportunities.where((opportunity) {
      final title = opportunity.title.toLowerCase();
      final description = opportunity.description.toLowerCase();
      final source = (opportunity.source ?? '').toLowerCase();

      return title.contains(keyword) ||
          description.contains(keyword) ||
          source.contains(keyword);
    }).toList();
  }
}
