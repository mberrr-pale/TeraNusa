import '../models/opportunity.dart';

final List<Opportunity> dummyOpportunities = [
  Opportunity(
    opportunityId: 'demo-001',
    userId: 'demo-user-001',
    title: 'Lowongan Admin UMKM',
    description: 'Kesempatan bekerja sebagai admin untuk membantu operasional UMKM lokal di wilayah Madiun.',
    category: 'lowongan',
    regionId: 'demo-madiun',
    endDate: DateTime.now().add(const Duration(days: 14)),
    source: 'UMKM Madiun',
    contact: '081234567801',
    status: 'active',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Opportunity(
    opportunityId: 'demo-002',
    userId: 'demo-user-002',
    title: 'Festival Budaya Ponorogo',
    description: 'Kegiatan budaya lokal yang menghadirkan pertunjukan seni dan potensi daerah Ponorogo.',
    category: 'event',
    regionId: 'demo-ponorogo',
    endDate: DateTime.now().add(const Duration(days: 10)),
    source: 'Panitia Festival Ponorogo',
    contact: '081234567802',
    status: 'active',
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  Opportunity(
    opportunityId: 'demo-003',
    userId: 'demo-user-003',
    title: 'Pelatihan Digital Marketing UMKM',
    description: 'Program pemberdayaan masyarakat melalui pelatihan pemasaran digital untuk pelaku UMKM.',
    category: 'pemberdayaan',
    regionId: 'demo-jombang',
    endDate: DateTime.now().add(const Duration(days: 21)),
    source: 'Komunitas UMKM Jombang',
    contact: '081234567803',
    status: 'active',
    createdAt: DateTime.now().subtract(const Duration(hours: 8)),
  ),
  Opportunity(
    opportunityId: 'demo-004',
    userId: 'demo-user-004',
    title: 'Produk Kerajinan Anyaman Lokal',
    description:
        'Temukan produk kerajinan anyaman buatan pengrajin lokal dari Madiun.',
    category: 'produk_jasa',
    regionId: 'demo-madiun',
    endDate: DateTime.now().add(const Duration(days: 30)),
    source: 'Pengrajin Lokal Madiun',
    contact: '081234567804',
    status: 'active',
    createdAt: DateTime.now().subtract(const Duration(hours: 12)),
  ),
  Opportunity(
    opportunityId: 'demo-005',
    userId: 'demo-user-005',
    title: 'Rekrutmen Staf Operasional',
    description:
        'Kesempatan kerja untuk posisi staf operasional di wilayah Ponorogo.',
    category: 'lowongan',
    regionId: 'demo-ponorogo',
    endDate: DateTime.now().add(const Duration(days: 7)),
    source: 'Mitra Usaha Ponorogo',
    contact: '081234567805',
    status: 'active',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Opportunity(
    opportunityId: 'demo-006',
    userId: 'demo-user-006',
    title: 'Workshop Kewirausahaan Pemuda',
    description: 'Workshop untuk mengembangkan keterampilan kewirausahaan dan potensi pemuda daerah.',
    category: 'pemberdayaan',
    regionId: 'demo-jombang',
    endDate: DateTime.now().add(const Duration(days: 18)),
    source: 'Komunitas Pemuda Jombang',
    contact: '081234567806',
    status: 'active',
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
  ),
  Opportunity(
    opportunityId: 'demo-007',
    userId: 'demo-user-007',
    title: 'Bazar Produk Lokal',
    description: 'Bazar yang mempertemukan pelaku usaha lokal dengan masyarakat dan calon pembeli.',
    category: 'event',
    regionId: 'demo-madiun',
    endDate: DateTime.now().add(const Duration(days: 5)),
    source: 'Penyelenggara Bazar Madiun',
    contact: '081234567807',
    status: 'active',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Opportunity(
    opportunityId: 'demo-008',
    userId: 'demo-user-008',
    title: 'Jasa Desain Grafis Lokal',
    description: 'Layanan desain grafis dari penyedia jasa lokal untuk kebutuhan promosi usaha.',
    category: 'produk_jasa',
    regionId: 'demo-ponorogo',
    endDate: DateTime.now().add(const Duration(days: 25)),
    source: 'Kreator Lokal Ponorogo',
    contact: '081234567808',
    status: 'active',
    createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
  ),
];

/// Pemetaan ID wilayah khusus dummy ke nama wilayah tampilan.
const Map<String, String> dummyRegionNames = {
  'demo-madiun': 'Madiun, Jawa Timur',
  'demo-ponorogo': 'Ponorogo, Jawa Timur',
  'demo-jombang': 'Jombang, Jawa Timur',
};

/// Mengubah kode kategori menjadi label untuk ditampilkan.
String getCategoryLabel(String category) {
  switch (category) {
    case 'lowongan':
      return 'Lowongan';
    case 'event':
      return 'Event';
    case 'pemberdayaan':
      return 'Pemberdayaan';
    case 'produk_jasa':
      return 'Produk & Jasa';
    default:
      return 'Lainnya';
  }
}
