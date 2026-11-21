import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../data/models/opportunity.dart';
import 'verification_badge.dart';

class OpportunityCard extends StatefulWidget {
  final Opportunity opportunity;
  final String regionName;
  final bool isGuest;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;

  const OpportunityCard({
    super.key,
    required this.opportunity,
    required this.regionName,
    this.isGuest = false,
    this.onTap,
    this.onBookmarkTap,
  });

  @override
  State<OpportunityCard> createState() => _OpportunityCardState();
}

class _OpportunityCardState extends State<OpportunityCard> {
  bool _isSaved = false;

  Opportunity get opportunity => widget.opportunity;
  String get regionName => widget.regionName;

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'lowongan':
        return Icons.work_outline;
      case 'event':
        return Icons.calendar_month_outlined;
      case 'pemberdayaan':
        return Icons.groups_outlined;
      case 'produk_jasa':
        return Icons.storefront_outlined;
      default:
        return Icons.article_outlined;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'lowongan':
        return AppColors.job;
      case 'event':
        return AppColors.event;
      case 'pemberdayaan':
        return AppColors.empowerment;
      case 'produk_jasa':
        return AppColors.product;
      default:
        return AppColors.primary;
    }
  }

  Color _getCategoryBackground(String category) {
    switch (category) {
      case 'lowongan':
        return AppColors.jobBackground;
      case 'event':
        return AppColors.eventBackground;
      case 'pemberdayaan':
        return AppColors.empowermentBackground;
      case 'produk_jasa':
        return AppColors.productBackground;
      default:
        return AppColors.empowermentBackground;
    }
  }

  String _getTimeRemaining(DateTime endDate) {
    final difference = endDate.difference(DateTime.now());

    if (difference.inDays > 0) {
      return '${difference.inDays} hari lagi';
    }

    if (difference.inHours > 0) {
      return '${difference.inHours} jam lagi';
    }

    return 'Segera berakhir';
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(opportunity.category);

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withValues(alpha: 0.035),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // CATEGORY ICON
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _getCategoryBackground(opportunity.category),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _getCategoryIcon(opportunity.category),
                color: categoryColor,
                size: 23,
              ),
            ),

            const SizedBox(width: 11),

            // OPPORTUNITY INFORMATION
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerificationBadge(category: opportunity.category),

                  const SizedBox(height: 5),

                  // TITLE
                  Text(
                    opportunity.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cardTitle,
                  ),

                  const SizedBox(height: 7),

                  // REGION
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppColors.secondaryText,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          regionName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.secondary.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 3),

                  // END DATE AND SOURCE
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 13,
                        color: AppColors.secondaryText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getTimeRemaining(opportunity.endDate),
                        style: AppTextStyles.secondary.copyWith(fontSize: 12),
                      ),
                      if (opportunity.source != null &&
                          opportunity.source!.isNotEmpty) ...[
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.info_outline,
                          size: 12,
                          color: AppColors.secondaryText,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            opportunity.source!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.secondary.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 5),

            // BOOKMARK
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isSaved ? AppColors.primary : AppColors.border,
                ),
                borderRadius: BorderRadius.circular(10),
                color: _isSaved
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : AppColors.white,
              ),
              child: IconButton(
                onPressed: () {
                  if (widget.isGuest) {
                    widget.onBookmarkTap?.call();
                    return;
                  }

                  setState(() {
                    _isSaved = !_isSaved;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 32,
                  height: 32,
                ),
                icon: Icon(
                  _isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: _isSaved ? AppColors.primary : AppColors.secondaryText,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
