import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../data/models/user_profile_model.dart';

class AvatarPreviewDialog extends StatefulWidget {
  final UserProfile user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AvatarPreviewDialog({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  static Future<void> show({
    required BuildContext context,
    required UserProfile user,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    Key? key,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.95),
      builder: (_) => AvatarPreviewDialog(
        key: key,
        user: user,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }

  @override
  State<AvatarPreviewDialog> createState() => AvatarPreviewDialogState();
}

class AvatarPreviewDialogState extends State<AvatarPreviewDialog> {
  late String? _avatarUrl;
  late String? _avatarLocalPath;

  @override
  void initState() {
    super.initState();

    _avatarUrl = widget.user.avatarUrl;
    _avatarLocalPath = widget.user.avatarLocalPath;
  }

  // Update avatar setelah upload berhasil.
  void updateAvatar({required String? avatarUrl, required String? localPath}) {
    if (!mounted) return;

    setState(() {
      _avatarUrl = avatarUrl;
      _avatarLocalPath = localPath;
    });
  }

  // Reset avatar setelah penghapusan berhasil.
  void removeAvatar() {
    if (!mounted) return;

    setState(() {
      _avatarUrl = null;
      _avatarLocalPath = null;
    });
  }

  bool get hasAvatar {
    final url = _avatarUrl;
    final path = _avatarLocalPath;

    return (url != null && url.isNotEmpty) ||
        (path != null && path.isNotEmpty && File(path).existsSync());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            // Tombol tutup
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
              ),
            ),

            // Preview gambar
            Expanded(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: SizedBox(
                  width: double.infinity,
                  child: Center(child: _buildImage()),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Tombol edit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.onEdit,
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

            // Tombol hapus
            if (hasAvatar) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmDelete(context),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Hapus Foto Profil'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    await AppDialog.show(
      context,
      title: 'Hapus Foto Profil?',
      message: 'Apakah kamu yakin ingin menghapus foto profil ini?',
      type: AppDialogType.warning,
      confirmLabel: 'Ya, Hapus',
      cancelLabel: 'Batal',
      onConfirm: () {
        Navigator.pop(context);
        widget.onDelete();
      },
    );
  }

  Widget _buildImage() {
    final avatarUrl = _avatarUrl;

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return Image.network(
        avatarUrl,
        key: ValueKey(avatarUrl),
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _buildLocalImage(),
      );
    }

    return _buildLocalImage();
  }

  Widget _buildLocalImage() {
    final path = _avatarLocalPath;

    if (path != null && path.isNotEmpty) {
      final file = File(path);

      if (file.existsSync()) {
        return Image.file(file, key: ValueKey(path), fit: BoxFit.contain);
      }
    }

    return const Icon(Icons.person, color: Colors.white, size: 100);
  }
}
