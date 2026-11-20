import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

enum AppBadgeType { primary, success, warning, error, info, neutral }

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeType type;
  final IconData? icon;
  final bool outlined;
  final bool fullWidth;
  final double? height;
  final bool bordered;

  const AppBadge({
    super.key,
    required this.label,
    this.type = AppBadgeType.primary,
    this.icon,
    this.outlined = false,
    this.fullWidth = false,
    this.height,
    this.bordered = false,
  });

  Color get badgeColor {
    switch (type) {
      case AppBadgeType.primary:
        return AppColors.primary;
      case AppBadgeType.success:
        return AppColors.primary;
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
      width: fullWidth ? double.infinity : null,
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: fullWidth ? 15 : 11,
        vertical: fullWidth ? 10 : 6,
      ),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(15),
        border: (outlined || bordered)
            ? Border.all(color: color.withValues(alpha: 0.25))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 24, color: color),
            const SizedBox(width: 10),
          ],
          Expanded(
            flex: fullWidth ? 1 : 0,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
