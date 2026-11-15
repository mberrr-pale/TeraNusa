import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppDialogType { info, confirm, warning, success, error }

class AppDialog {
  AppDialog._();

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    AppDialogType type = AppDialogType.info,
    String confirmLabel = 'Mengerti',
    String? cancelLabel,
    bool showCloseButton = true,
    bool barrierDismissible = true,
    Duration? duration,
    FutureOr<void> Function()? onConfirm,
    VoidCallback? onCancel,
  }) {
    final Color accentColor;

    switch (type) {
      case AppDialogType.info:
      case AppDialogType.confirm:
      case AppDialogType.success:
        accentColor = AppColors.primary;
        break;
      case AppDialogType.warning:
        accentColor = AppColors.event;
        break;
      case AppDialogType.error:
        accentColor = Colors.red;
        break;
    }

    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      builder: (dialogContext) {
        return _AppDialogContent(
          title: title,
          message: message,
          accentColor: accentColor,
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
          showCloseButton: showCloseButton,
          duration: duration,
          onConfirm: onConfirm,
          onCancel: onCancel,
        );
      },
    );
  }
}

class _AppDialogContent extends StatefulWidget {
  final String title;
  final String message;
  final Color accentColor;
  final String confirmLabel;
  final String? cancelLabel;
  final bool showCloseButton;
  final Duration? duration;
  final FutureOr<void> Function()? onConfirm;
  final VoidCallback? onCancel;

  const _AppDialogContent({
    required this.title,
    required this.message,
    required this.accentColor,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.showCloseButton,
    required this.duration,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<_AppDialogContent> createState() => _AppDialogContentState();
}

class _AppDialogContentState extends State<_AppDialogContent> {
  Timer? _timer;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();

    if (widget.duration != null) {
      _timer = Timer(widget.duration!, () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (_isProcessing) return;

    _timer?.cancel();

    setState(() => _isProcessing = true);

    Navigator.pop(context, true);

    await widget.onConfirm?.call();
  }

  void _cancel() {
    _timer?.cancel();
    widget.onCancel?.call();
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    final showCancelButton =
        widget.cancelLabel != null || widget.onCancel != null;

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
              horizontal: 28,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(22),
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
                    // CLOSE BUTTON
                    SizedBox(
                      height: 48,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, right: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (widget.showCloseButton)
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: _cancel,
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                  ),
                                  color: AppColors.secondaryText,
                                  tooltip: 'Tutup',
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  splashRadius: 17,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // TITLE
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // MESSAGE
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 14,
                          height: 1.6,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),

                    const SizedBox(height: 26),

                    // ACTION BUTTONS
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          if (showCancelButton)
                            OutlinedButton(
                              onPressed: _cancel,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.secondaryText,
                                side: BorderSide(color: AppColors.border),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 11,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              child: Text(
                                widget.cancelLabel ?? 'Batal',
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ),

                          FilledButton(
                            onPressed: _confirm,
                            style: FilledButton.styleFrom(
                              backgroundColor: widget.accentColor,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              widget.confirmLabel,
                              style: AppTextStyles.button.copyWith(
                                fontSize: 14,
                              ),
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
        ),
      ],
    );
  }
}
