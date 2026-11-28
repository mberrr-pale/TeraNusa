import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/providers/internet_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/app_bottom_navigation.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../data/models/user_profile_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../contributor_request/presentation/pages/contributor_application_page.dart';
import '../../../contributor_request/presentation/providers/contributor_req_provider.dart';
import '../../../admin_dashboard/presentation/widgets/contributor_application_section.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu.dart';
import '../widgets/profile_logout_button.dart';
import '../widgets/avatar_preview_dialog.dart';
import '../widgets/avatar_options_sheet.dart';
import '../widgets/edit_profile_sheet.dart';
import '../widgets/change_password_sheet.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(myContributorApplicationProvider);
      ref.invalidate(myContributorApplicationStreamProvider);
    }
  }

  bool _isUploadingAvatar = false;

  final ImagePicker _picker = ImagePicker();
  final GlobalKey<AvatarPreviewDialogState> _avatarPreviewKey =
      GlobalKey<AvatarPreviewDialogState>();

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
          padding: const EdgeInsets.only(top: 0, bottom: 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(),

              const SizedBox(height: 16),

              // PROFILE CONTENT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeader(
                      user: user,
                      isOnline: isOnline,
                      isUploadingAvatar: _isUploadingAvatar,
                      onAvatarTap: () {
                        _showAvatarPreview(user);
                      },
                      onDeleteAvatar: _deleteAvatar,
                    ),

                    const SizedBox(height: 20),

                    // PROFILE MENU
                    ProfileMenu(
                      isOnline: isOnline,
                      isContributor: user.isContributor,
                      onEditProfile: _showEditProfile,
                      onChangePassword: _showChangePassword,
                      onSaved: _openSavedPage,
                      onArchived: _openArchivedPage,
                      onOffline: _showOfflineInfo,
                      additionalItem: user.isAdmin
                          ? ContributorApplicationSection(
                              adminName: user.name,
                              regionName: user.regionId,
                            )
                          : null,
                      onContriReq: (user.isAdmin || user.isContributor)
                          ? null
                          : _showContributorReq,
                    ),

                    const SizedBox(height: 18),

                    // LOGOUT BUTTON
                    ProfileLogoutButton(isOnline: isOnline, onPressed: _logout),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: const AppBottomNavigation(),
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
      onDelete: _deleteAvatar,
      key: _avatarPreviewKey,
    );
  }

  // ================= DELETE AVATAR =================

  Future<void> _deleteAvatar() async {
    final isOnline = ref.read(internetStatusProvider).asData?.value ?? false;

    if (!isOnline) {
      _showOfflineInfo();
      return;
    }

    if (_isUploadingAvatar) return;

    try {
      setState(() {
        _isUploadingAvatar = true;
      });

      await ref.read(deleteAvatarProvider)();

      if (!mounted) return;

      // Langsung ubah preview menjadi avatar default.
      _avatarPreviewKey.currentState?.removeAvatar();

      // Refresh provider.
      ref.invalidate(authProvider);
      ref.invalidate(profileProvider);

      await AppDialog.show(
        context,
        title: 'Berhasil',
        message: 'Foto profil berhasil dihapus.',
        type: AppDialogType.success,
        confirmLabel: 'Mengerti',
      );
    } catch (e) {
      if (!mounted) return;

      await AppDialog.show(
        context,
        title: 'Gagal Menghapus Foto',
        message: 'Terjadi kesalahan: $e',
        type: AppDialogType.error,
        confirmLabel: 'Mengerti',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingAvatar = false;
        });
      }
    }
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

      // Ambil profil terbaru dari repository.
      final updatedProfile = await ref
          .read(profileRepositoryProvider)
          .getProfile();

      if (!mounted) return;

      // Refresh gambar pada dialog yang sedang terbuka.
      if (updatedProfile != null) {
        _avatarPreviewKey.currentState?.updateAvatar(
          avatarUrl: updatedProfile.avatarUrl,
          localPath: updatedProfile.avatarLocalPath,
        );
      }

      // Refresh provider.
      ref.invalidate(authProvider);
      ref.invalidate(profileProvider);

      await AppDialog.show(
        context,
        title: 'Berhasil',
        message: 'Foto profil berhasil diperbarui.',
        type: AppDialogType.success,
        confirmLabel: 'Mengerti',
      );
    } catch (e) {
      if (!mounted) return;

      await AppDialog.show(
        context,
        title: 'Gagal Memperbarui Foto',
        message: 'Terjadi kesalahan: $e',
        type: AppDialogType.error,
        confirmLabel: 'Mengerti',
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

  // ================= SAVED PAGE =================

  void _openSavedPage() {
    context.pushNamed('saved');
  }

  // ================= ARCHIVE PAGE =================

  void _openArchivedPage() {
    context.pushNamed('archived');
  }

  // ================= OFFLINE INFO =================

  void _showOfflineInfo() {
    AppDialog.show(
      context,
      title: 'Fitur Tidak Tersedia',
      message:
          'Fitur ini membutuhkan koneksi internet. '
          'Silakan periksa koneksi internet kamu '
          'dan coba kembali.',
      type: AppDialogType.warning,
    );
  }

  // ================= PENGAJUAN CONTRIBUTOR =================

  void _showContributorReq() {
    final isOnline = ref.read(internetStatusProvider).asData?.value ?? false;

    if (!isOnline) {
      _showOfflineInfo();
      return;
    }

    // Ambil ulang data dari Supabase.
    ref.invalidate(myContributorApplicationProvider);
    ref.invalidate(myContributorApplicationStreamProvider);

    ContributorApplicationSheet.show(context);
  }

  // ================= LOGOUT =================

  Future<void> _logout() async {
    await AppDialog.show(
      context,
      title: 'Konfirmasi Logout',
      message: 'Apakah kamu yakin ingin keluar dari akun?',
      type: AppDialogType.warning,
      confirmLabel: 'Ya, Logout',
      cancelLabel: 'Batal',
      onConfirm: () async {
        try {
          await ref.read(authProvider.notifier).logout();

          if (!mounted) return;

          context.go(AppRoutes.home);
        } catch (e) {
          if (!mounted) return;

          await AppDialog.show(
            context,
            title: 'Logout Gagal',
            message:
                'Terjadi kesalahan saat keluar dari akun. '
                'Silakan coba kembali.',
            type: AppDialogType.error,
            confirmLabel: 'Coba Lagi',
          );
        }
      },
    );
  }
}
