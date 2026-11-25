import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../models/contributor_application.dart';
import 'status_badge.dart';

/// Kartu pengajuan kontributor full-width (selaras dengan desain verifikasi.png)
/// dengan tata letak high-fidelity: inisial + identitas + badge, blok instansi &
/// wilayah, serta footer waktu pengiriman yang jelas + aksi Tinjau data.
class ContributorApplicationCard extends StatelessWidget {
  final ContributorApplication application;
  final VoidCallback onReview;

  const ContributorApplicationCard({
    super.key,
    required this.application,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    final app = application;

    return AppCard(
      padding: EdgeInsets.zero,
      backgroundColor: AppColors.surface,
      borderRadius: 20,
      showShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Inisial + Nama & Peran + StatusBadge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        app.initials,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            app.fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: AppColors.heading,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${app.roleLabel} · ${app.position}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(status: app.status),
                  ],
                ),

                const SizedBox(height: 14),

                // Blok Instansi & Wilayah
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.apartment_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              app.institution,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.heading,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              app.region,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: AppColors.border),

          // Footer: Keterangan waktu terbaca jelas + tombol Tinjau data >
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 10, 8),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: AppColors.secondaryText,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'Dikirim ${formatSubmittedAt(app.submittedAt)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: onReview,
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Tinjau data',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
