import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/news.dart';

class NewsRepository {
  final SupabaseClient _supabase;

  NewsRepository(this._supabase);

  /// Mengambil berita terbaru dari Supabase.
  Future<List<News>> getFeedNews() async {
    final response = await _supabase
        .from('news')
        .select()
        .order('published_at', ascending: false);

    return (response as List)
        .map((item) => News.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  /// Mencari berita berdasarkan judul, ringkasan, dan sumber.
  Future<List<News>> searchNews(String query) async {
    final newsList = await getFeedNews();

    final keyword = query.trim().toLowerCase();

    if (keyword.isEmpty) {
      return newsList;
    }

    return newsList.where((news) {
      final title = news.title.toLowerCase();
      final summary = news.summary.toLowerCase();
      final source = news.source.toLowerCase();

      return title.contains(keyword) ||
          summary.contains(keyword) ||
          source.contains(keyword);
    }).toList();
  }
}
