import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/opportunity_report.dart';

class OpportunityReportCard extends StatelessWidget {
  final OpportunityReport report;
  final VoidCallback onTap;

  const OpportunityReportCard({
    super.key,
    required this.report,
    required this.onTap,
  });

  Color get _statusColor {
    switch (report.status) {
      case ReportStatus.pending:
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  String get _statusLabel => report.status.label;

  @override
  Widget build(BuildContext context) {
    final description = report.description?.trim();

    return AppCard(
      padding: EdgeInsets.zero,
      backgroundColor: AppColors.surface,
      borderRadius: 20,
      showShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Row(
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
                  child: const Icon(
                    Icons.flag_outlined,
                    color: AppColors.primary,
                    size: 23,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.reason,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.heading,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Laporan peluang',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // STATUS BADGE
                //   Container(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 10,
                //       vertical: 5,
                //     ),
                //     decoration: BoxDecoration(
                //       color: _statusColor.withValues(alpha: 0.10),
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     child: Text(
                //       _statusLabel,
                //       style: TextStyle(
                //         fontSize: 10,
                //         fontWeight: FontWeight.w700,
                //         color: _statusColor,
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),

          // INFORMASI LAPORAN
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.description_outlined,
                        size: 19,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          description?.isNotEmpty == true
                              ? description!
                              : 'Tidak ada deskripsi tambahan.',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: AppColors.heading,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const Divider(height: 1, color: AppColors.border),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        size: 17,
                        color: AppColors.secondaryText,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dilaporkan oleh',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.secondaryText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              report.profiles['name']?.toString() ?? 'Pengguna',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.heading,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1, thickness: 1, color: AppColors.border),

          // FOOTER
          //   Padding(
          //     padding: const EdgeInsets.fromLTRB(16, 8, 10, 8),
          //     child: Row(
          //       children: [
          //         const Icon(
          //           Icons.flag_outlined,
          //           size: 14,
          //           color: AppColors.secondaryText,
          //         ),
          //         const SizedBox(width: 5),
          //         const Expanded(
          //           child: Text(
          //             'Review laporan peluang',
          //             maxLines: 1,
          //             overflow: TextOverflow.ellipsis,
          //             style: TextStyle(
          //               fontSize: 11.5,
          //               fontWeight: FontWeight.w500,
          //               color: AppColors.secondaryText,
          //             ),
          //           ),
          //         ),

          //         const SizedBox(width: 8),

          //         Material(
          //           color: Colors.transparent,
          //           borderRadius: BorderRadius.circular(8),
          //           child: InkWell(
          //             onTap: onTap,
          //             borderRadius: BorderRadius.circular(8),
          //             child: const Padding(
          //               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          //               child: Row(
          //                 mainAxisSize: MainAxisSize.min,
          //                 children: [
          //                   Text(
          //                     'Tinjau laporan',
          //                     style: TextStyle(
          //                       fontSize: 12.5,
          //                       fontWeight: FontWeight.w700,
          //                       color: AppColors.primary,
          //                     ),
          //                   ),
          //                   SizedBox(width: 2),
          //                   Icon(
          //                     Icons.chevron_right_rounded,
          //                     size: 18,
          //                     color: AppColors.primary,
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
        ],
      ),
    );
  }
}
