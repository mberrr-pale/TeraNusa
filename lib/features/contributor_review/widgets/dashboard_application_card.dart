import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/contributor_application.dart';
import 'status_badge.dart';

/// Kartu pengajuan high-fidelity untuk carousel horizontal pada
/// [AdminDashboardPage], diselaraskan dengan verifikasi kontributor.png.
class DashboardApplicationCard extends StatelessWidget {
  final ContributorApplication application;
  final VoidCallback onReview;
  final double width;

  const DashboardApplicationCard({
    super.key,
    required this.application,
    required this.onReview,
    this.width = 180,
  });

  @override
  Widget build(BuildContext context) {
    final app = application;

    return SizedBox(
      width: width,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onReview,
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow.withValues(alpha: 0.055),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: AppColors.cardShadow.withValues(alpha: 0.025),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bagian utama kartu
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Baris atas: Avatar inisial gradasi lembut + StatusBadge
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFECF7ED),
                                    Color(0xFFD6EED8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.14,
                                  ),
                                ),
                              ),
                              child: Text(
                                app.initials,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13.5,
                                  letterSpacing: 0.2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: StatusBadge(
                                  status: app.status,
                                  compact: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 13),

                        // Nama pemohon
                        Text(
                          app.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                            height: 1.2,
                            color: AppColors.heading,
                          ),
                        ),
                        const SizedBox(height: 3),

                        // Jabatan
                        Text(
                          app.position,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 9),

                        // Info instansi inline yang bersih
                        Row(
                          children: [
                            Icon(
                              Icons.apartment_outlined,
                              size: 13.5,
                              color: AppColors.primary.withValues(alpha: 0.78),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                app.institution,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary.withValues(
                                    alpha: 0.85,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Pemisah tipis untuk footer yang rapi
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.border.withValues(alpha: 0.7),
                ),

                // Footer: ikon waktu + timestamp ringkas + tombol bundar '>'
                Padding(
                  padding: const EdgeInsets.fromLTRB(13, 9, 11, 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 12,
                        color: AppColors.secondaryText,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          formatSubmittedAt(app.submittedAt),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Tooltip(
                        message: 'Tinjau Data',
                        child: Container(
                          key: const Key('dashboard_card_review_action'),
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.16),
                            ),
                          ),
                          child: const Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
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
