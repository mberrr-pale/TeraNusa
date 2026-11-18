import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/news.dart';

class NewsRepository {
  final SupabaseClient _supabase;

  NewsRepository(this._supabase);

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

  Future<List<News>> getFeedNews() async {
    final response = await _supabase
        .from('news')
        .select('*, regions(city, province)')
        .order('published_at', ascending: false);

    return (response as List)
        .map((item) => News.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<List<News>> searchNews(
    String query, {
    String? city,
    String sortBy = 'Terbaru',
  }) async {
    final newsList = await getFeedNews();
    final keyword = query.trim().toLowerCase();

    final results = newsList.where((news) {
      final matchesKeyword =
          keyword.isEmpty ||
          news.title.toLowerCase().contains(keyword) ||
          news.summary.toLowerCase().contains(keyword) ||
          news.source.toLowerCase().contains(keyword);

      final matchesCity =
          city == null ||
          city == 'Semua wilayah' ||
          news.regionCity?.toLowerCase() == city.toLowerCase();

      return matchesKeyword && matchesCity;
    }).toList();

    if (sortBy == 'Terlama') {
      results.sort((a, b) => a.publishedAt.compareTo(b.publishedAt));
    } else {
      results.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    }

    return results;
  }
}
