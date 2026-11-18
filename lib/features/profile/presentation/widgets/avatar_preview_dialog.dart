import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/user_profile_model.dart';

class AvatarPreviewDialog extends StatelessWidget {
  final UserProfile user;
  final VoidCallback onEdit;

  const AvatarPreviewDialog({
    super.key,
    required this.user,
    required this.onEdit,
  });

  static Future<void> show({
    required BuildContext context,
    required UserProfile user,
    required VoidCallback onEdit,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.95),
      builder: (_) => AvatarPreviewDialog(user: user, onEdit: onEdit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          InteractiveViewer(minScale: 0.5, maxScale: 4, child: _buildImage()),

          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigator.pop(context);
                onEdit();
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Foto Profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final avatarUrl = user.avatarUrl;

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return Image.network(
        avatarUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) {
          return _buildLocalImage();
        },
      );
    }

    return _buildLocalImage();
  }

  Widget _buildLocalImage() {
    final path = user.avatarLocalPath;

    if (path != null && path.isNotEmpty) {
      final file = File(path);

      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.contain);
      }
    }

    return const Icon(Icons.person, color: Colors.white, size: 100);
  }
}
