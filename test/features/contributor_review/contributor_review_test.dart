import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teranusa/core/theme/app_theme.dart';
import 'package:teranusa/data/models/user_profile_model.dart';
import 'package:teranusa/features/contributor_review/models/contributor_application.dart';
import 'package:teranusa/features/contributor_review/pages/admin_dashboard_page.dart';
import 'package:teranusa/features/contributor_review/pages/contributor_review_page.dart';
import 'package:teranusa/features/contributor_review/providers/contributor_application_provider.dart';
import 'package:teranusa/features/contributor_review/repository/contributor_application_repository.dart';
import 'package:teranusa/features/contributor_review/widgets/contributor_application_card.dart';
import 'package:teranusa/features/contributor_review/widgets/contributor_application_section.dart';
import 'package:teranusa/features/contributor_review/widgets/dashboard_application_card.dart';
import 'package:teranusa/features/profile/presentation/widgets/profile_menu.dart';

class _ControllableRepository implements ContributorApplicationRepository {
  Completer<List<ContributorApplication>>? fetchCompleter;
  bool shouldFailFetch;
  bool shouldFailUpdate;
  int updateCallCount = 0;
  List<ContributorApplication> items;

  _ControllableRepository({
    List<ContributorApplication>? items,
    this.shouldFailFetch = false,
    this.shouldFailUpdate = false,
  }) : items = List.of(items ?? _sampleItems());

  static List<ContributorApplication> _sampleItems() => [
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
      submittedAt: DateTime(2026, 6, 20, 9, 42),
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
      reason: 'Aktif mengelola informasi pelayanan masyarakat dan agenda.',
      submittedAt: DateTime(2026, 6, 19, 14, 18),
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
      reason: 'Ingin mempublikasikan program pemberdayaan UMKM lokal.',
      submittedAt: DateTime(2026, 6, 17, 11, 5),
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
      reason: 'Mengelola verifikasi informasi tingkat kalurahan.',
      submittedAt: DateTime(2026, 6, 18, 10, 15),
    ),
  ];

  @override
  Future<List<ContributorApplication>> getApplications() async {
    if (fetchCompleter != null) {
      return fetchCompleter!.future;
    }
    if (shouldFailFetch) {
      throw Exception('Network error');
    }
    return List.unmodifiable(items);
  }

  @override
  Future<ContributorApplication> updateStatus({
    required String id,
    required ApplicationStatus status,
    String? note,
  }) async {
    updateCallCount++;
    if (shouldFailUpdate) {
      throw Exception('Server failure');
    }
    final i = items.indexWhere((e) => e.id == id);
    if (i == -1) throw StateError('Pengajuan tidak ditemukan');
    final trimmed = note?.trim();
    final updated = items[i].copyWith(
      status: status,
      adminNote: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
      clearAdminNote: trimmed == null || trimmed.isEmpty,
      reviewedAt: DateTime(2026, 6, 20, 10, 30),
    );
    items[i] = updated;
    return updated;
  }
}

Widget _wrapPage(Widget page) {
  return MaterialApp(theme: AppTheme.light, home: page);
}

