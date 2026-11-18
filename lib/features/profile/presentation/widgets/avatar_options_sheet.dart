import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';

class AvatarOptionsSheet {
  static Future<void> show({
    required BuildContext context,
    required ValueChanged<ImageSource> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Foto Profil',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.heading,
                  ),
                ),

                const SizedBox(height: 18),

                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Pilih dari Galeri'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onSelected(ImageSource.gallery);
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Ambil Foto'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onSelected(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
