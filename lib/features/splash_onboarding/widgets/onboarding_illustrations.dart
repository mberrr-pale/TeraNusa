import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'teranusa_logo_mark.dart';

/// Ilustrasi Slide 1 Onboarding Guest: emblem tunas TeraNusa dengan gerakan
/// micro-float yang sangat lembut dan bersih.
class WelcomeHeroIllustration extends StatelessWidget {
  final double floatPhase;

  const WelcomeHeroIllustration({super.key, this.floatPhase = 0});

  @override
  Widget build(BuildContext context) {
    final angle = floatPhase * 2 * math.pi;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: 276,
        height: 224,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Halo lingkaran sage lembut
            Container(
              width: 184,
              height: 184,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.85),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ),

            // Emblem utama TeraNusa dengan micro-float halus
            Transform.translate(
              offset: Offset(0, math.sin(angle) * 2.5),
              child: const TeraNusaLogoMark(size: 88),
            ),

            // Lencana kanan atas: Lokasi Nusantara
            Positioned(
              top: 16,
              right: 28,
              child: Transform.translate(
                offset: Offset(0, math.sin(angle + 1.2) * 2.0),
                child: const _FloatingIconBadge(
                  icon: Icons.location_on_outlined,
                  iconColor: AppColors.primary,
                  backgroundColor: AppColors.primaryLight,
                ),
              ),
            ),

            // Lencana kiri bawah-tengah: Peluang unggulan
            Positioned(
              bottom: 46,
              left: 24,
              child: Transform.translate(
                offset: Offset(0, math.sin(angle + 2.4) * 2.0),
                child: const _FloatingIconBadge(
                  icon: Icons.auto_awesome_outlined,
                  iconColor: AppColors.event,
                  backgroundColor: AppColors.eventBackground,
                ),
              ),
            ),

            // Lencana kanan bawah: Komunitas warga
            Positioned(
              bottom: 16,
              right: 34,
              child: Transform.translate(
                offset: Offset(0, math.sin(angle + 3.6) * 1.8),
                child: const _FloatingIconBadge(
                  icon: Icons.groups_outlined,
                  iconColor: AppColors.job,
                  backgroundColor: AppColors.jobBackground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ilustrasi Slide 2 Onboarding Guest (selaras dengan Splash Screen guest 2.png):
/// lingkaran sage lembut, kartu miring "Peluang terdekat", dan 3 lencana ikon.
class OpportunityShowcaseIllustration extends StatelessWidget {
  final double floatPhase;

  const OpportunityShowcaseIllustration({super.key, this.floatPhase = 0});

  @override
  Widget build(BuildContext context) {
    return _ShowcaseCluster(
      floatPhase: floatPhase,
      cardIcon: Icons.location_on_outlined,
      cardTitle: 'Peluang terdekat',
      cardSubtitle: 'Sleman · 5 hari lagi',
      topRightIcon: Icons.work_outline_rounded,
      topRightColor: AppColors.job,
      topRightBackground: AppColors.jobBackground,
      leftIcon: Icons.volunteer_activism_outlined,
      leftColor: AppColors.empowerment,
      leftBackground: AppColors.empowermentBackground,
      bottomRightIcon: Icons.calendar_today_outlined,
      bottomRightColor: AppColors.event,
      bottomRightBackground: AppColors.eventBackground,
    );
  }
}

/// Ilustrasi Slide 3 Onboarding Guest dengan bahasa visual serasi Slide 2:
/// menonjolkan kepercayaan informasi lokal, simpan peluang, berita, & komunitas.
class TrustedLocalIllustration extends StatelessWidget {
  final double floatPhase;

  const TrustedLocalIllustration({super.key, this.floatPhase = 0});

  @override
  Widget build(BuildContext context) {
    return _ShowcaseCluster(
      floatPhase: floatPhase,
      cardIcon: Icons.verified_user_outlined,
      cardTitle: 'Sumber lokal tepercaya',
      cardSubtitle: 'Terverifikasi di wilayahmu',
      topRightIcon: Icons.bookmark_border_rounded,
      topRightColor: AppColors.primary,
      topRightBackground: AppColors.primaryLight,
      leftIcon: Icons.newspaper_outlined,
      leftColor: AppColors.job,
      leftBackground: AppColors.jobBackground,
      bottomRightIcon: Icons.groups_outlined,
      bottomRightColor: AppColors.product,
      bottomRightBackground: AppColors.productBackground,
    );
  }
}

class _ShowcaseCluster extends StatelessWidget {
  final double floatPhase;
  final IconData cardIcon;
  final String cardTitle;
  final String cardSubtitle;
  final IconData topRightIcon;
  final Color topRightColor;
  final Color topRightBackground;
  final IconData leftIcon;
  final Color leftColor;
  final Color leftBackground;
  final IconData bottomRightIcon;
  final Color bottomRightColor;
  final Color bottomRightBackground;

  const _ShowcaseCluster({
    required this.floatPhase,
    required this.cardIcon,
    required this.cardTitle,
    required this.cardSubtitle,
    required this.topRightIcon,
    required this.topRightColor,
    required this.topRightBackground,
    required this.leftIcon,
    required this.leftColor,
    required this.leftBackground,
    required this.bottomRightIcon,
    required this.bottomRightColor,
    required this.bottomRightBackground,
  });

  @override
  Widget build(BuildContext context) {
    final angle = floatPhase * 2 * math.pi;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: 276,
        height: 224,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Lingkaran latar sage lembut
            Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.85),
                shape: BoxShape.circle,
              ),
            ),

            // Kartu putih miring tipis di tengah dengan micro-float halus
            Transform.translate(
              offset: Offset(0, math.sin(angle) * 2.2),
              child: Transform.rotate(
                angle: -0.025,
                child: Container(
                  width: 210,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.75),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cardShadow.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(cardIcon, size: 24, color: AppColors.primary),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cardTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.heading,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cardSubtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.secondaryText,
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

            // Lencana melayang kanan atas
            Positioned(
              top: 12,
              right: 22,
              child: Transform.translate(
                offset: Offset(0, math.sin(angle + 1.4) * 2.0),
                child: _FloatingIconBadge(
                  icon: topRightIcon,
                  iconColor: topRightColor,
                  backgroundColor: topRightBackground,
                ),
              ),
            ),

            // Lencana melayang kiri bawah-tengah
            Positioned(
              bottom: 34,
              left: 16,
              child: Transform.translate(
                offset: Offset(0, math.sin(angle + 2.6) * 1.8),
                child: _FloatingIconBadge(
                  icon: leftIcon,
                  iconColor: leftColor,
                  backgroundColor: leftBackground,
                ),
              ),
            ),

            // Lencana melayang kanan bawah
            Positioned(
              bottom: 10,
              right: 34,
              child: Transform.translate(
                offset: Offset(0, math.sin(angle + 4.0) * 2.0),
                child: _FloatingIconBadge(
                  icon: bottomRightIcon,
                  iconColor: bottomRightColor,
                  backgroundColor: bottomRightBackground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingIconBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const _FloatingIconBadge({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.055),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }
}
