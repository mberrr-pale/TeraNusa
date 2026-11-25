import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/states/app_loading.dart';
import '../models/contributor_application.dart';
import '../repository/contributor_application_repository.dart';
import '../widgets/dashboard_application_card.dart';
import '../widgets/review_sheet.dart';

enum _DashboardSection { contributor, regionalAdmin, report }

/// Layar Dashboard Admin yang berfokus pada tindakan pengajuan (Kontributor,
/// Admin Wilayah, dan Laporan kosong) selaras dengan Dashboard Admin .png.
class AdminDashboardPage extends StatefulWidget {
  final ContributorApplicationRepository repository;
  final String? adminName;
  final String? regionName;
  final DateTime? now;

  const AdminDashboardPage({
    super.key,
    required this.repository,
    this.adminName,
    this.regionName,
    this.now,
  });

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  late Future<List<ContributorApplication>> _future;
  late final AnimationController _highlightPulseController;
  late final Animation<double> _highlightIntensity;

  final GlobalKey _contributorSectionKey = GlobalKey();
  final GlobalKey _regionalAdminSectionKey = GlobalKey();
  final GlobalKey _reportSectionKey = GlobalKey();

  _DashboardSection? _highlightedSection;
  bool _contributorNewestFirst = true;
  bool _regionalAdminNewestFirst = true;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.getApplications();
    _highlightPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );
    _highlightIntensity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 35),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 45,
      ),
    ]).animate(_highlightPulseController);

    _highlightPulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _highlightedSection = null);
      }
    });
  }

  @override
  void dispose() {
    _highlightPulseController.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _future = widget.repository.getApplications();
    });
  }

  Future<void> _refresh() async {
    final future = widget.repository.getApplications();
    setState(() {
      _future = future;
    });
    try {
      await future;
    } catch (_) {
      // Error state ditangani oleh FutureBuilder.
    }
  }

  String _greetingText() {
    final current = widget.now ?? DateTime.now();
    final hour = current.hour;
    final prefix = switch (hour) {
      >= 4 && < 11 => 'Selamat pagi',
      >= 11 && < 15 => 'Selamat siang',
      >= 15 && < 18 => 'Selamat sore',
      _ => 'Selamat malam',
    };

    final trimmed = widget.adminName?.trim() ?? '';
    final firstName = trimmed.isEmpty
        ? 'Admin'
        : trimmed.split(RegExp(r'\s+')).first;
    return '$prefix, $firstName.';
  }

  String get _regionLabel {
    final trimmed = widget.regionName?.trim() ?? '';
    return trimmed.isEmpty ? 'Kabupaten Sleman' : trimmed;
  }

  List<ContributorApplication> _sortApplications(
    List<ContributorApplication> items, {
    required bool newestFirst,
  }) {
    final copy = List<ContributorApplication>.of(items);
    copy.sort(
      (a, b) => newestFirst
          ? b.submittedAt.compareTo(a.submittedAt)
          : a.submittedAt.compareTo(b.submittedAt),
    );
    return copy;
  }

  void _focusSection(_DashboardSection section) {
    setState(() => _highlightedSection = section);
    _highlightPulseController.forward(from: 0.0);

    final targetKey = switch (section) {
      _DashboardSection.contributor => _contributorSectionKey,
      _DashboardSection.regionalAdmin => _regionalAdminSectionKey,
      _DashboardSection.report => _reportSectionKey,
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final targetContext = targetKey.currentContext;
      if (targetContext == null) return;
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        alignment: 0.08,
      );
    });
  }

  Future<void> _openReview(ContributorApplication app) async {
    final result = await showReviewSheet(
      context,
      application: app,
      onSubmit: (status, note) => widget.repository.updateStatus(
        id: app.id,
        status: status,
        note: note,
      ),
    );

    if (result == null || !mounted) return;

    _reload();

    final roleTarget = app.category == ApplicationCategory.regionalAdmin
        ? 'admin wilayah'
        : 'kontributor';
    final (title, message) = switch (result) {
      ApplicationStatus.approved => (
        'Pengajuan disetujui',
        '${app.fullName} disetujui sebagai $roleTarget.',
      ),
      ApplicationStatus.rejected => (
        'Pengajuan ditolak',
        'Pengajuan ${app.fullName} telah ditolak.',
      ),
      ApplicationStatus.pending => (
        'Pengajuan ditandai menunggu',
        'Catatan tinjauan untuk ${app.fullName} berhasil disimpan.',
      ),
    };

    AppSnackBar.showSuccess(context, title: title, message: message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader.backTitle(title: 'Dashboard Admin'),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _refresh,
                child: FutureBuilder<List<ContributorApplication>>(
                  future: _future,
                  builder: (context, snapshot) {
                    final allItems =
                        snapshot.data ?? const <ContributorApplication>[];
                    final contributorItems = _sortApplications(
                      allItems
                          .where(
                            (e) =>
                                e.category == ApplicationCategory.contributor,
                          )
                          .toList(),
                      newestFirst: _contributorNewestFirst,
                    );
                    final regionalAdminItems = _sortApplications(
                      allItems
                          .where(
                            (e) =>
                                e.category == ApplicationCategory.regionalAdmin,
                          )
                          .toList(),
                      newestFirst: _regionalAdminNewestFirst,
                    );

                    final pendingContributorCount = contributorItems
                        .where((e) => e.status == ApplicationStatus.pending)
                        .length;
                    final pendingRegionalAdminCount = regionalAdminItems
                        .where((e) => e.status == ApplicationStatus.pending)
                        .length;

                    final isLoading =
                        snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData;

                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(6, 16, 6, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: _DashboardHeroCard(
                            greeting: _greetingText(),
                            regionName: _regionLabel,
                            pendingContributorCount: pendingContributorCount,
                            pendingRegionalAdminCount:
                                pendingRegionalAdminCount,
                            pendingReportCount: 0,
                            selectedSection: _highlightedSection,
                            onTapContributor: () =>
                                _focusSection(_DashboardSection.contributor),
                            onTapRegionalAdmin: () =>
                                _focusSection(_DashboardSection.regionalAdmin),
                            onTapReport: () =>
                                _focusSection(_DashboardSection.report),
                          ),
                        ),
                        const SizedBox(height: 22),

                        // Indikator "Butuh tindakan"
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: _ActionNeededHeader(),
                        ),
                        const SizedBox(height: 8),

                        if (isLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 40,
                            ),
                            child: AppLoading(
                              message: 'Memuat daftar pengajuan...',
                            ),
                          )
                        else if (snapshot.hasError)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: _DashboardErrorCard(onRetry: _reload),
                          )
                        else ...[
                          // Section 1: Pengajuan Kontributor
                          Container(
                            key: _contributorSectionKey,
                            child: _HighlightableSection(
                              key: const Key('dashboard_section_contributor'),
                              isActive:
                                  _highlightedSection ==
                                  _DashboardSection.contributor,
                              intensity: _highlightIntensity,
                              child: _ApplicationHorizontalSection(
                                sectionTitle: 'Pengajuan Kontributor',
                                sortToggleKey: const Key(
                                  'dashboard_sort_contributor',
                                ),
                                newestFirst: _contributorNewestFirst,
                                items: contributorItems,
                                emptyMessage:
                                    'Belum ada pengajuan kontributor.',
                                onToggleSort: () => setState(
                                  () => _contributorNewestFirst =
                                      !_contributorNewestFirst,
                                ),
                                onReview: _openReview,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Section 2: Pengajuan Admin Wilayah
                          Container(
                            key: _regionalAdminSectionKey,
                            child: _HighlightableSection(
                              key: const Key(
                                'dashboard_section_regional_admin',
                              ),
                              isActive:
                                  _highlightedSection ==
                                  _DashboardSection.regionalAdmin,
                              intensity: _highlightIntensity,
                              child: _ApplicationHorizontalSection(
                                sectionTitle: 'Pengajuan Admin Wilayah',
                                sortToggleKey: const Key(
                                  'dashboard_sort_regional_admin',
                                ),
                                newestFirst: _regionalAdminNewestFirst,
                                items: regionalAdminItems,
                                emptyMessage:
                                    'Belum ada pengajuan admin wilayah.',
                                onToggleSort: () => setState(
                                  () => _regionalAdminNewestFirst =
                                      !_regionalAdminNewestFirst,
                                ),
                                onReview: _openReview,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.border,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Section 3: Pengajuan Laporan (dikosongkan)
                        Container(
                          key: _reportSectionKey,
                          child: _HighlightableSection(
                            key: const Key('dashboard_section_report'),
                            isActive:
                                _highlightedSection == _DashboardSection.report,
                            intensity: _highlightIntensity,
                            child: const _EmptyReportSection(),
                          ),
                        ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sorotan tipis sementara (otomatis memudar) hanya saat mengarahkan ke section
/// tujuan agar terasa halus dan tidak mencolok.
class _HighlightableSection extends StatelessWidget {
  final bool isActive;
  final Animation<double> intensity;
  final Widget child;

  const _HighlightableSection({
    super.key,
    required this.isActive,
    required this.intensity,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: intensity,
      builder: (context, child) {
        final t = isActive ? intensity.value : 0.0;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.32 * t),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.16 * t),
              width: 1,
            ),
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}

class _DashboardHeroCard extends StatelessWidget {
  final String greeting;
  final String regionName;
  final int pendingContributorCount;
  final int pendingRegionalAdminCount;
  final int pendingReportCount;
  final _DashboardSection? selectedSection;
  final VoidCallback onTapContributor;
  final VoidCallback onTapRegionalAdmin;
  final VoidCallback onTapReport;

  const _DashboardHeroCard({
    required this.greeting,
    required this.regionName,
    required this.pendingContributorCount,
    required this.pendingRegionalAdminCount,
    required this.pendingReportCount,
    required this.selectedSection,
    required this.onTapContributor,
    required this.onTapRegionalAdmin,
    required this.onTapReport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1F6A26), AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian atas: header hijau verifikator
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pill badge KONTRIBUTOR VERIFIKATOR
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.28),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 14,
                          color: AppColors.white,
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'KONTRIBUTOR VERIFIKATOR',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sapaan
                  Text(
                    greeting,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Lokasi wilayah tepat di bawah sapaan (selaras cardverifikasi.png)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          regionName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.92),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Deskripsi singkat
                  Text(
                    'Tinjau pengajuan akun baru dan jaga kepercayaan warga di wilayahmu.',
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      color: Colors.white.withValues(alpha: 0.88),
                    ),
                  ),
                ],
              ),
            ),

            // Bagian bawah: dock putih high-contrast untuk 3 kartu statistik
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _HeroStatCard(
                        key: const Key('stat_card_contributor'),
                        count: pendingContributorCount,
                        label: 'Pengajuan\nKontributor',
                        isSelected:
                            selectedSection == _DashboardSection.contributor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                        ),
                        onTap: onTapContributor,
                      ),
                    ),
                    const VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: AppColors.border,
                    ),
                    Expanded(
                      child: _HeroStatCard(
                        key: const Key('stat_card_regional_admin'),
                        count: pendingRegionalAdminCount,
                        label: 'Verifikasi\nAdmin Wilayah',
                        isSelected:
                            selectedSection == _DashboardSection.regionalAdmin,
                        borderRadius: BorderRadius.zero,
                        onTap: onTapRegionalAdmin,
                      ),
                    ),
                    const VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: AppColors.border,
                    ),
                    Expanded(
                      child: _HeroStatCard(
                        key: const Key('stat_card_report'),
                        count: pendingReportCount,
                        label: 'Pengajuan\nLaporan',
                        isSelected: selectedSection == _DashboardSection.report,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                        ),
                        onTap: onTapReport,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroStatCard extends StatelessWidget {
  final int count;
  final String label;
  final bool isSelected;
  final BorderRadius borderRadius;
  final VoidCallback onTap;

  const _HeroStatCard({
    super.key,
    required this.count,
    required this.label,
    required this.isSelected,
    required this.borderRadius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasPending = count > 0;

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryLight.withValues(alpha: 0.72)
                : AppColors.surface,
            borderRadius: borderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(11, 14, 9, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            height: 1.05,
                            color: hasPending
                                ? AppColors.primary
                                : AppColors.secondaryText,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.secondaryText.withValues(
                                    alpha: 0.75,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.3,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.heading,
                      ),
                    ),
                  ],
                ),
              ),
              // Garis indikator aktif halus di bagian bawah kolom terpilih
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                height: 3,
                width: double.infinity,
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionNeededHeader extends StatelessWidget {
  const _ActionNeededHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEEDD),
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFE67E22),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Butuh tindakan',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(height: 1, thickness: 1, color: AppColors.border),
      ],
    );
  }
}

