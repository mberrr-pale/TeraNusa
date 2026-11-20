import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../data/models/user_profile_model.dart';
import '../../../../core/theme/app_colors.dart';
import 'avatar_preview_dialog.dart';

class ProfileAvatar extends StatelessWidget {
  final UserProfile user;
  final bool isOnline;
  final bool isUploading;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProfileAvatar({
    super.key,
    required this.user,
    required this.isOnline,
    required this.isUploading,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isUploading
              ? null
              : () {
                  AvatarPreviewDialog.show(
                    context: context,
                    user: user,
                    onEdit: onEdit,
                    onDelete: onDelete,
                  );
                },
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bannerStart,
              border: Border.all(color: AppColors.white, width: 4),
            ),
            child: ClipOval(child: _buildImage()),
          ),
        ),

        // Tombol kamera
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isUploading ? null : onEdit,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: isOnline ? AppColors.primary : Colors.grey,
                border: Border.all(color: AppColors.white, width: 2),
                borderRadius: BorderRadius.circular(9),
              ),
              child: isUploading
                  ? const Padding(
                      padding: EdgeInsets.all(5),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 13,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    final url = user.avatarUrl;
    final path = user.avatarLocalPath;

    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        key: ValueKey(url),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _localImage(path),
      );
    }

    return _localImage(path);
  }

  Widget _localImage(String? path) {
    if (path != null && path.isNotEmpty) {
      final file = File(path);

      if (file.existsSync()) {
        return Image.file(
          file,
          key: ValueKey(path),
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _defaultAvatar(),
        );
      }
    }

    return _defaultAvatar();
  }

  Widget _defaultAvatar() {
    return const ColoredBox(
      color: AppColors.bannerStart,
      child: Icon(Icons.person, size: 40, color: Colors.white),
    );
  }
}