void _setPhoneViewport(WidgetTester tester, {Size size = const Size(412, 915)}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Future<void> _scrollSheetTo(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(
    target,
    200,
    scrollable: find.byType(Scrollable).last,
  );
  await tester.pumpAndSettle();
}

void main() {
  group('Model ContributorApplication, ApplicationCategory & formatSubmittedAt', () {
    test('initials menangani nama 1 kata, 2 kata, >2 kata, dan kosong', () {
      ContributorApplication buildWithName(String name) =>
          ContributorApplication(
            id: '1',
            fullName: name,
            roleLabel: 'Admin Wilayah',
            position: 'Sekretaris',
            institution: 'Pemerintah Desa',
            email: 'a@b.id',
            phone: '0812',
            region: 'Sleman',
            reason: 'Alasan',
            submittedAt: DateTime(2026, 6, 17, 11, 5),
          );

      expect(buildWithName('Budi Santoso').initials, 'BS');
      expect(buildWithName('Sukarno').initials, 'S');
      expect(buildWithName('Muhammad Ali Akbar').initials, 'MA');
      expect(buildWithName('   ').initials, '?');
    });

    test('category membedakan Kontributor dan Admin Wilayah secara read-only', () {
      final samples = _ControllableRepository._sampleItems();
      expect(samples[0].category, ApplicationCategory.regionalAdmin);
      expect(samples[1].category, ApplicationCategory.contributor);
      expect(samples[2].category, ApplicationCategory.contributor);
      expect(samples[3].category, ApplicationCategory.regionalAdmin);
    });

    test('copyWith hanya mengubah field keputusan dan menjaga read-only', () {
      final base = _ControllableRepository._sampleItems().first;
      final reviewedTime = DateTime(2026, 6, 20, 11, 0);
      final updated = base.copyWith(
        status: ApplicationStatus.approved,
        adminNote: 'Data valid',
        reviewedAt: reviewedTime,
      );

      expect(updated.id, base.id);
      expect(updated.fullName, base.fullName);
      expect(updated.institution, base.institution);
      expect(updated.email, base.email);
      expect(updated.reason, base.reason);
      expect(updated.status, ApplicationStatus.approved);
      expect(updated.adminNote, 'Data valid');
      expect(updated.reviewedAt, reviewedTime);

      final cleared = updated.copyWith(clearAdminNote: true);
      expect(cleared.adminNote, isNull);
    });

    test(
      'formatSubmittedAt memformat hari ini, kemarin, tanggal tahun sama, dan tahun berbeda',
      () {
        final now = DateTime(2026, 6, 20, 16, 0);
        expect(
          formatSubmittedAt(DateTime(2026, 6, 20, 9, 42), now: now),
          'Hari ini · 09.42',
        );
        expect(
          formatSubmittedAt(DateTime(2026, 6, 19, 14, 18), now: now),
          'Kemarin · 14.18',
        );
        expect(
          formatSubmittedAt(DateTime(2026, 6, 17, 11, 5), now: now),
          '17 Juni · 11.05',
        );
        expect(
          formatSubmittedAt(DateTime(2025, 12, 5, 8, 0), now: now),
          '5 Desember 2025 · 08.00',
        );
      },
    );

    test(
      'DummyContributorApplicationRepository menyediakan data Kontributor & Admin Wilayah',
      () async {
        final repo = DummyContributorApplicationRepository(
          fetchDelay: Duration.zero,
          updateDelay: Duration.zero,
        );

        final initial = await repo.getApplications();
        expect(initial.length, 5);
        expect(
          initial
              .where((e) => e.category == ApplicationCategory.contributor)
              .length,
          3,
        );
        expect(
          initial
              .where((e) => e.category == ApplicationCategory.regionalAdmin)
              .length,
          2,
        );

        final updated = await repo.updateStatus(
          id: 'app-001',
          status: ApplicationStatus.approved,
          note: '  Disetujui  ',
        );
        expect(updated.status, ApplicationStatus.approved);
        expect(updated.adminNote, 'Disetujui');
        expect(updated.reviewedAt, isNotNull);

        expect(
          () => repo.updateStatus(
            id: 'tidak-ada',
            status: ApplicationStatus.rejected,
            note: 'Alasan',
          ),
          throwsStateError,
        );
      },
    );
  });

  group('AdminDashboardPage tampilan, aksi review & navigasi kategori', () {
    testWidgets(
      'menampilkan hero card, 3 stat card (laporan 0), section Kontributor & Admin Wilayah, serta Laporan kosong',
      (tester) async {
        _setPhoneViewport(tester);
        final repo = _ControllableRepository();

        await tester.pumpWidget(
          _wrapPage(
            AdminDashboardPage(
              repository: repo,
              adminName: 'Ayu Rahmawati',
              regionName: 'Kabupaten Sleman',
              now: DateTime(2026, 6, 20, 8, 30),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Dashboard Admin'), findsOneWidget);
        expect(find.text('KONTRIBUTOR VERIFIKATOR'), findsOneWidget);
        expect(find.text('Kabupaten Sleman'), findsOneWidget);
        expect(find.text('Selamat pagi, Ayu.'), findsOneWidget);
        expect(find.text('Butuh tindakan'), findsOneWidget);

        // Stat card counts: 2 Kontributor, 2 Admin Wilayah, 0 Laporan
        expect(
          find.descendant(
            of: find.byKey(const Key('stat_card_contributor')),
            matching: find.text('2'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const Key('stat_card_regional_admin')),
            matching: find.text('2'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const Key('stat_card_report')),
            matching: find.text('0'),
          ),
          findsOneWidget,
        );

        // Section Pengajuan Kontributor & Pengajuan Admin Wilayah pakai kartu ringkas 2-kolom
        // Tidak ada tombol 'Lihat semua'; admin langsung filter urutan di halaman Dashboard
        expect(find.text('Lihat semua'), findsNothing);
        expect(find.text('Pengajuan Kontributor'), findsWidgets);
        expect(find.text('Pengajuan Admin Wilayah'), findsOneWidget);
        expect(find.byType(DashboardApplicationCard), findsWidgets);
        expect(find.byKey(const Key('dashboard_card_review_action')), findsWidgets);
        expect(find.byKey(const Key('dashboard_sort_contributor')), findsOneWidget);
        expect(
          find.byKey(const Key('dashboard_sort_regional_admin')),
          findsOneWidget,
        );
        expect(find.text('Staf Pelayanan'), findsOneWidget);
        expect(find.text('Kapanewon Ngaglik'), findsOneWidget);

        // Default Terbaru: Nindya Rahma (19 Juni) tampil di kiri, Dwi Prasetyo (17 Juni) di kanan
        final contributorCards = tester
            .widgetList<DashboardApplicationCard>(
              find.byType(DashboardApplicationCard),
            )
            .where((c) => c.application.category == ApplicationCategory.contributor)
            .toList();
        expect(contributorCards.length, 2);
        final newestFirstRect = tester.getRect(find.text('Nindya Rahma'));
        final newestSecondRect = tester.getRect(find.text('Dwi Prasetyo'));
        expect(newestFirstRect.top, closeTo(newestSecondRect.top, 2.0));
        expect(newestFirstRect.left, lessThan(newestSecondRect.left));

        // Tap filter inline Kontributor -> berubah ke Terlama (Dwi Prasetyo di kiri)
        await tester.tap(find.byKey(const Key('dashboard_sort_contributor')));
        await tester.pumpAndSettle();
        expect(
          find.descendant(
            of: find.byKey(const Key('dashboard_sort_contributor')),
            matching: find.text('Terlama'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const Key('dashboard_sort_regional_admin')),
            matching: find.text('Terbaru'),
          ),
          findsOneWidget,
        );
        final oldestFirstRect = tester.getRect(find.text('Dwi Prasetyo'));
        final oldestSecondRect = tester.getRect(find.text('Nindya Rahma'));
        expect(oldestFirstRect.left, lessThan(oldestSecondRect.left));

        // Scroll ke bawah untuk verifikasi Pengajuan Laporan dikosongkan
        await tester.scrollUntilVisible(
          find.byKey(const Key('empty_report_section')),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();

        expect(find.text('Belum ada pengajuan laporan'), findsOneWidget);
      },
    );

    testWidgets(
      'tinjau data langsung dari Dashboard Admin memperbarui angka stat & status kartu',
      (tester) async {
        _setPhoneViewport(tester);
        final repo = _ControllableRepository();

        await tester.pumpWidget(
          _wrapPage(
            AdminDashboardPage(
              repository: repo,
              adminName: 'Ayu',
              now: DateTime(2026, 6, 20, 9, 0),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap tombol bundar '>' pada kartu Kontributor pertama
        await tester.tap(
          find.byKey(const Key('dashboard_card_review_action')).first,
        );
        await tester.pumpAndSettle();

        await _scrollSheetTo(tester, find.byKey(const Key('review_action_approve')));
        await tester.tap(find.byKey(const Key('review_action_approve')));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Ya, lanjut'));
        await tester.pumpAndSettle();

        expect(repo.updateCallCount, 1);
        expect(
          find.descendant(
            of: find.byKey(const Key('stat_card_contributor')),
            matching: find.text('1'),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'tap 3 action card di Hero Card langsung mengarahkan ke section tujuan tanpa membuka screen baru & tanpa tag Fokus',
      (tester) async {
        _setPhoneViewport(tester);
        final repo = _ControllableRepository();

        await tester.pumpWidget(
          _wrapPage(AdminDashboardPage(repository: repo)),
        );
        await tester.pumpAndSettle();

        expect(find.text('Fokus'), findsNothing);

        // Tap kartu Admin Wilayah -> tetap di AdminDashboardPage tanpa tag Fokus
        await tester.tap(find.byKey(const Key('stat_card_regional_admin')));
        await tester.pumpAndSettle();

        expect(find.byType(AdminDashboardPage), findsOneWidget);
        expect(find.byType(ContributorReviewPage), findsNothing);
        expect(find.text('Fokus'), findsNothing);

        // Tap kartu Laporan -> tetap di AdminDashboardPage & tampil section Laporan
        await tester.ensureVisible(find.byKey(const Key('stat_card_report')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('stat_card_report')));
        await tester.pumpAndSettle();

        expect(find.byType(ContributorReviewPage), findsNothing);
        expect(find.text('Belum ada pengajuan laporan'), findsOneWidget);
        expect(find.text('Fokus'), findsNothing);

        // Tap kartu Kontributor -> tetap di AdminDashboardPage tanpa tag Fokus
        await tester.ensureVisible(
          find.byKey(const Key('stat_card_contributor')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('stat_card_contributor')));
        await tester.pumpAndSettle();

        expect(find.byType(ContributorReviewPage), findsNothing);
        expect(find.text('Fokus'), findsNothing);
      },
    );

    testWidgets(
      'AdminDashboardPage menangani error state & layar sempit 360x800 tanpa overflow saat mengarahkan ke section',
      (tester) async {
        _setPhoneViewport(tester, size: const Size(360, 800));
        final repo = _ControllableRepository(shouldFailFetch: true);

        await tester.pumpWidget(
          _wrapPage(
            AdminDashboardPage(
              repository: repo,
              adminName: 'Ayu Rahmawati Kusumaningrum',
              regionName: 'Kabupaten Sleman, DI Yogyakarta',
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Gagal memuat data pengajuan.'), findsOneWidget);
        repo.shouldFailFetch = false;
        await tester.tap(find.text('Coba lagi'));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('stat_card_regional_admin')));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(DashboardApplicationCard), findsWidgets);
        expect(find.text('Fokus'), findsNothing);
      },
    );
  });

  group('ContributorReviewPage filter Terlama/Terbaru high-fidelity & states', () {
    testWidgets(
      'menampilkan segmented filter Terlama & Terbaru tanpa chip status lama',
      (tester) async {
        _setPhoneViewport(tester);
        final repo = _ControllableRepository();
        repo.fetchCompleter = Completer<List<ContributorApplication>>();

        await tester.pumpWidget(
          _wrapPage(ContributorReviewPage(repository: repo)),
        );

        expect(find.text('AKSES WILAYAH'), findsOneWidget);
        expect(find.text('Verifikasi identitas'), findsOneWidget);
        expect(find.text('Verifikasi berjenjang'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        repo.fetchCompleter!.complete(repo.items);
        repo.fetchCompleter = null;
        await tester.pumpAndSettle();

        // Chip status lama tidak ada; filter Terlama & Terbaru tampil jelas
        expect(find.text('Disetujui (0)'), findsNothing);
        expect(find.text('Semua (4)'), findsNothing);
        expect(find.text('4 pengajuan menunggu'), findsOneWidget);
        expect(find.byKey(const Key('sort_oldest_button')), findsOneWidget);
        expect(find.byKey(const Key('sort_newest_button')), findsOneWidget);

        // Urutan default Terlama: Dwi Prasetyo (17 Juni) di paling atas
        final cardsOldest = tester
            .widgetList<ContributorApplicationCard>(
              find.byType(ContributorApplicationCard),
            )
            .toList();
        expect(cardsOldest.first.application.fullName, 'Dwi Prasetyo');

        // Tap segmen Terbaru -> Budi Santoso (20 Juni) di paling atas
        await tester.tap(find.byKey(const Key('sort_newest_button')));
        await tester.pumpAndSettle();
        final cardsNewest = tester
            .widgetList<ContributorApplicationCard>(
              find.byType(ContributorApplicationCard),
            )
            .toList();
        expect(cardsNewest.first.application.fullName, 'Budi Santoso');

        // Kembali ke segmen Terlama
        await tester.tap(find.byKey(const Key('sort_oldest_button')));
        await tester.pumpAndSettle();
        final cardsOldestAgain = tester
            .widgetList<ContributorApplicationCard>(
              find.byType(ContributorApplicationCard),
            )
            .toList();
        expect(cardsOldestAgain.first.application.fullName, 'Dwi Prasetyo');
      },
    );

    testWidgets('menampilkan error state dan tombol Coba lagi berfungsi', (
      tester,
    ) async {
      _setPhoneViewport(tester);
      final repo = _ControllableRepository(shouldFailFetch: true);

      await tester.pumpWidget(
        _wrapPage(ContributorReviewPage(repository: repo)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Gagal memuat pengajuan kontributor.'), findsOneWidget);
      expect(find.text('Coba lagi'), findsOneWidget);

      repo.shouldFailFetch = false;
      await tester.tap(find.text('Coba lagi'));
      await tester.pumpAndSettle();

      expect(find.text('Dwi Prasetyo'), findsOneWidget);
    });

    testWidgets('menampilkan empty state saat daftar kosong', (tester) async {
      _setPhoneViewport(tester);
      final repo = _ControllableRepository(items: const []);

      await tester.pumpWidget(
        _wrapPage(ContributorReviewPage(repository: repo)),
      );
      await tester.pumpAndSettle();

      expect(find.text('0 pengajuan menunggu'), findsOneWidget);
      expect(find.text('Belum ada pengajuan kontributor.'), findsOneWidget);
    });

    testWidgets('layar sempit 360x800 dengan teks panjang tidak overflow', (
      tester,
    ) async {
      _setPhoneViewport(tester, size: const Size(360, 800));
      final repo = _ControllableRepository(
        items: [
          ContributorApplication(
            id: '1',
            fullName:
                'Raden Mas Suryokusumo Adipati Prawirodirjo Kusumaningrat',
            roleLabel: 'Admin Wilayah Khusus',
            position: 'Koordinator Pemberdayaan Masyarakat Desa Terpadu',
            institution:
                'Pemerintah Kalurahan Caturtunggal Kapanewon Depok Kabupaten Sleman',
            email: 'panjang@teranusa.id',
            phone: '082222222222',
            region: 'Depok, Kabupaten Sleman, Daerah Istimewa Yogyakarta',
            reason: 'Berbagi informasi kegiatan masyarakat',
            submittedAt: DateTime(2026, 6, 17, 11, 5),
          ),
        ],
      );

      await tester.pumpWidget(
        _wrapPage(ContributorReviewPage(repository: repo)),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('RK'), findsOneWidget);
    });
  });

  group('ReviewSheet popup read-only sesuai tinjaudata.png & 3 aksi review', () {
    testWidgets(
      'Approve flow: background gelap, grup PENGAJUAN & KONTAK, 3 tombol sejajar (Tolak | Pending | Setujui), catatan opsional & snackbar',
      (tester) async {
        _setPhoneViewport(tester);
        final repo = _ControllableRepository();

        await tester.pumpWidget(
          _wrapPage(ContributorReviewPage(repository: repo)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Tinjau data').first);
        await tester.pumpAndSettle();

        // Verifikasi background digelapkan saat sheet terbuka
        final barriers = tester
            .widgetList<ModalBarrier>(find.byType(ModalBarrier))
            .where((b) => b.color == Colors.black.withValues(alpha: 0.65));
        expect(barriers, isNotEmpty);

        // Data read-only dikelompokkan PENGAJUAN & KONTAK; catatan tersembunyi default
        expect(find.text('PENGAJUAN'), findsOneWidget);
        expect(find.text('KONTAK'), findsOneWidget);
        expect(find.text('Instansi'), findsOneWidget);
        expect(find.text('Pemerintah Desa Tirtomartani'), findsWidgets);
        expect(find.text('+ Tambah catatan (opsional)'), findsOneWidget);
        expect(find.byType(TextField), findsNothing);

        final rejectFinder = find.byKey(const Key('review_action_reject'));
        final pendingFinder = find.byKey(const Key('review_action_pending'));
        final approveFinder = find.byKey(const Key('review_action_approve'));
        await _scrollSheetTo(tester, approveFinder);

        // Verifikasi 3 tombol sejajar horizontal: Tolak (kiri) | Pending (tengah) | Setujui (kanan)
        final rejectRect = tester.getRect(rejectFinder);
        final pendingRect = tester.getRect(pendingFinder);
        final approveRect = tester.getRect(approveFinder);
        expect(rejectRect.top, closeTo(pendingRect.top, 2.0));
        expect(pendingRect.top, closeTo(approveRect.top, 2.0));
        expect(rejectRect.left, lessThan(pendingRect.left));
        expect(pendingRect.left, lessThan(approveRect.left));

        await tester.tap(approveFinder);
        await tester.pumpAndSettle();

        expect(find.text('Setujui pengajuan?'), findsOneWidget);
        await tester.tap(find.text('Ya, lanjut'));
        await tester.pumpAndSettle();

        expect(repo.updateCallCount, 1);
        expect(find.text('Pengajuan disetujui'), findsOneWidget);
        expect(find.text('3 pengajuan menunggu'), findsOneWidget);

        // Buka ulang kartu yang sudah disetujui -> tidak ada tombol aksi & 0 TextField
        await tester.tap(find.text('Tinjau data').first);
        await tester.pumpAndSettle();

        await _scrollSheetTo(
          tester,
          find.text('Pengajuan ini sudah disetujui.'),
        );
        expect(find.byType(TextField), findsNothing);
        expect(approveFinder, findsNothing);
        expect(pendingFinder, findsNothing);
        expect(rejectFinder, findsNothing);
      },
    );

    testWidgets(
      'Reject wajib alasan (otomatis buka field catatan); jika diisi -> konfirmasi -> status Ditolak',
      (tester) async {
        _setPhoneViewport(tester);
        final repo = _ControllableRepository(
          items: [_ControllableRepository._sampleItems().first],
        );

        await tester.pumpWidget(
          _wrapPage(ContributorReviewPage(repository: repo)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Tinjau data').first);
        await tester.pumpAndSettle();

        final rejectFinder = find.byKey(const Key('review_action_reject'));
        await _scrollSheetTo(tester, rejectFinder);
        await tester.tap(rejectFinder);
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Alasan penolakan wajib diisi'), findsOneWidget);
        expect(find.text('Tolak pengajuan?'), findsNothing);
        expect(repo.updateCallCount, 0);

        await tester.enterText(
          find.byType(TextField),
          'Dokumen pendukung belum lengkap',
        );
        await _scrollSheetTo(tester, rejectFinder);
        await tester.tap(rejectFinder);
        await tester.pumpAndSettle();

        expect(find.text('Tolak pengajuan?'), findsOneWidget);
        await tester.tap(find.text('Ya, lanjut'));
        await tester.pumpAndSettle();

        expect(repo.updateCallCount, 1);
        expect(find.text('0 pengajuan menunggu'), findsOneWidget);
        expect(find.text('Ditolak'), findsOneWidget);

        await tester.tap(find.text('Tinjau data').first);
        await tester.pumpAndSettle();

        await _scrollSheetTo(
          tester,
          find.text('Catatan: Dokumen pendukung belum lengkap'),
        );
        expect(
          find.text('Catatan: Dokumen pendukung belum lengkap'),
          findsOneWidget,
        );
        expect(rejectFinder, findsNothing);
      },
    );

    testWidgets(
      'Pending menyimpan catatan (lewat + Tambah catatan) & prefill saat dibuka ulang',
      (tester) async {
        _setPhoneViewport(tester);
        final repo = _ControllableRepository(
          items: [_ControllableRepository._sampleItems().first],
        );

        await tester.pumpWidget(
          _wrapPage(ContributorReviewPage(repository: repo)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Tinjau data').first);
        await tester.pumpAndSettle();

        final toggleNote = find.byKey(const Key('toggle_admin_note_button'));
        await _scrollSheetTo(tester, toggleNote);
        await tester.tap(toggleNote);
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextField),
          'Menunggu konfirmasi kepala desa',
        );
        final pendingFinder = find.byKey(const Key('review_action_pending'));
        await _scrollSheetTo(tester, pendingFinder);
        await tester.tap(pendingFinder);
        await tester.pumpAndSettle();

        expect(find.text('Tandai tetap menunggu?'), findsOneWidget);
        await tester.tap(find.text('Ya, lanjut'));
        await tester.pumpAndSettle();

        expect(repo.updateCallCount, 1);
        expect(find.text('1 pengajuan menunggu'), findsOneWidget);

        await tester.tap(find.text('Tinjau data').first);
        await tester.pumpAndSettle();

        await _scrollSheetTo(tester, find.byType(TextField));
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.controller?.text, 'Menunggu konfirmasi kepala desa');
        expect(find.textContaining('Terakhir ditinjau'), findsOneWidget);
      },
    );

    testWidgets('gagal menyimpan: sheet tetap terbuka dan tampil pesan error', (
      tester,
    ) async {
      _setPhoneViewport(tester);
      final repo = _ControllableRepository(shouldFailUpdate: true);

      await tester.pumpWidget(
        _wrapPage(ContributorReviewPage(repository: repo)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tinjau data').first);
      await tester.pumpAndSettle();

      final approveFinder = find.byKey(const Key('review_action_approve'));
      await _scrollSheetTo(tester, approveFinder);
      await tester.tap(approveFinder);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ya, lanjut'));
      await tester.pumpAndSettle();

      expect(
        find.text('Gagal menyimpan keputusan. Silakan coba lagi.'),
        findsOneWidget,
      );
      expect(approveFinder, findsOneWidget);
    });
  });

  group('Integrasi ProfileMenu tanpa bubble notifikasi -> AdminDashboardPage', () {
    UserProfile makeUser({required bool isAdmin}) => UserProfile(
      userId: 'u-1',
      name: 'Ayu Rahmawati',
      username: 'ayurahma',
      email: 'ayu@teranusa.id',
      phone: '08123456789',
      regionId: 'r-1',
      isContributor: true,
      isAdmin: isAdmin,
    );

    testWidgets(
      'non-admin tidak melihat menu; admin melihat Dashboard Admin tanpa bubble notifikasi -> buka dashboard -> review -> sinkron',
      (tester) async {
        _setPhoneViewport(tester);
        final fakeRepo = _ControllableRepository();
        void noop() {}

        Widget buildHost(UserProfile user) => ProviderScope(
          overrides: [
            contributorApplicationRepositoryProvider.overrideWithValue(
              fakeRepo,
            ),
          ],
          child: Consumer(
            builder: (context, ref, _) => MaterialApp(
              theme: AppTheme.light,
              home: Scaffold(
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(14),
                  child: ProfileMenu(
                    isOnline: true,
                    isContributor: user.isContributor,
                    onEditProfile: noop,
                    onChangePassword: noop,
                    onSaved: noop,
                    onArchived: noop,
                    onOffline: noop,
                    additionalItem: user.isAdmin
                        ? ContributorApplicationSection(
                            repository: ref.watch(
                              contributorApplicationRepositoryProvider,
                            ),
                            adminName: user.name,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        );

        // Non-admin: tidak tampil di ProfileMenu
        await tester.pumpWidget(buildHost(makeUser(isAdmin: false)));
        await tester.pumpAndSettle();
        expect(find.text('Dashboard Admin'), findsNothing);

        // Admin: tampil di ProfileMenu TANPA bubble notifikasi merah
        await tester.pumpWidget(buildHost(makeUser(isAdmin: true)));
        await tester.pumpAndSettle();
        expect(find.text('Akun Pencari'), findsOneWidget);
        expect(find.text('Dashboard Admin'), findsOneWidget);
        expect(find.byKey(const Key('pending_notification_bubble')), findsNothing);

        // Tap Dashboard Admin -> membuka AdminDashboardPage
        await tester.tap(find.byKey(const Key('admin_dashboard_entry_card')));
        await tester.pumpAndSettle();

        expect(find.byType(AdminDashboardPage), findsOneWidget);
        expect(find.textContaining('Ayu.'), findsOneWidget);

        // Tap stat card Pengajuan Kontributor -> langsung mengarahkan ke section tanpa membuka screen baru
        await tester.tap(find.byKey(const Key('stat_card_contributor')));
        await tester.pumpAndSettle();
        expect(find.byType(AdminDashboardPage), findsOneWidget);
        expect(find.byType(ContributorReviewPage), findsNothing);
        expect(find.text('Fokus'), findsNothing);

        // Setujui 1 pengajuan langsung dari Dashboard Admin -> stat berkurang jadi 1
        await tester.tap(
          find.byKey(const Key('dashboard_card_review_action')).first,
        );
        await tester.pumpAndSettle();
        await _scrollSheetTo(tester, find.byKey(const Key('review_action_approve')));
        await tester.tap(find.byKey(const Key('review_action_approve')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Ya, lanjut'));
        await tester.pumpAndSettle();

        await tester.ensureVisible(
          find.byKey(const Key('stat_card_contributor')),
        );
        await tester.pumpAndSettle();
        expect(find.byType(AdminDashboardPage), findsOneWidget);
        expect(
          find.descendant(
            of: find.byKey(const Key('stat_card_contributor')),
            matching: find.text('1'),
          ),
          findsOneWidget,
        );
      },
    );
  });
}
