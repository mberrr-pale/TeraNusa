import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum SplashBackgroundVariant { splash, onboarding }

/// Latar belakang gradasi sage-ke-putih lembut dengan aksen cincin tipis dan
/// titik pastel yang selaras dengan Splash Screen login.png & guest.
class OnboardingBackground extends StatelessWidget {
  final SplashBackgroundVariant variant;
  final Widget child;

  const OnboardingBackground({
    super.key,
    required this.variant,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEAF5EB), Color(0xFFF6FBF6), AppColors.white],
          stops: [0.0, 0.48, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Cincin lengkung kanan atas
          Positioned(
            top: -90,
            right: -95,
            child: IgnorePointer(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),

          if (variant == SplashBackgroundVariant.splash) ...[
            // Cincin lembut di sekitar logo tengah
            Center(
              child: Transform.translate(
                offset: const Offset(0, -34),
                child: IgnorePointer(
                  child: Container(
                    width: 224,
                    height: 224,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Titik hijau pastel kanan atas
            Positioned(
              top: 210,
              right: 68,
              child: IgnorePointer(
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9BCE9E),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            // Titik amber lembut kiri bawah logo
            Positioned(
              bottom: 300,
              left: 62,
              child: IgnorePointer(
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE9B164),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ] else ...[
            // Titik hijau pastel dekoratif kanan atas untuk onboarding
            Positioned(
              top: 132,
              right: 54,
              child: IgnorePointer(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9BCE9E),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],

          child,
        ],
      ),
    );
  }
}
