import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

enum AppBadgeType { primary, success, warning, error, info, neutral }

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeType type;
  final IconData? icon;
  final bool outlined;

  const AppBadge({
    super.key,
    required this.label,
    this.type = AppBadgeType.primary,
    this.icon,
    this.outlined = false,
  });

  Color get badgeColor {
    switch (type) {
      case AppBadgeType.primary:
        return AppColors.primary;
      case AppBadgeType.success:
        return const Color(0xFF198754);
      case AppBadgeType.warning:
        return const Color(0xFFE69A21);
      case AppBadgeType.error:
        return AppColors.error;
      case AppBadgeType.info:
        return const Color(0xFF2878C8);
      case AppBadgeType.neutral:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = badgeColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: outlined ? Border.all(color: color) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
