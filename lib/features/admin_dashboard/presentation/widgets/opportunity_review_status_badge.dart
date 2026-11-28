import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/opportunity_review.dart';

class OpportunityReviewStatusBadge extends StatelessWidget {
  final OpportunityReviewStatus status;

  const OpportunityReviewStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final IconData icon;

    switch (status) {
      case OpportunityReviewStatus.pendingReview:
        color = Colors.orange;
        icon = Icons.pending_actions;
        break;

      case OpportunityReviewStatus.underReview:
        color = Colors.blue;
        icon = Icons.rate_review_outlined;
        break;

      case OpportunityReviewStatus.approved:
        color = Colors.green;
        icon = Icons.check_circle_outline;
        break;

      case OpportunityReviewStatus.rejected:
        color = Colors.red;
        icon = Icons.cancel_outlined;
        break;

      case OpportunityReviewStatus.takenDown:
        color = Colors.red.shade900;
        icon = Icons.block;
        break;

      case OpportunityReviewStatus.normal:
        color = AppColors.textSecondary;
        icon = Icons.info_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
