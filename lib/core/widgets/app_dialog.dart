import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppDialogType { info, confirm, warning, success }

class AppDialog {
  AppDialog._();

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    AppDialogType type = AppDialogType.info,
    String confirmLabel = 'Mengerti',
    String cancelLabel = 'Batal',
    bool showCloseButton = true,
    VoidCallback? onConfirm,
  }) {
    final IconData icon;
    final Color accentColor;

    switch (type) {
      case AppDialogType.info:
        icon = Icons.info_outline_rounded;
        accentColor = AppColors.primary;
        break;
      case AppDialogType.confirm:
        icon = Icons.help_outline_rounded;
        accentColor = AppColors.primary;
        break;
      case AppDialogType.warning:
        icon = Icons.warning_amber_rounded;
        accentColor = AppColors.event;
        break;
      case AppDialogType.success:
        icon = Icons.check_circle_outline_rounded;
        accentColor = AppColors.primary;
        break;
    }

    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (dialogContext) {
        return Stack(
          children: [
            // BLUR BACKGROUND
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.black.withValues(alpha: 0.38)),
              ),
            ),

            // DIALOG CARD
            Center(
              child: Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // HEADER
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 10, 12, 10),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(icon, color: accentColor, size: 19),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                title,
                                style: AppTextStyles.sectionTitle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (showCloseButton)
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    Navigator.pop(dialogContext, false);
                                  },
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    size: 16,
                                  ),
                                  color: AppColors.secondaryText,
                                  tooltip: 'Tutup',
                                ),
                              ),
                          ],
                        ),
                      ),

                      // HEADER DIVIDER
                      Divider(height: 1, thickness: 1, color: AppColors.border),

                      // CONTENT
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 14, 18, 35),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            message,
                            style: AppTextStyles.body.copyWith(
                              height: 2,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ),
                      ),

                      // CONTENT DIVIDER
                      Divider(height: 1, thickness: 1, color: AppColors.border),

                      // ACTIONS
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 20, 12, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (type == AppDialogType.confirm) ...[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext, false);
                                },
                                child: Text(
                                  cancelLabel,
                                  style: AppTextStyles.secondary,
                                ),
                              ),
                              const SizedBox(width: 5),
                            ],
                            FilledButton(
                              onPressed: () {
                                Navigator.pop(dialogContext, true);
                                onConfirm?.call();
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 11,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                confirmLabel,
                                style: AppTextStyles.button,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
