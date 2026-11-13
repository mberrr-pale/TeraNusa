import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:go_router/go_router.dart';
import 'package:teranusa/core/constants/app_routes.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_password_field.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_popup.dart';
import '../../../region/presentation/providers/region_provider.dart';
import '../../../../data/models/region_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../../data/models/register_request.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RegionModel? selectedRegion;
  String? selectedRegionId;
  bool isAgreed = false;

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedRegionId == null) {
      AppPopUp.show(
        context: context,
        title: 'Wilayah belum dipilih',
        message: 'Silakan pilih wilayah utama terlebih dahulu.',
        type: AppPopupType.warning,
      );
      return;
    }

    if (!isAgreed) {
      AppPopUp.show(
        context: context,
        title: 'Perhatian',
        message: 'Silakan setujui ketentuan terlebih dahulu.',
        type: AppPopupType.warning,
      );
      return;
    }

    final request = RegisterRequest(
      name: nameController.text.trim(),
      username: usernameController.text.trim().toLowerCase(),
      email: emailController.text.trim().toLowerCase(),
      phone: phoneController.text.trim(),
      password: passwordController.text,
      regionId: selectedRegionId!,
    );

    await ref.read(authProvider.notifier).register(request);

    if (!mounted) return;

    final result = ref.read(authProvider);

    if (result.hasError) {
      AppPopUp.show(
        context: context,
        title: 'Registrasi Gagal',
        message: result.error.toString(),
        type: AppPopupType.error,
        duration: const Duration(seconds: 5),
      );
      return;
    }

    await AppPopUp.show(
      context: context,
      title: 'Registrasi Berhasil',
      message: 'Selamat datang di TeraNusa! Akun kamu berhasil dibuat.',
      type: AppPopupType.success,
    );

    if (!context.mounted) return;

    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Daftar akun Pencari',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.go('/login');
            }
          },
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 15,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'AKUN PENCARI',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Heading
                  const Text(
                    'Temukan dan simpan\npeluang untukmu.',
                    style: TextStyle(
                      fontSize: 25,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Lengkapi identitas dasar berikut agar aktivitas '
                    'dan peluang tersimpan dapat tersinkron di akunmu.',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Divider(color: AppColors.border),

                  const SizedBox(height: 18),

                  // Form card
                  AppCard(
                    padding: const EdgeInsets.all(14),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SECTION 1
                          const AppSectionHeader(
                            number: 1,
                            title: 'Identitas akun',
                            subtitle: 'Informasi ini akan tampil di halaman profilmu.',
                          ),

                          const SizedBox(height: 18),

                          AppTextField(
                            label: 'Nama lengkap *',
                            hint: 'Masukkan nama lengkap',
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nama lengkap wajib diisi';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          AppTextField(
                            label: 'Username *',
                            hint: 'Contoh: ayurahma',
                            controller: usernameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Username wajib diisi';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          AppTextField(
                            label: 'Email aktif *',
                            hint: 'nama@email.com',
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null ||
                                  !RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                                      .hasMatch(value.trim())) {
                                return 'Email tidak valid';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          AppTextField(
                            label: 'Nomor HP aktif *',
                            hint: '08...',
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nomor HP wajib diisi';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          AppFieldLabel(label: 'Wilayah utama *'),

                          DropdownSearch<RegionModel>(
                            selectedItem: selectedRegion,

                            items: (filter, loadProps) async {
                              final repository = ref.read(
                                regionRepositoryProvider,
                              );

                              final limit = loadProps?.take ?? 20;
                              final skip = loadProps?.skip ?? 0;

                              return repository.getRegions(
                                search: filter,
                                page: skip ~/ limit,
                                limit: limit,
                              );
                            },

                            itemAsString: (region) {
                              return '${region.village}, ${region.district}, '
                                  '${region.city}, ${region.province}';
                            },

                            compareFn: (a, b) {
                              return a.regionId == b.regionId;
                            },

                            onChanged: (value) {
                              setState(() {
                                selectedRegion = value;
                                selectedRegionId = value?.regionId;
                              });
                            },

                            validator: (value) {
                              if (value == null) {
                                return 'Wilayah wajib dipilih';
                              }
                              return null;
                            },

                            decoratorProps: DropDownDecoratorProps(
                              decoration: const InputDecoration(
                                hintText: 'Pilih wilayah',
                                prefixIcon: Icon(Icons.location_on_outlined),
                                border: OutlineInputBorder(),
                              ),
                            ),

                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              disableFilter: true,

                              infiniteScrollProps: InfiniteScrollProps(
                                loadProps: LoadProps(skip: 0, take: 20),
                              ),

                              searchFieldProps: TextFieldProps(
                                decoration: const InputDecoration(
                                  hintText: 'Cari wilayah...',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              constraints: const BoxConstraints(maxHeight: 400),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Divider(color: AppColors.border),

                          const SizedBox(height: 18),

                          // SECTION 2
                          // SECTION 2
                          const AppSectionHeader(
                            number: 2,
                            title: 'Keamanan akun',
                            subtitle:
                                'Buat kata sandi untuk melindungi akunmu.',
                          ),

                          const SizedBox(height: 18),

                          // Password
                          AppPasswordField(
                            label: 'Kata sandi *',
                            hint: 'Minimal 8 karakter',
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.length < 8) {
                                return 'Minimal 8 karakter';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          // Confirm Password
                          AppPasswordField(
                            label: 'Konfirmasi kata sandi *',
                            hint: 'Ulangi kata sandi',
                            controller: confirmPasswordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Konfirmasi kata sandi wajib diisi';
                              }

                              if (value != passwordController.text) {
                                return 'Kata sandi tidak sama';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // Agreement
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: isAgreed,
                                  activeColor: AppColors.primary,
                                  onChanged: (value) {
                                    setState(() {
                                      isAgreed = value ?? false;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(width: 8),

                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Saya menyetujui ketentuan penggunaan '
                                    'dan kebijakan privasi TeraNusa.',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Submit button
                          AppButton(
                            label: 'Daftar sebagai Pencari',
                            icon: Icons.chevron_right,
                            isLoading: isLoading,
                            onPressed: register,
                          ),

                          const SizedBox(height: 14),

                          // Login navigation
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                const Text(
                                  'Sudah punya akun? ',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    context.go(AppRoutes.login);
                                  },
                                  child: const Text(
                                    'Masuk',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
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

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
