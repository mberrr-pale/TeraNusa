import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/states/app_loading.dart';
import '../../../region/presentation/providers/region_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/contributor_application.dart';
import '../../domain/entities/contributor.dart';
import '../providers/admin_dashboard_provider.dart';
import '../widgets/dashboard_hero_card.dart';
import '../widgets/action_needed_header.dart';
import '../widgets/dashboard_application_section.dart';
import '../widgets/dashboard_error_card.dart';
import '../widgets/review_sheet.dart';
import '../widgets/dashboard_regional_admin_section.dart';
import '../widgets/regional_admin_review_sheet.dart';
import '../widgets/opportunity_review_section.dart';
import 'opportunity_review_detail_page.dart';

enum DashboardSection { contributor, regionalAdmin, report }

class AdminDashboardPage extends ConsumerStatefulWidget {
  final DateTime? now;
  final String? focusSection;

  const AdminDashboardPage({super.key, this.now, this.focusSection});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _highlightIntensity;

  String _adminName = 'Admin';
  String? _regionId;
  String _region = 'Memuat wilayah...';

  final _contributorKey = GlobalKey();
  final _regionalAdminKey = GlobalKey();
  final _reportKey = GlobalKey();

  DashboardSection? _highlightedSection;

  @override
  void initState() {
    super.initState();
    _loadAdminProfile();
    // Animasi highlight
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );

