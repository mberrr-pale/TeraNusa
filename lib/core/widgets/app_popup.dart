import 'dart:async';

import 'package:flutter/material.dart';

enum AppPopupType { info, success, warning, error }

class AppPopUp {
  AppPopUp._();

  static Color _getColor(AppPopupType type) {
    switch (type) {
      case AppPopupType.info:
        return const Color(0xFF2878C8);
      case AppPopupType.success:
        return const Color(0xFF198754);
      case AppPopupType.warning:
        return const Color(0xFFE69A21);
      case AppPopupType.error:
        return const Color(0xFFD94343);
    }
  }

  static IconData _getIcon(AppPopupType type) {
    switch (type) {
      case AppPopupType.info:
        return Icons.info_outline_rounded;
      case AppPopupType.success:
        return Icons.check_rounded;
      case AppPopupType.warning:
        return Icons.warning_amber_rounded;
      case AppPopupType.error:
        return Icons.close_rounded;
    }
  }

  static String _getTitle(AppPopupType type) {
    switch (type) {
      case AppPopupType.info:
        return 'Information';
      case AppPopupType.success:
        return 'Success!';
      case AppPopupType.warning:
        return 'Warning!';
      case AppPopupType.error:
        return 'Oops!';
    }
  }

  static Future<void> show({
    required BuildContext context,
    required String message,
    AppPopupType type = AppPopupType.info,
    String? title,
    Duration? duration,
    String confirmText = 'OK',
    String? cancelText,
    bool barrierDismissible = true,
    FutureOr<void> Function()? onConfirm,
    VoidCallback? onCancel,
  }) async {
    final color = _getColor(type);

    await showGeneralDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Popup',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),

      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },

      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return Transform.scale(
          scale: curvedAnimation.value,
          child: Opacity(
            opacity: animation.value,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: _PopupContent(
                  color: color,
                  icon: _getIcon(type),
                  title: title ?? _getTitle(type),
                  message: message,
                  confirmText: confirmText,
                  cancelText: cancelText,
                  duration: duration,

                  onCancel: onCancel,

                  onConfirm: () async {
                    Navigator.of(context, rootNavigator: true).pop();

                    if (onConfirm != null) {
                      await onConfirm();
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PopupContent extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String message;
  final String confirmText;
  final String? cancelText;
  final Duration? duration;
  final Future<void> Function() onConfirm;
  final VoidCallback? onCancel;

  const _PopupContent({
    required this.color,
    required this.icon,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.duration,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<_PopupContent> createState() => _PopupContentState();
}

class _PopupContentState extends State<_PopupContent> {
  Timer? _timer;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();

    if (widget.duration != null) {
      _timer = Timer(widget.duration!, () {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      });
    }
  }

  Future<void> _handleConfirm() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    _timer?.cancel();

    await widget.onConfirm();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      constraints: const BoxConstraints(maxWidth: 380),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.icon, size: 48, color: widget.color),
          ),

          const SizedBox(height: 20),

          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF243C2A),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            widget.message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              if (widget.cancelText != null) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isProcessing
                        ? null
                        : () {
                            _timer?.cancel();

                            Navigator.of(context, rootNavigator: true).pop();

                            widget.onCancel?.call();
                          },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: widget.color,
                      side: BorderSide(color: widget.color),
                      minimumSize: const Size.fromHeight(46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(widget.cancelText!),
                  ),
                ),

                const SizedBox(width: 10),
              ],

              Expanded(
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _handleConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size.fromHeight(46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.confirmText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