class _ApplicationHorizontalSection extends StatelessWidget {
  final String sectionTitle;
  final Key sortToggleKey;
  final bool newestFirst;
  final List<ContributorApplication> items;
  final String emptyMessage;
  final VoidCallback onToggleSort;
  final ValueChanged<ContributorApplication> onReview;

  const _ApplicationHorizontalSection({
    required this.sectionTitle,
    required this.sortToggleKey,
    required this.newestFirst,
    required this.items,
    required this.emptyMessage,
    required this.onToggleSort,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                sectionTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _InlineSortButton(
              key: sortToggleKey,
              newestFirst: newestFirst,
              onTap: onToggleSort,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            backgroundColor: AppColors.surface,
            borderRadius: 16,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.inbox_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    emptyMessage,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          _ApplicationCarousel(items: items, onReview: onReview),
      ],
    );
  }
}

/// Carousel horizontal dengan efek peek kartu berikutnya dan indikator geser
/// halus saat jumlah pengajuan lebih dari 2.
class _ApplicationCarousel extends StatefulWidget {
  final List<ContributorApplication> items;
  final ValueChanged<ContributorApplication> onReview;

  const _ApplicationCarousel({required this.items, required this.onReview});

  @override
  State<_ApplicationCarousel> createState() => _ApplicationCarouselState();
}

