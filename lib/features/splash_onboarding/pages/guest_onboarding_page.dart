import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/onboarding_illustrations.dart';
import '../widgets/onboarding_page_indicator.dart';
import '../widgets/onboarding_wave_backdrop.dart';

/// Halaman Onboarding 3 slide untuk mode Guest dengan komposisi split-canvas
/// gelombang organik bergaya design referensi .jpg dalam palet hijau & teks
/// TeraNusa. Tombol aksi memulai menjelajah hanya tampil pada slide terakhir.
class GuestOnboardingPage extends StatefulWidget {
  final VoidCallback? onExplore;
  final bool enableContinuousAnimation;

  const GuestOnboardingPage({
    super.key,
    this.onExplore,
    this.enableContinuousAnimation = true,
  });

  @override
  State<GuestOnboardingPage> createState() => _GuestOnboardingPageState();
}

class _GuestOnboardingPageState extends State<GuestOnboardingPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late final AnimationController _floatController;

  int _currentPage = 0;

  static const _slides = <_OnboardingSlideContent>[
    _OnboardingSlideContent(
      title: 'Selamat Datang',
      subtitle:
          'Potensi lokal, lebih mudah ditemukan. Peluang dari warga, untuk warga di seluruh penjuru Nusantara.',
    ),
    _OnboardingSlideContent(
      title: 'Temukan peluang di sekitarmu',
      subtitle:
          'Filter lowongan, event, bantuan, serta produk dan jasa berdasarkan wilayah pilihanmu.',
    ),
    _OnboardingSlideContent(
      title: 'Informasi lokal yang tepercaya',
      subtitle:
          'Simpan peluang favorit, ikuti kabar daerah, dan berkontribusi kapan pun kamu siap.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4800),
    );
    if (widget.enableContinuousAnimation) {
      _floatController.repeat();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  double get _currentPageOffset {
    if (!_pageController.hasClients ||
        !_pageController.position.hasContentDimensions) {
      return _currentPage.toDouble();
    }
    return _pageController.page ?? _currentPage.toDouble();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  void _handleNextOrExplore() {
    final isLastPage = _currentPage == _slides.length - 1;
    if (!isLastPage) {
      _goToPage(_currentPage + 1);
      return;
    }

    if (widget.onExplore != null) {
      widget.onExplore!();
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Latar split-canvas dengan bukit dedaunan parallax & gelombang putih morph
          // Menggunakan AnimatedBuilder langsung pada PageController agar aman
          // dari setState() selama resize viewport (Chrome Inspect / Mobile Preview).
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pageController,
              builder: (context, _) {
                return OnboardingWaveBackdrop(pageOffset: _currentPageOffset);
              },
            ),
          ),

          // Konten interaktif
          SafeArea(
            child: Column(
              children: [
                // PageView penuh mencakup ilustrasi atas & teks bawah agar nyaman digeser
                Expanded(
                  child: PageView.builder(
                    key: const Key('guest_onboarding_pageview'),
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      final slide = _slides[index];

                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, _) {
                          final distance = (_currentPageOffset - index)
                              .abs()
                              .clamp(0.0, 1.0);
                          final scale = 1.0 - (distance * 0.04);
                          final opacity = 1.0 - (distance * 0.25);

                          return Column(
                            children: [
                              // Panggung ilustrasi atas (~50% layar)
                              Expanded(
                                flex: 52,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      24,
                                      16,
                                      24,
                                      28,
                                    ),
                                    child: Opacity(
                                      opacity: opacity,
                                      child: Transform.scale(
                                        scale: scale,
                                        child: AnimatedBuilder(
                                          animation: _floatController,
                                          builder: (context, _) {
                                            final phase =
                                                _floatController.value;
                                            return switch (index) {
                                              0 => WelcomeHeroIllustration(
                                                floatPhase: phase,
                                              ),
                                              1 =>
                                                OpportunityShowcaseIllustration(
                                                  floatPhase: phase,
                                                ),
                                              _ => TrustedLocalIllustration(
                                                floatPhase: phase,
                                              ),
                                            };
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Area teks di atas kanvas putih bawah
                              Expanded(
                                flex: 32,
                                child: Center(
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.fromLTRB(
                                      28,
                                      12,
                                      28,
                                      4,
                                    ),
                                    child: Opacity(
                                      opacity: opacity,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            slide.title,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 25,
                                              height: 1.22,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: -0.45,
                                              color: AppColors.heading,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            slide.subtitle,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              height: 1.55,
                                              color: AppColors.secondaryText,
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
                        },
                      );
                    },
                  ),
                ),

                // Area bawah: indikator 3 dot + tombol pill CTA (Mulai menjelajah hanya di akhir)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 6, 24, 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OnboardingPageIndicator(
                        count: _slides.length,
                        currentIndex: _currentPage,
                        onDotTap: _goToPage,
                      ),
                      const SizedBox(height: 16),

                      // Pill CTA button selaras design referensi .jpg dalam warna hijau TeraNusa
                      _OnboardingPillCta(
                        isLastPage: isLastPage,
                        onTap: _handleNextOrExplore,
                      ),
                      const SizedBox(height: 12),

                      // Catatan akses tanpa akun hanya ditonjolkan di akhir (tinggi stabil tanpa loncat)
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 240),
                        opacity: isLastPage ? 1.0 : 0.0,
                        child: const Text(
                          'Jelajahi tanpa akun. Masuk hanya saat kamu membutuhkannya.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPillCta extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onTap;

  const _OnboardingPillCta({required this.isLastPage, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          key: Key(
            isLastPage
                ? 'onboarding_explore_button'
                : 'onboarding_next_button',
          ),
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: isLastPage ? 228 : 164,
                minHeight: 50,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 13,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: Row(
                    key: ValueKey<bool>(isLastPage),
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          isLastPage ? 'Mulai menjelajah' : 'Lanjut',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 19,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlideContent {
  final String title;
  final String subtitle;

  const _OnboardingSlideContent({required this.title, required this.subtitle});
}
