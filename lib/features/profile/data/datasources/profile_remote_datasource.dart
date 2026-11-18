import 'dart:io';

import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRemoteDataSource {
  final SupabaseClient supabase;

  ProfileRemoteDataSource(this.supabase);

  Future<Map<String, dynamic>> getProfile(String userId) async {
    return await supabase
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .single();
  }

  Future<void> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await supabase.from('profiles').update(data).eq('user_id', userId);
  }

  Future<String> uploadAvatar({
    required String userId,
    required String filePath,
  }) async {
    final file = File(filePath);

    if (!await file.exists()) {
      throw Exception('File foto tidak ditemukan.');
    }

    // Deteksi format gambar.
    final extension = p.extension(filePath).toLowerCase();
    final mimeType = lookupMimeType(filePath) ?? 'image/jpeg';

    if (!mimeType.startsWith('image/')) {
      throw Exception('File harus berupa gambar.');
    }

    // Nama file mengikuti format aslinya.
    final storagePath = '$userId/profile$extension';

    // Upload dengan overwrite.
    await supabase.storage
        .from('avatars')
        .upload(
          storagePath,
          file,
          fileOptions: FileOptions(
            upsert: true,
            contentType: mimeType,
            cacheControl: '0',
          ),
        );

    // Ambil URL.
    final avatarUrl = supabase.storage
        .from('avatars')
        .getPublicUrl(storagePath);

    final updatedUrl = '$avatarUrl?v=${DateTime.now().millisecondsSinceEpoch}';

    // Update database.
    await supabase
        .from('profiles')
        .update({'avatar_url': updatedUrl})
        .eq('user_id', userId);

    return updatedUrl;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = supabase.auth.currentUser;

    if (user == null || user.email == null) {
      throw Exception('Pengguna belum login.');
    }

    await supabase.auth.signInWithPassword(
      email: user.email!,
      password: currentPassword,
    );

    await supabase.auth.updateUser(UserAttributes(password: newPassword));
  }
}
