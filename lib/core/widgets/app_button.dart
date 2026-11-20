import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isExpanded;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? height;
  final Color? textColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isExpanded = true,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.height,
    this.textColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: foregroundColor ?? AppColors.white,

        disabledBackgroundColor:
            disabledBackgroundColor ??
            (backgroundColor ?? AppColors.primary).withValues(alpha: 0.5),

        disabledForegroundColor:
            disabledForegroundColor ??
            (foregroundColor ?? AppColors.white).withValues(alpha: 0.6),

        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        minimumSize: Size(0, height ?? 48),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: borderColor != null
              ? BorderSide(color: borderColor!)
              : BorderSide.none,
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 19,
              height: 19,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.white,
              ),
            )
          : trailingIcon != null
          ? SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Label dan icon 1 tetap berada di tengah.
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: AppTextStyles.button.copyWith(
                          color:
                              textColor ?? foregroundColor ?? AppColors.white,
                        ),
                      ),
                      if (icon != null) ...[
                        const SizedBox(width: 8),
                        Icon(
                          icon,
                          size: 22,
                          color: foregroundColor ?? AppColors.white,
                        ),
                      ],
                    ],
                  ),

                  // Panah berada di ujung kanan tombol.
                  Positioned(
                    right: 0,
                    child: Icon(
                      trailingIcon,
                      size: 22,
                      color: foregroundColor ?? AppColors.white,
                    ),
                  ),
                ],
              ),
            )
          : Row(
              mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTextStyles.button.copyWith(
                    color: textColor ?? foregroundColor ?? AppColors.white,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    icon,
                    size: 18,
                    color: foregroundColor ?? AppColors.white,
                  ),
                ],
              ],
            ),
    );

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
