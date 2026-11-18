import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/providers/internet_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/app_popup.dart';

import '../../../../data/models/user_profile_model.dart';

import '../../../auth/presentation/providers/auth_provider.dart';

import '../providers/profile_provider.dart';

import '../widgets/edit_profile_sheet.dart';
import '../widgets/change_password_sheet.dart';

import '../widgets/profile_header.dart';
import '../widgets/profile_menu.dart';
import '../widgets/profile_logout_button.dart';
import '../widgets/profile_bottom_navigation.dart';

import '../widgets/avatar_preview_dialog.dart';
import '../widgets/avatar_options_sheet.dart';
import '../widgets/avatar_info_dialog.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _isUploadingAvatar = false;

  final ImagePicker _picker = ImagePicker();

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final internetAsync = ref.watch(internetStatusProvider);
    final isOnline = internetAsync.asData?.value ?? false;

    final userAsync = ref.watch(authProvider);

    return userAsync.when(
      loading: _buildLoading,
      error: _buildError,
      data: (user) {
        if (user == null) {
          return _buildUnauthenticated();
        }

        return _buildProfilePage(user, isOnline);
      },
    );
  }

  // ================= PROFILE PAGE =================

  Widget _buildProfilePage(UserProfile user, bool isOnline) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 15, 14, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(),

              // PROFILE HEADER
              ProfileHeader(
                user: user,
                isOnline: isOnline,
                isUploadingAvatar: _isUploadingAvatar,
                onAvatarTap: () {
                  _showAvatarPreview(user);
                },
              ),

              const SizedBox(height: 20),

              // PROFILE MENU
              ProfileMenu(
                isOnline: isOnline,
                onEditProfile: _showEditProfile,
                onChangePassword: _showChangePassword,
                onSync: _showSyncInfo,
                onHelp: _showHelpInfo,
                onOffline: _showOfflineInfo,
              ),

              const SizedBox(height: 18),

              // LOGOUT BUTTON
              ProfileLogoutButton(isOnline: isOnline, onPressed: _logout),
            ],
          ),
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: ProfileBottomNavigation(
        currentIndex: 3,
        onTap: _onNavigationTap,
      ),
    );
  }

  // ================= LOADING =================

  Widget _buildLoading() {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  // ================= ERROR =================

  Widget _buildError(Object error, StackTrace stackTrace) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 45, color: Colors.red),

            const SizedBox(height: 12),

            const Text('Gagal mengambil data profil'),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                ref.invalidate(authProvider);
              },
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  // ================= UNAUTHENTICATED =================

  Widget _buildUnauthenticated() {
    return const Scaffold(
      body: Center(child: Text('Silakan login terlebih dahulu')),
    );
  }

  // ================= AVATAR PREVIEW =================

  void _showAvatarPreview(UserProfile user) {
    AvatarPreviewDialog.show(
      context: context,
      user: user,
      onEdit: _showAvatarOptions,
    );
  }

  // ================= AVATAR OPTIONS =================

  void _showAvatarOptions() {
    AvatarOptionsSheet.show(context: context, onSelected: _pickAvatar);
  }

  // ================= PICK AVATAR =================

  Future<void> _pickAvatar(ImageSource source) async {
    final isOnline = ref.read(internetStatusProvider).asData?.value ?? false;

    if (!isOnline) {
      _showOfflineInfo();
      return;
    }

    if (_isUploadingAvatar) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile == null || !mounted) return;

      setState(() {
        _isUploadingAvatar = true;
      });

      final imageFile = File(pickedFile.path);

      await ref.read(updateAvatarProvider)(imageFile);

      if (!mounted) return;

      ref.invalidate(authProvider);
      ref.invalidate(profileProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto profil berhasil diperbarui')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui foto profil: $e'),
          duration: const Duration(days: 1),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Tutup',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingAvatar = false;
        });
      }
    }
  }

  // ================= EDIT PROFILE =================

  void _showEditProfile() {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const EditProfileSheet();
      },
    );
  }

  // ================= CHANGE PASSWORD =================

  void _showChangePassword() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const ChangePasswordSheet();
      },
    );
  }

  // ================= OFFLINE INFO =================

  void _showOfflineInfo() {
    AppPopUp.show(
      context: context,
      title: 'Fitur Tidak Tersedia',
      message:
          'Fitur ini membutuhkan koneksi internet. '
          'Silakan periksa koneksi internet kamu '
          'dan coba kembali.',
      type: AppPopupType.warning,
    );
  }

  // ================= SYNC INFO =================

  void _showSyncInfo() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sinkronisasi Offline'),
          content: const Text(
            'Data profil yang tersimpan di perangkat '
            'dapat ditampilkan ketika tidak ada '
            'koneksi internet.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Mengerti'),
            ),
          ],
        );
      },
    );
  }

  // ================= HELP INFO =================

  void _showHelpInfo() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Bantuan'),
          content: const Text(
            'Pusat bantuan aplikasi TeraNusa '
            'sedang dalam tahap pengembangan.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Mengerti'),
            ),
          ],
        );
      },
    );
  }

  // ================= LOGOUT =================

  Future<void> _logout() async {
    await AppPopUp.show(
      context: context,
      title: 'Konfirmasi Logout',
      message: 'Apakah kamu yakin ingin keluar dari akun?',
      type: AppPopupType.warning,
      confirmText: 'Ya, Logout',
      cancelText: 'Batal',
      onConfirm: () async {
        try {
          await ref.read(authProvider.notifier).logout();

          if (!mounted) return;

          context.go(AppRoutes.home);
        } catch (e) {
          if (!mounted) return;

          await AppPopUp.show(
            context: context,
            title: 'Logout Gagal',
            message:
                'Terjadi kesalahan saat keluar dari akun. '
                'Silakan coba kembali.',
            type: AppPopupType.error,
          );
        }
      },
    );
  }

  // ================= BOTTOM NAVIGATION =================

  void _onNavigationTap(int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;

      case 1:
        _showPageInfo('Kategori');
        break;

      case 2:
        _showPageInfo('Tersimpan');
        break;

      case 3:
        break;
    }
  }

  void _showPageInfo(String pageName) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(pageName),
          content: Text('Halaman $pageName sedang dalam tahap pengembangan.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Mengerti'),
            ),
          ],
        );
      },
    );
  }
}
