import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teranusa/core/theme/app_theme.dart';
import 'package:teranusa/data/models/user_profile_model.dart';
import 'package:teranusa/features/auth/presentation/providers/auth_provider.dart';
import 'package:teranusa/features/splash_onboarding/pages/guest_onboarding_page.dart';
import 'package:teranusa/features/splash_onboarding/pages/splash_screen_page.dart';
import 'package:teranusa/features/splash_onboarding/widgets/onboarding_wave_backdrop.dart';
import 'package:teranusa/features/splash_onboarding/widgets/teranusa_logo_mark.dart';

class _FakeAuthNotifier extends AuthNotifier {
  final FutureOr<UserProfile?> Function() _loader;

  _FakeAuthNotifier(this._loader);

  @override
  Future<UserProfile?> build() async => await _loader();
}

UserProfile _sampleUser() => const UserProfile(
  userId: 'u-1',
  name: 'Ayu Rahmawati',
  username: 'ayurahma',
  email: 'ayu@teranusa.id',
  phone: '08123456789',
  regionId: 'r-1',
  isContributor: false,
  isAdmin: false,
);

void _setViewport(WidgetTester tester, {Size size = const Size(412, 915)}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

void main() {
  group('SplashScreenPage (alur login vs guest)', () {
    testWidgets(
      'user sudah login menampilkan desain Splash Screen login.png lalu menuju Beranda',
      (tester) async {
        _setViewport(tester);
        var navigatedHome = false;
        var navigatedOnboarding = false;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(() => _FakeAuthNotifier(_sampleUser)),
            ],
            child: MaterialApp(
              theme: AppTheme.light,
              home: SplashScreenPage(
                splashDelay: const Duration(milliseconds: 100),
                maxWaitDuration: const Duration(seconds: 2),
                onNavigateHome: () => navigatedHome = true,
                onNavigateOnboarding: () => navigatedOnboarding = true,
              ),
            ),
          ),
        );

        expect(find.byType(TeraNusaLogoMark), findsOneWidget);
        expect(find.text('TeraNusa'), findsOneWidget);
        expect(navigatedHome, isFalse);

        await tester.pump(const Duration(milliseconds: 150));
        await tester.pumpAndSettle();

        expect(navigatedHome, isTrue);
        expect(navigatedOnboarding, isFalse);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'mode guest menampilkan Splash Screen lalu mengarahkan ke Onboarding Guest',
      (tester) async {
        _setViewport(tester);
        var navigatedHome = false;
        var navigatedOnboarding = false;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(() => _FakeAuthNotifier(() => null)),
            ],
            child: MaterialApp(
              theme: AppTheme.light,
              home: SplashScreenPage(
                splashDelay: const Duration(milliseconds: 100),
                maxWaitDuration: const Duration(seconds: 2),
                onNavigateHome: () => navigatedHome = true,
                onNavigateOnboarding: () => navigatedOnboarding = true,
              ),
            ),
          ),
        );

        await tester.pump(const Duration(milliseconds: 150));
        await tester.pumpAndSettle();

        expect(navigatedOnboarding, isTrue);
        expect(navigatedHome, isFalse);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'menunggu authProvider selesai loading sebelum berpindah halaman',
      (tester) async {
        _setViewport(tester);
        final completer = Completer<UserProfile?>();
        var navigatedOnboarding = false;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(
                () => _FakeAuthNotifier(() => completer.future),
              ),
            ],
            child: MaterialApp(
              theme: AppTheme.light,
              home: SplashScreenPage(
                splashDelay: const Duration(milliseconds: 80),
                maxWaitDuration: const Duration(seconds: 5),
                onNavigateOnboarding: () => navigatedOnboarding = true,
              ),
            ),
          ),
        );

        await tester.pump(const Duration(milliseconds: 120));
        expect(navigatedOnboarding, isFalse);

        completer.complete(null);
        await tester.pumpAndSettle();
        expect(navigatedOnboarding, isTrue);
      },
    );
  });

  group('GuestOnboardingPage (design referensi .jpg + animasi + CTA di akhir)', () {
    testWidgets(
      'Slide 1 & 2 hanya tampil Lanjut (tanpa Lewati), tombol Mulai menjelajah hanya muncul di Slide 3',
      (tester) async {
        _setViewport(tester);
        var explored = false;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: GuestOnboardingPage(
              enableContinuousAnimation: false,
              onExplore: () => explored = true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Latar gelombang organik aktif & tidak ada tombol Lewati
        expect(find.byType(OnboardingWaveBackdrop), findsOneWidget);
        expect(find.text('Lewati'), findsNothing);

        // Slide 1: teks TeraNusa + tombol Lanjut (Mulai menjelajah belum muncul)
        expect(find.byType(TeraNusaLogoMark), findsOneWidget);
        expect(find.text('Selamat Datang'), findsOneWidget);
        expect(
          find.textContaining('Potensi lokal, lebih mudah ditemukan.'),
          findsOneWidget,
        );
        expect(find.byKey(const Key('onboarding_next_button')), findsOneWidget);
        expect(find.text('Lanjut'), findsOneWidget);
        expect(find.text('Mulai menjelajah'), findsNothing);
        expect(explored, isFalse);

        // Tap Lanjut -> berpindah ke Slide 2
        await tester.tap(find.byKey(const Key('onboarding_next_button')));
        await tester.pumpAndSettle();

        expect(find.text('Temukan peluang di sekitarmu'), findsOneWidget);
        expect(find.text('Peluang terdekat'), findsOneWidget);
        expect(find.text('Sleman · 5 hari lagi'), findsOneWidget);
        expect(find.text('Lanjut'), findsOneWidget);
        expect(find.text('Mulai menjelajah'), findsNothing);
        expect(explored, isFalse);

        // Tap Lanjut -> berpindah ke Slide 3 (akhir) -> tombol Mulai menjelajah muncul
        await tester.tap(find.byKey(const Key('onboarding_next_button')));
        await tester.pumpAndSettle();

        expect(find.text('Informasi lokal yang tepercaya'), findsOneWidget);
        expect(find.text('Sumber lokal tepercaya'), findsOneWidget);
        expect(
          find.byKey(const Key('onboarding_explore_button')),
          findsOneWidget,
        );
        expect(find.text('Mulai menjelajah'), findsOneWidget);
        expect(find.text('Lanjut'), findsNothing);

        // Tap dot 0 -> kembali ke Slide 1, tombol kembali ke Lanjut
        await tester.tap(find.byKey(const Key('onboarding_dot_0')));
        await tester.pumpAndSettle();
        expect(find.text('Selamat Datang'), findsOneWidget);
        expect(find.text('Lanjut'), findsOneWidget);

        // Swipe ke Slide 2 & Slide 3 lalu tap Mulai menjelajah -> masuk Beranda
        await tester.drag(
          find.byKey(const Key('guest_onboarding_pageview')),
          const Offset(-400, 0),
        );
        await tester.pumpAndSettle();
        await tester.drag(
          find.byKey(const Key('guest_onboarding_pageview')),
          const Offset(-400, 0),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('onboarding_explore_button')));
        await tester.pumpAndSettle();
        expect(explored, isTrue);
      },
    );

    testWidgets(
      'animasi mengambang kontinyu & layar sempit 360x640 berjalan mulus tanpa overflow',
      (tester) async {
        _setViewport(tester, size: const Size(360, 640));

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: GuestOnboardingPage(
              enableContinuousAnimation: true,
              onExplore: () {},
            ),
          ),
        );

        // Jalankan beberapa frame animasi mengambang di Slide 1, 2, dan 3
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 600));
        expect(tester.takeException(), isNull);

        await tester.tap(find.byKey(const Key('onboarding_dot_1')));
        await tester.pump(const Duration(milliseconds: 450));
        expect(tester.takeException(), isNull);

        await tester.tap(find.byKey(const Key('onboarding_dot_2')));
        await tester.pump(const Duration(milliseconds: 450));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'resize dinamis desktop -> mobile -> desktop (simulasi Chrome Inspect) tanpa crash/overflow',
      (tester) async {
        _setViewport(tester, size: const Size(1280, 800));

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: GuestOnboardingPage(
              enableContinuousAnimation: false,
              onExplore: () {},
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Pindah ke Slide 2 lalu ubah ukuran viewport seperti Chrome Device Toolbar
        await tester.tap(find.byKey(const Key('onboarding_next_button')));
        await tester.pumpAndSettle();

        tester.view.physicalSize = const Size(390, 844);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        tester.view.physicalSize = const Size(360, 640);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        tester.view.physicalSize = const Size(1280, 800);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  });
}
