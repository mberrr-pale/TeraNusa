import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Indikator halaman 3-dot animasi untuk Onboarding Guest.
class OnboardingPageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final ValueChanged<int>? onDotTap;

  const OnboardingPageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return GestureDetector(
          key: Key('onboarding_dot_$index'),
          behavior: HitTestBehavior.opaque,
          onTap: onDotTap == null ? null : () => onDotTap!(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: isActive ? 22 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : const Color(0xFFA5D6A7),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        );
      }),
    );
  }
}
