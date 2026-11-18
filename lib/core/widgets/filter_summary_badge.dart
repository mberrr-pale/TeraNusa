import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class FilterSummaryBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  const FilterSummaryBadge({
    super.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  factory FilterSummaryBadge.category({
    Key? key,
    required String category,
    required String label,
  }) {
    return FilterSummaryBadge(
      key: key,
      label: label,
      icon: Icons.category_outlined,
      backgroundColor: category == 'Semua'
          ? AppColors.white
          : AppColors.categoryBackground(category),
      foregroundColor: category == 'Semua'
          ? AppColors.secondaryText
          : AppColors.categoryColor(category),
    );
  }

  factory FilterSummaryBadge.region({Key? key, required String label}) {
    return FilterSummaryBadge(
      key: key,
      label: label,
      icon: Icons.location_on_outlined,
      backgroundColor: const Color(0xFFE2F0ED),
      foregroundColor: const Color(0xFF397568),
    );
  }

  factory FilterSummaryBadge.sort({Key? key, required String label}) {
    return FilterSummaryBadge(
      key: key,
      label: label,
      icon: Icons.sort_rounded,
      backgroundColor: const Color(0xFFE8EDF1),
      foregroundColor: const Color(0xFF526779),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foregroundColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foregroundColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
