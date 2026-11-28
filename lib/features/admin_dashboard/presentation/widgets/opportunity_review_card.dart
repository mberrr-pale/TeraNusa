import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/opportunity_review.dart';
import 'opportunity_review_status_badge.dart';

class OpportunityReviewCard extends StatelessWidget {
  final OpportunityReview opportunity;
  final VoidCallback onTap;

  const OpportunityReviewCard({
    super.key,
    required this.opportunity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      opportunity.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                opportunity.category,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  OpportunityReviewStatusBadge(
                    status: opportunity.reviewStatus,
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.flag_outlined,
                    size: 16,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${opportunity.reportCount} laporan',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              if (opportunity.newReportCount > 0) ...[
                const SizedBox(height: 10),
                Text(
                  '${opportunity.newReportCount} laporan baru sejak review terakhir',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
