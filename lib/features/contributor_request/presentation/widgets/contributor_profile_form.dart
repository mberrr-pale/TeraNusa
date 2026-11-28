import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../data/models/user_profile_model.dart';
import '../../../../../data/models/region_model.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../region/presentation/providers/region_provider.dart';
import '../providers/contributor_req_action_provider.dart';

class ContributorProfileForm extends ConsumerStatefulWidget {
  final AsyncValue action;
  final String buttonText;

  const ContributorProfileForm({
    super.key,
    required this.action,
    required this.buttonText,
  });

  @override
  ConsumerState<ContributorProfileForm> createState() =>
      _ContributorProfileFormState();
}

class _ContributorProfileFormState
    extends ConsumerState<ContributorProfileForm> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _regionId;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _initialized = false;

  void _initializeProfile(UserProfile? profile) {
    if (profile == null || _initialized) return;

    _nameController.text = profile.name;
    _usernameController.text = profile.username;
    _phoneController.text = profile.phone;
    _regionId = profile.regionId;

    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),

      error: (error, stack) =>
          Center(child: Text('Gagal memuat profil: $error')),

      data: (profile) {
        if (profile == null) {
          return const Center(child: Text('Data profil tidak ditemukan.'));
        }

        _initializeProfile(profile);

        final regionAsync = ref.watch(getRegionByIdProvider(_regionId ?? ''));

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: 'Nama lengkap',
                controller: _nameController,
                icon: Icons.person_outline,
              ),

              _buildTextField(
                label: 'Username',
                controller: _usernameController,
                icon: Icons.alternate_email,
              ),

              _buildTextField(
                label: 'Nomor telepon',
                controller: _phoneController,
                icon: Icons.phone_outlined,
              ),

              regionAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => const Text(
                  'Gagal memuat data wilayah.',
                  style: TextStyle(color: Colors.red),
                ),
                data: (region) {
                  return _buildRegion(region);
                },
              ),

              const SizedBox(height: 8),

              _buildTextField(
                label: 'Email akun',
                value: profile.email,
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 24),

              if (widget.action.hasError)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    widget.action.error.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.action.isLoading
                      ? null
                      : () async {
                          await ref
                              .read(contributorRequestActionProvider.notifier)
                              .submit(null);
                        },
                  child: widget.action.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.buttonText),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    String? value,
    TextEditingController? controller,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          TextFormField(
            controller: controller,
            initialValue: controller == null ? value : null,
            enabled: false,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primary),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegion(RegionModel? region) {
    final regionName = region == null
        ? '-'
        : '${region.village}, '
              '${region.district}, '
              '${region.city}, '
              '${region.province}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Wilayah',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          TextFormField(
            initialValue: regionName,
            enabled: false,
            maxLines: null,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.location_on_outlined,
                color: AppColors.primary,
              ),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
