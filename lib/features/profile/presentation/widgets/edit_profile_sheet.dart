import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../../data/models/region_model.dart';
import '../../../region/presentation/providers/region_provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../providers/profile_provider.dart';
import '../../data/models/profile_request.dart';
import '../../../../data/models/user_profile_model.dart';

class EditProfileSheet extends ConsumerStatefulWidget {
  const EditProfileSheet({super.key});

  @override
  ConsumerState<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _regionId;

  bool _isLoading = false;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ================= INITIALIZE PROFILE =================

  void _initializeProfile(UserProfile? profile) {
    if (profile == null || _initialized) return;

    _nameController.text = profile.name;
    _usernameController.text = profile.username;
    _phoneController.text = profile.phone;
    _regionId = profile.regionId;

    _initialized = true;
  }

  // ================= SAVE PROFILE =================

  Future<void> _saveProfile() async {
    if (_isLoading) return;

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(updateProfileProvider)(
        UpdateProfileRequest(
          name: _nameController.text.trim(),
          username: _usernameController.text.trim(),
          phone: _phoneController.text.trim(),
          regionId: _regionId ?? '',
        ),
      );

      if (!mounted) return;

      // Refresh profile
      ref.invalidate(profileProvider);

      // Success popup
      await AppDialog.show(
        context,
        type: AppDialogType.success,
        title: 'Berhasil!',
        message: 'Profil berhasil diperbarui.',
        confirmLabel: 'OK',
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e, stackTrace) {
      debugPrint('UPDATE PROFILE ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');

      if (!mounted) return;

      // Error popup
      await AppDialog.show(
        context,
        type: AppDialogType.error,
        title: 'Gagal!',
        message: 'Gagal memperbarui profil: $e',
        confirmLabel: 'Coba Lagi',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    // Initialize controller when profile is available.
    ref.listen(profileProvider, (previous, next) {
      next.whenData(_initializeProfile);
    });

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          padding: const EdgeInsets.fromLTRB(18, 9, 18, 22),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHandle(),

              const SizedBox(height: 18),

              _buildHeader(),

              const SizedBox(height: 22),

              Flexible(
                child: profileAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) =>
                      Center(child: Text('Gagal memuat profil: $error')),
                  data: (profile) {
                    if (profile == null) {
                      return const Center(
                        child: Text('Data profil tidak ditemukan.'),
                      );
                    }
                    final regionAsync = ref.watch(
                      getRegionByIdProvider(profile.regionId),
                    );

                    // Initialize directly from current AsyncValue.
                    _initializeProfile(profile);

                    return SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(
                              label: 'Nama lengkap',
                              hint: 'Masukkan nama lengkap',
                              controller: _nameController,
                              icon: Icons.person_outline,
                            ),

                            _buildTextField(
                              label: 'Username',
                              hint: 'Masukkan username',
                              controller: _usernameController,
                              icon: Icons.alternate_email,
                            ),

                            _buildTextField(
                              label: 'Nomor telepon',
                              hint: 'Masukkan nomor telepon',
                              controller: _phoneController,
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                            ),

                            regionAsync.when(
                              loading: () => const Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: LinearProgressIndicator(),
                              ),

                              error: (error, stack) => const Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: Text(
                                  'Gagal memuat data wilayah.',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),

                              data: (region) => _buildRegionDropdown(region),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Email akun',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.secondaryText,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.email_outlined,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      profile.email,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            _buildSaveButton(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HANDLE =================

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 38,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFFD9E3DC),
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Edit Profil',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.heading,
          ),
        ),
        IconButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          style: IconButton.styleFrom(backgroundColor: AppColors.primaryLight),
        ),
      ],
    );
  }

  // ================= TEXT FIELD =================

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
            ),
          ),

          const SizedBox(height: 7),

          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: AppColors.primary, size: 19),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label tidak boleh kosong.';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  // ================= DROPDOWN REGION =================
  Widget _buildRegionDropdown(RegionModel? region) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wilayah',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
            ),
          ),

          const SizedBox(height: 7),

          DropdownSearch<RegionModel>(
            selectedItem: region,

            enabled: false,

            items: (filter, loadProps) async {
              return region == null ? [] : [region];
            },

            itemAsString: (region) {
              return '${region.village}, '
                  '${region.district}, '
                  '${region.city}, '
                  '${region.province}';
            },

            compareFn: (a, b) {
              return a.regionId == b.regionId;
            },

            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                hintText: 'Wilayah tidak tersedia',
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                  size: 19,
                ),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SAVE BUTTON =================

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade400,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Simpan Profil',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