class _ApplicationCarouselState extends State<_ApplicationCarousel> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double get _scrollProgress {
    if (!_scrollController.hasClients ||
        !_scrollController.position.hasContentDimensions) {
      return 0.0;
    }
    final maxExtent = _scrollController.position.maxScrollExtent;
    if (maxExtent <= 0) return 0.0;
    return (_scrollController.offset / maxExtent).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final hasOverflowCards = widget.items.length > 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            // Jika >2 kartu, sedikit perampingan memberi efek "peek" kartu ke-3
            // agar langsung terlihat bahwa daftar bisa digeser horizontal.
            final cardWidth = hasOverflowCards
                ? ((constraints.maxWidth - 22) / 2.08)
                      .clamp(154.0, 204.0)
                      .toDouble()
                : ((constraints.maxWidth - 12) / 2)
                      .clamp(156.0, 210.0)
                      .toDouble();

            return SizedBox(
              height: 208,
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                clipBehavior: Clip.none,
                itemCount: widget.items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  return DashboardApplicationCard(
                    application: item,
                    width: cardWidth,
                    onReview: () => widget.onReview(item),
                  );
                },
              ),
            );
          },
        ),
        if (hasOverflowCards) ...[
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 56,
              height: 5,
              padding: const EdgeInsets.all(0.5),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(999),
              ),
              child: AnimatedBuilder(
                animation: _scrollController,
                builder: (context, _) {
                  return Align(
                    alignment: Alignment(-1.0 + (_scrollProgress * 2.0), 0),
                    child: Container(
                      width: 22,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _InlineSortButton extends StatelessWidget {
  final bool newestFirst;
  final VoidCallback onTap;

  const _InlineSortButton({
    super.key,
    required this.newestFirst,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Ubah urutan Terbaru / Terlama',
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.swap_vert_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  newestFirst ? 'Terbaru' : 'Terlama',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyReportSection extends StatelessWidget {
  const _EmptyReportSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pengajuan Laporan',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 17.5,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          key: const Key('empty_report_section'),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          backgroundColor: AppColors.surface,
          borderRadius: 20,
          showShadow: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  size: 24,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Belum ada pengajuan laporan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pengajuan laporan dari warga atau kontributor akan tampil di sini.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.45,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashboardErrorCard extends StatelessWidget {
  final VoidCallback onRetry;

  const _DashboardErrorCard({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      backgroundColor: AppColors.surface,
      borderRadius: 18,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 36,
            color: AppColors.error,
          ),
          const SizedBox(height: 10),
          const Text(
            'Gagal memuat data pengajuan.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 10),
          TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
