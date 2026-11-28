import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

import '../pages/admin_dashboard_page.dart';
import 'hero_stat_card.dart';

class DashboardHeroCard extends StatelessWidget {
  final String greeting;
  final String regionName;

  final int pendingContributorCount;
  final int pendingRegionalAdminCount;
  final int pendingReportCount;

  final DashboardSection? selectedSection;

  final VoidCallback onTapContributor;
  final VoidCallback onTapRegionalAdmin;
  final VoidCallback onTapReport;

  const DashboardHeroCard({
    super.key,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      child: HeroStatCard(
                        key: const Key('stat_card_contributor'),
                        count: pendingContributorCount,
                        label: 'Pengajuan\nKontributor',
                        isSelected:
                            selectedSection == DashboardSection.contributor,
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
                      child: HeroStatCard(
                        key: const Key('stat_card_regional_admin'),
                        count: pendingRegionalAdminCount,
                        label: 'Verifikasi\nAdmin Wilayah',
                        isSelected:
                            selectedSection == DashboardSection.regionalAdmin,
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
                      child: HeroStatCard(
                        key: const Key('stat_card_report'),
                        count: pendingReportCount,
                        label: 'Pengajuan\nLaporan',
                        isSelected: selectedSection == DashboardSection.report,
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
