import '../local/dummy_opportunities.dart';
import '../models/opportunity.dart';

class OpportunityRepository {
  /// Mengambil daftar peluang untuk Feed.
  ///
  /// Sementara menggunakan dummy data.
  /// Hanya peluang aktif dan belum melewati tanggal berakhir
  /// yang ditampilkan.
  Future<List<Opportunity>> getFeedOpportunities() async {
    final now = DateTime.now();

    final opportunities = dummyOpportunities.where((opportunity) {
      return opportunity.status == 'active' && opportunity.endDate.isAfter(now);
    }).toList();

    // Urutkan berdasarkan waktu publikasi terbaru.
    opportunities.sort((a, b) {
      final dateA = a.createdAt ?? DateTime(2000);
      final dateB = b.createdAt ?? DateTime(2000);

      return dateB.compareTo(dateA);
    });

    return opportunities;
  }

  /// Mencari peluang berdasarkan kata kunci.
  ///
  /// Pencarian dilakukan pada judul, deskripsi, dan sumber.
  /// Menggunakan Linear Search tanpa membedakan huruf besar/kecil.
  Future<List<Opportunity>> searchOpportunities(String query) async {
    final opportunities = await getFeedOpportunities();

    final keyword = query.trim().toLowerCase();

    // Jika kolom pencarian kosong, tampilkan semua peluang aktif.
    if (keyword.isEmpty) {
      return opportunities;
    }

    final List<Opportunity> results = [];

    // Linear Search: periksa setiap peluang satu per satu.
    for (final opportunity in opportunities) {
      final title = opportunity.title.toLowerCase();
      final description = opportunity.description.toLowerCase();
      final source = (opportunity.source ?? '').toLowerCase();

      if (title.contains(keyword) ||
          description.contains(keyword) ||
          source.contains(keyword)) {
        results.add(opportunity);
      }
    }

    return results;
  }
}
