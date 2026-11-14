import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_routes.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_password_field.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_popup.dart';

import '../providers/auth_provider.dart';
import '../../../../data/models/user_profile_model.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void redirectByRole(UserProfile profile) {
    if (profile.isAdmin) {
      context.go(AppRoutes.adminHome);
    } else if (profile.isContributor) {
      context.go(AppRoutes.contributorHome);
    } else {
      context.go(AppRoutes.home);
    }
  }

  // LOGIN
  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final profile = await ref
          .read(authProvider.notifier)
          .login(
            email: emailController.text.trim().toLowerCase(),
            password: passwordController.text,
          );

      if (!mounted) return;

      AppPopUp.show(
        context: context,
        type: AppPopupType.success,
        title: 'Login berhasil',
        message: 'Selamat datang kembali, ${profile.name}.',
      );

      redirectByRole(profile);
    } on AuthException catch (e) {
      if (!mounted) return;

      AppPopUp.show(
        context: context,
        type: AppPopupType.error,
        title: 'Login gagal',
        message: e.message,
      );
    } catch (e) {
      if (!mounted) return;

      AppPopUp.show(
        context: context,
        type: AppPopupType.error,
        title: 'Terjadi kesalahan',
        message: 'Tidak dapat memuat profil akun. Silakan coba kembali.',
        duration: const Duration(seconds: 5),
      );

      debugPrint('LOGIN ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),

              child: AppCard(
                padding: const EdgeInsets.all(24),

                child: Form(
                  key: _formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CLOSE BUTTON
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go(AppRoutes.register);
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: AppColors.textPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      // LOGO
                      Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.20),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.spa_outlined,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // BADGE
                      Center(
                        child: AppBadge(
                          label: 'AKUN TERANUSA',
                          type: AppBadgeType.warning,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // HEADING
                      const Center(
                        child: Text(
                          'Selamat datang kembali',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Center(
                        child: Text(
                          'Masuk untuk melanjutkan aktivitasmu.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // EMAIL
                      AppTextField(
                        label: 'Email',
                        hint: 'nama@email.com',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email wajib diisi';
                          }

                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                              .hasMatch(value.trim())) {
                            return 'Format email tidak valid';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // PASSWORD
                      AppPasswordField(
                        label: 'Kata sandi',
                        hint: 'Masukkan kata sandi',
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kata sandi wajib diisi';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // FORGOT PASSWORD
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Navigasi ke halaman lupa password
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Lupa kata sandi?',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // LOGIN BUTTON
                      AppButton(
                        label: 'Masuk',
                        icon: Icons.arrow_forward,
                        isLoading: isLoading,
                        onPressed: login,
                      ),

                      const SizedBox(height: 24),

                      // REGISTER LINK
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            const Text(
                              'Belum punya akun? ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                context.go(AppRoutes.register);
                              },
                              child: const Text(
                                'Daftar sekarang',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }
}
