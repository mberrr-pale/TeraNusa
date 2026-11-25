import '../models/contributor_application.dart';

abstract class ContributorApplicationRepository {
  Future<List<ContributorApplication>> getApplications();

  /// Satu-satunya operasi tulis: menyimpan keputusan review admin.
  Future<ContributorApplication> updateStatus({
    required String id,
    required ApplicationStatus status,
    String? note,
  });
}

/// Implementasi sementara (in-memory) selama sumber data asli belum tersedia.
// TODO(contributor-review): ganti dengan implementasi asli (Supabase / Drift) setelah disediakan tim.
class DummyContributorApplicationRepository
    implements ContributorApplicationRepository {
  final Duration fetchDelay;
  final Duration updateDelay;
  final List<ContributorApplication> _items;

  DummyContributorApplicationRepository({
    List<ContributorApplication>? initialItems,
    this.fetchDelay = const Duration(milliseconds: 400),
    this.updateDelay = const Duration(milliseconds: 500),
  }) : _items = List<ContributorApplication>.of(
         initialItems ?? _defaultItems(),
       );

  static List<ContributorApplication> _defaultItems() {
    final now = DateTime.now();
    return [
      ContributorApplication(
        id: 'app-001',
        fullName: 'Budi Santoso',
        roleLabel: 'Admin Wilayah',
        position: 'Sekretaris Desa',
        institution: 'Pemerintah Desa Caturtunggal',
        email: 'budi@teranusa.id',
        phone: '0812-3456-7890',
        region: 'Depok, Kabupaten Sleman',
        reason: 'Ingin membantu menyebarkan informasi peluang dan agenda desa.',
        submittedAt: DateTime(now.year, now.month, now.day, 9, 42),
      ),
      ContributorApplication(
        id: 'app-002',
        fullName: 'Nindya Rahma',
        roleLabel: 'Kontributor',
        position: 'Staf Pelayanan',
        institution: 'Kapanewon Ngaglik',
        email: 'nindya@teranusa.id',
        phone: '0813-9876-5432',
        region: 'Ngaglik, Kabupaten Sleman',
        reason:
            'Aktif mengelola informasi pelayanan masyarakat dan agenda warga.',
        submittedAt: DateTime(now.year, now.month, now.day - 1, 14, 18),
      ),
      ContributorApplication(
        id: 'app-003',
        fullName: 'Dwi Prasetyo',
        roleLabel: 'Kontributor',
        position: 'Operator Desa',
        institution: 'Pemerintah Desa Tirtomartani',
        email: 'dwi@teranusa.id',
        phone: '0857-2345-6789',
        region: 'Kalasan, Kabupaten Sleman',
        reason:
            'Ingin mempublikasikan program pemberdayaan UMKM dan lowongan lokal.',
        submittedAt: DateTime(now.year, now.month, now.day - 6, 11, 5),
      ),
      ContributorApplication(
        id: 'app-004',
        fullName: 'Ratna Dewi',
        roleLabel: 'Admin Wilayah',
        position: 'Kasi Pemerintahan',
        institution: 'Pemerintah Desa Condongcatur',
        email: 'ratna@teranusa.id',
        phone: '0819-4455-6677',
        region: 'Depok, Kabupaten Sleman',
        reason:
            'Bertugas mengoordinasikan verifikasi informasi resmi tingkat kalurahan.',
        submittedAt: DateTime(now.year, now.month, now.day - 2, 10, 15),
      ),
      ContributorApplication(
        id: 'app-005',
        fullName: 'Raka Pratama',
        roleLabel: 'Kontributor',
        position: 'Pengurus Karang Taruna',
        institution: 'Karang Taruna Mlati',
        email: 'raka@teranusa.id',
        phone: '0821-7788-9900',
        region: 'Mlati, Kabupaten Sleman',
        reason:
            'Ingin membagikan agenda kepemudaan dan pelatihan kerja untuk warga.',
        submittedAt: DateTime(now.year, now.month, now.day, 8, 20),
      ),
    ];
  }

  @override
  Future<List<ContributorApplication>> getApplications() async {
    if (fetchDelay > Duration.zero) {
      await Future.delayed(fetchDelay);
    }
    return List.unmodifiable(_items);
  }

  @override
  Future<ContributorApplication> updateStatus({
    required String id,
    required ApplicationStatus status,
    String? note,
  }) async {
    if (updateDelay > Duration.zero) {
      await Future.delayed(updateDelay);
    }

    final index = _items.indexWhere((e) => e.id == id);
    if (index == -1) {
      throw StateError('Pengajuan tidak ditemukan');
    }

    final trimmedNote = note?.trim();
    final updated = _items[index].copyWith(
      status: status,
      adminNote: (trimmedNote == null || trimmedNote.isEmpty)
          ? null
          : trimmedNote,
      clearAdminNote: trimmedNote == null || trimmedNote.isEmpty,
      reviewedAt: DateTime.now(),
    );
    _items[index] = updated;
    return updated;
  }
}
