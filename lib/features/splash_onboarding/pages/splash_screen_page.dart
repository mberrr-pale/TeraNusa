import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/user_profile_model.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../widgets/onboarding_background.dart';
import '../widgets/teranusa_logo_mark.dart';

/// Layar pembuka aplikasi (selaras dengan Splash Screen login.png).
/// - Jika user sudah login -> diarahkan otomatis ke Beranda ([AppRoutes.home]).
/// - Jika user mode guest -> diarahkan otomatis ke Onboarding Guest ([AppRoutes.onboarding]).
class SplashScreenPage extends ConsumerStatefulWidget {
  final Duration splashDelay;
  final Duration maxWaitDuration;
  final VoidCallback? onNavigateHome;
  final VoidCallback? onNavigateOnboarding;

  const SplashScreenPage({
    super.key,
    this.splashDelay = const Duration(milliseconds: 1600),
    this.maxWaitDuration = const Duration(seconds: 6),
    this.onNavigateHome,
    this.onNavigateOnboarding,
  });

  @override
  ConsumerState<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends ConsumerState<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  Timer? _minDelayTimer;
  Timer? _fallbackTimer;
  bool _minDelayElapsed = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();

    _minDelayTimer = Timer(widget.splashDelay, () {
      _minDelayElapsed = true;
      _tryNavigate(ref.read(authProvider));
    });

    // Pengaman agar layar splash tidak macet bila pemeriksaan sesi lambat.
    _fallbackTimer = Timer(widget.maxWaitDuration, () {
      if (!mounted || _hasNavigated) return;
      _navigateWithState(ref.read(authProvider), force: true);
    });
  }

  @override
  void dispose() {
    _minDelayTimer?.cancel();
    _fallbackTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _tryNavigate(AsyncValue<UserProfile?> authState) {
    if (!_minDelayElapsed || _hasNavigated || !mounted) return;
    if (authState.isLoading) return;
    _navigateWithState(authState);
  }

  void _navigateWithState(
    AsyncValue<UserProfile?> authState, {
    bool force = false,
  }) {
    if (_hasNavigated || !mounted) return;
    if (!force && authState.isLoading) return;

    _hasNavigated = true;
    _minDelayTimer?.cancel();
    _fallbackTimer?.cancel();

    final user = authState.asData?.value;
    if (user != null) {
      if (widget.onNavigateHome != null) {
        widget.onNavigateHome!();
      } else {
        context.go(AppRoutes.home);
      }
      return;
    }

    if (widget.onNavigateOnboarding != null) {
      widget.onNavigateOnboarding!();
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<UserProfile?>>(authProvider, (_, next) {
      _tryNavigate(next);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: OnboardingBackground(
        variant: SplashBackgroundVariant.splash,
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TeraNusaLogoMark(size: 94),
                      SizedBox(height: 36),
                      Text(
                        'TeraNusa',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: AppColors.primary,
                        ),
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
