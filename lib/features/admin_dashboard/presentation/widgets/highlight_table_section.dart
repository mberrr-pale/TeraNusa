import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HighlightableSection extends StatelessWidget {
  final bool isActive;
  final Animation<double> intensity;
  final Widget child;

  const HighlightableSection({
    super.key,
    required this.isActive,
    required this.intensity,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: intensity,
      builder: (context, child) {
        final t = isActive ? intensity.value : 0.0;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.32 * t),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.16 * t),
              width: 1,
            ),
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}
