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
}
