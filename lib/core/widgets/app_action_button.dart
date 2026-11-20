import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool isActive;
  final bool isExpanded;
  final double? height;

  const AppActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.iconColor,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
    this.isActive = false,
    this.isExpanded = true,
    this.height = 76,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.primary;

    final effectiveTextColor = textColor ?? AppColors.primary;

    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.white,
          foregroundColor: effectiveTextColor,
          side: BorderSide(color: borderColor ?? AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26, color: effectiveIconColor),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.button.copyWith(
                color: effectiveTextColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
