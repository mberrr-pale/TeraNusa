import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/opportunity.dart';

class OpportunityRepository {
  final SupabaseClient _supabase;

  OpportunityRepository(this._supabase);

  Future<List<String>> getAvailableCities() async {
    final response = await _supabase
        .from('regions')
        .select('city')
        .order('city');

    final cities = response
        .map((item) => item['city']?.toString() ?? '')
        .where((city) => city.trim().isNotEmpty)
        .toSet()
        .toList();

    cities.sort();
    return cities;
  }

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

  Future<List<Opportunity>> getArchivedOpportunities() async {
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) {
      return [];
    }

    final response = await _supabase
        .from('opportunities')
        .select('*, regions(province, city)')
        .eq('user_id', userId)
        .inFilter('status', ['active', 'archived'])
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => Opportunity.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<List<Opportunity>> searchOpportunities(
    String query, {
    String? category,
    String? city,
    String sortBy = 'Terbaru',
  }) async {
    final opportunities = await getFeedOpportunities();
    final keyword = query.trim().toLowerCase();

    var results = opportunities.where((opportunity) {
      final matchesKeyword =
          keyword.isEmpty ||
          opportunity.title.toLowerCase().contains(keyword) ||
          opportunity.description.toLowerCase().contains(keyword) ||
          (opportunity.source ?? '').toLowerCase().contains(keyword);

      final matchesCategory =
          category == null ||
          category == 'Semua' ||
          opportunity.category.trim().toLowerCase() ==
              category.trim().toLowerCase();

      final matchesCity =
          city == null ||
          city == 'Semua wilayah' ||
          opportunity.regionCity?.toLowerCase() == city.toLowerCase();

      return matchesKeyword && matchesCategory && matchesCity;
    }).toList();

    if (sortBy == 'Segera berakhir') {
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day);
      final end = start.add(const Duration(days: 8));

      results = results.where((opportunity) {
        final endDate = opportunity.endDate;
        return !endDate.isBefore(start) && endDate.isBefore(end);
      }).toList();

      results.sort((a, b) => a.endDate.compareTo(b.endDate));
    } else if (sortBy == 'Terlama') {
      results.sort((a, b) {
        return (a.createdAt ?? DateTime(1970)).compareTo(
          b.createdAt ?? DateTime(1970),
        );
      });
    } else {
      results.sort((a, b) {
        return (b.createdAt ?? DateTime(1970)).compareTo(
          a.createdAt ?? DateTime(1970),
        );
      });
    }

    return results;
  }
}
