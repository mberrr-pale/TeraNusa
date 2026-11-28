import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/opportunity_review.dart';
import 'opportunity_review_card.dart';
import 'empty_report_section.dart';

class OpportunityReviewSection extends StatelessWidget {
  final List<OpportunityReview> items;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;
  final ValueChanged<OpportunityReview> onReview;

  const OpportunityReviewSection({
    super.key,
    required this.items,
    this.isLoading = false,
    this.errorMessage,
    required this.onRetry,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null && items.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Text(
              'Gagal memuat laporan peluang.',
              style: TextStyle(color: AppColors.secondaryText, fontSize: 13),
            ),
            TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ),
      );
    }

    if (items.isEmpty) {
      return const EmptyReportSection();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Review Report Peluang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${items.length} laporan',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OpportunityReviewCard(
              opportunity: item,
              onTap: () => onReview(item),
            ),
          ),
        ),
      ],
    );
  }
}