    _highlightIntensity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Hapus highlight setelah animasi selesai
    _pulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _highlightedSection = null;
        });
      }
    });

    // Memuat data pengajuan
    final controller = ref.read(adminDashboardControllerProvider);

    controller.loadApplications();
    controller.loadAvailableContributors();
    controller.loadOpportunityReviews();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      switch (widget.focusSection) {
        case 'contributor':
          _focusSection(DashboardSection.contributor);
          break;

        case 'regionalAdmin':
          _focusSection(DashboardSection.regionalAdmin);
          break;

        case 'report':
          _focusSection(DashboardSection.report);
          break;
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // Greeting berdasarkan waktu
  String get _greeting {
    final hour = (widget.now ?? DateTime.now()).hour;

    final greeting = switch (hour) {
      >= 4 && < 11 => 'Selamat pagi',
      >= 11 && < 15 => 'Selamat siang',
      >= 15 && < 18 => 'Selamat sore',
      _ => 'Selamat malam',
    };

    return '$greeting, $_adminName.';
  }

  // Nama wilayah
  Future<void> _loadAdminProfile() async {
    try {
      final user = await ref.read(authProvider.future);

      if (!mounted) return;

      if (user == null) {
        setState(() {
          _adminName = 'Admin';
          _regionId = null;
          _region = 'Wilayah belum ditentukan';
        });
        return;
      }

      final name = user.name.trim();

      final firstName = name.isEmpty
          ? 'Admin'
          : name.split(RegExp(r'\s+')).first;

      setState(() {
        _adminName = firstName;
        _regionId = user.regionId;
      });

      await _loadRegion();
    } catch (e) {
      debugPrint('Load admin profile error: $e');

      if (!mounted) return;

      setState(() {
        _adminName = 'Admin';
        _region = 'Gagal memuat wilayah';
      });
    }
  }

  // Nama wilayah
  Future<void> _loadRegion() async {
    final regionId = _regionId?.trim() ?? '';

    if (regionId.isEmpty) {
      if (!mounted) return;

      setState(() {
        _region = 'Wilayah belum ditentukan';
      });

      return;
    }

    try {
      final result = await ref.read(getRegionByIdProvider(regionId).future);

      if (!mounted) return;

      if (result == null) {
        setState(() {
          _region = 'Wilayah tidak ditemukan';
        });
        return;
      }

      final parts = [
        result.village,
        result.district,
        result.city,
        result.province,
      ].where((value) => value.trim().isNotEmpty);

      setState(() {
        _region = parts.join(', ');
      });
    } catch (e) {
      debugPrint('Load region error: $e');

      if (!mounted) return;

      setState(() {
        _region = 'Gagal memuat wilayah';
      });
    }
  }

  // promote contributor
  Future<void> _promoteContributor(Contributor contributor) async {
    final controller = ref.read(adminDashboardControllerProvider);

    final result = await showRegionalAdminReviewSheet(
      context,
      contributor: contributor,
      onSubmit: () async {
        await controller.promoteContributor(contributor.userId);
      },
    );

    if (!mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kontributor berhasil dijadikan Admin Wilayah.'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  // Navigasi ke section sekaligus memberikan highlight
  void _focusSection(DashboardSection section) {
    setState(() {
      _highlightedSection = section;
    });

    _pulseController.forward(from: 0);

    final key = switch (section) {
      DashboardSection.contributor => _contributorKey,
      DashboardSection.regionalAdmin => _regionalAdminKey,
      DashboardSection.report => _reportKey,
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || key.currentContext == null) return;

      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        alignment: 0.08,
      );
    });
  }

  // Membuka detail review pengajuan
  Future<void> _openReview(ContributorApplication application) async {
    final controller = ref.read(adminDashboardControllerProvider);

    final result = await showReviewSheet(
      context,
      application: application,
      onSubmit: (status, note) async {
        await controller.reviewApplication(
          id: application.id,
          status: status,
          note: note,
        );
      },
    );

    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(switch (result) {
            ApplicationStatus.approved => 'Pengajuan berhasil disetujui.',
            ApplicationStatus.rejected => 'Pengajuan berhasil ditolak.',
            ApplicationStatus.pending => 'Pengajuan berhasil diperbarui.',
          }),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  // Widget pembungkus efek highlight
  Widget _buildHighlightSection({
    required DashboardSection section,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: _highlightIntensity,
      builder: (context, child) {
        final highlighted = _highlightedSection == section;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: highlighted
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(
                        alpha: 0.18 * (1 - _highlightIntensity.value),
                      ),
                      blurRadius: 20 * _highlightIntensity.value,
                      spreadRadius: 2 * _highlightIntensity.value,
                    ),
                  ]
                : null,
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(adminDashboardControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader.backTitle(title: 'Dashboard Admin'),

            Expanded(
              child: ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  final state = controller.state;

                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: controller.refresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // HERO DASHBOARD
                          DashboardHeroCard(
                            greeting: _greeting,
                            regionName: _region,
                            pendingContributorCount:
                                state.pendingContributorCount,
                            pendingRegionalAdminCount:
                                state.pendingRegionalAdminCount,
                            pendingReportCount: state.pendingReportCount,
                            selectedSection: _highlightedSection,

                            onTapContributor: () {
                              _focusSection(DashboardSection.contributor);
                            },

                            onTapRegionalAdmin: () {
                              _focusSection(DashboardSection.regionalAdmin);
                            },

                            onTapReport: () {
                              _focusSection(DashboardSection.report);
                            },
                          ),

                          const SizedBox(height: 22),

                          const ActionNeededHeader(),

                          const SizedBox(height: 12),

                          // LOADING
                          if (state.isLoading && state.applications.isEmpty)
                            const AppLoading(
                              message: 'Memuat daftar pengajuan...',
                            )
                          // ERROR
                          else if (state.errorMessage != null &&
                              state.applications.isEmpty)
                            DashboardErrorCard(
                              onRetry: () {
                                controller.loadApplications();
                              },
                            )
                          // DATA PENGAJUAN
                          else ...[
                            // SECTION KONTRIBUTOR
                            _buildHighlightSection(
                              section: DashboardSection.contributor,
                              child: DashboardApplicationSection(
                                key: _contributorKey,
                                title: 'Pengajuan Kontributor',
                                items: controller.contributorApplications,
                                newestFirst: state.contributorNewestFirst,
                                onToggleSort: controller.toggleContributorSort,
                                onReview: _openReview,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // SECTION ADMIN WILAYAH
                            _buildHighlightSection(
                              section: DashboardSection.regionalAdmin,
                              child: DashboardRegionalAdminSection(
                                key: _regionalAdminKey,
                                items: controller.regionalAdminCandidates,
                                newestFirst: state.regionalAdminNewestFirst,
                                isLoading: state.isLoadingContributors,
                                isPromoting: state.isReviewing,
                                errorMessage: state.contributorErrorMessage,
                                onToggleSort:
                                    controller.toggleRegionalAdminSort,
                                onRetry: controller.loadAvailableContributors,
                                onPromote: _promoteContributor,
                              ),
                            ),
                          ],

                          const SizedBox(height: 12),

                          // SECTION LAPORAN
                          _buildHighlightSection(
                            section: DashboardSection.report,
                            child: OpportunityReviewSection(
                              key: _reportKey,
                              items: state.opportunityReviews,
                              isLoading: state.isLoadingOpportunityReviews,
                              errorMessage: state.opportunityReviewErrorMessage,
                              onRetry: controller.loadOpportunityReviews,
                              onReview: (opportunity) async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OpportunityReviewDetailPage(
                                      opportunityId: opportunity.opportunityId,
                                    ),
                                  ),
                                );

                                if (!mounted) return;

                                controller.loadOpportunityReviews();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
