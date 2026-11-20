import 'package:flutter/material.dart';

import '../../../../data/models/user_profile_model.dart';
import '../../../../core/theme/app_colors.dart';
import 'profile_avatar.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile user;
  final bool isOnline;
  final bool isUploadingAvatar;
  final VoidCallback onAvatarTap;
  final VoidCallback onDeleteAvatar;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.isOnline,
    required this.isUploadingAvatar,
    required this.onAvatarTap,
    required this.onDeleteAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final role = user.isAdmin
        ? 'Admin'
        : user.isContributor
        ? 'Kontributor'
        : 'Pencari';

    final roleIcon = user.isAdmin
        ? Icons.admin_panel_settings
        : user.isContributor
        ? Icons.edit_note
        : Icons.search;

    return Column(
      children: [
        Container(
          height: 105,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, Color(0xFF66BB6A)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(17, 51, 17, 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(19),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name.isNotEmpty ? user.name : 'Pengguna',
                    style: const TextStyle(
                      fontSize: 24,
                      color: AppColors.heading,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@${user.username} · ${user.email}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              left: 18,
              top: -39,
              child: GestureDetector(
                onTap: isUploadingAvatar ? null : onAvatarTap,
                child: ProfileAvatar(
                  user: user,
                  isOnline: isOnline,
                  isUploading: isUploadingAvatar,
                  onEdit: onAvatarTap,
                  onDelete: onDeleteAvatar,
                ),
              ),
            ),

            Positioned(
              right: 10,
              top: 15,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(roleIcon, color: AppColors.primary, size: 12),
                    const SizedBox(width: 5),
                    Text(
                      role,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
