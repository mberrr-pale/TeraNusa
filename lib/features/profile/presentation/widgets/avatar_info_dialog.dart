import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/widgets/app_popup.dart';
import '../../../../data/models/user_profile_model.dart';

class AvatarInfoDialog {
  static Future<void> show({
    required BuildContext context,
    required UserProfile user,
  }) async {
    final avatarUrl = user.avatarUrl;
    final localPath = user.avatarLocalPath;

    bool fileExists = false;
    int fileSize = 0;

    if (localPath != null && localPath.isNotEmpty) {
      final file = File(localPath);

      fileExists = await file.exists();

      if (fileExists) {
        fileSize = await file.length();
      }
    }

    if (!context.mounted) return;

    final message =
        '''
HASIL CEK AVATAR

Avatar URL:
${avatarUrl ?? 'KOSONG'}

Avatar Local Path:
${localPath ?? 'KOSONG'}

File tersedia:
${fileExists ? 'YA' : 'TIDAK'}

Ukuran file:
$fileSize bytes

Status URL:
${avatarUrl != null && avatarUrl.isNotEmpty ? 'TERISI' : 'KOSONG'}
''';

    AppPopUp.show(
      context: context,
      title: 'Informasi Avatar',
      message: message,
      type: AppPopupType.info,
    );
  }
}
