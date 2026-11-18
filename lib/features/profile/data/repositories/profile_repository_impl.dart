import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../data/models/user_profile_model.dart';
import 'profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../datasources/profile_local_datasource.dart';
import '../models/profile_request.dart';
import '../models/change_password_request.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final SupabaseClient supabase;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.supabase,
  });

  @override
  Future<UserProfile?> getProfile() async {
    final user = supabase.auth.currentUser;

    if (user == null) return null;

    try {
      final response = await remoteDataSource.getProfile(user.id);

      final profile = UserProfile.fromJson(response);

      await localDataSource.saveProfile(profile);

      return profile;
    } catch (e) {
      return await localDataSource.getProfile(user.id);
    }
  }

  @override
  Future<void> updateProfile(UpdateProfileRequest request) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    await remoteDataSource.updateProfile(
      userId: user.id,
      data: request.toJson(),
    );

    final updatedProfile = await getProfile();

    if (updatedProfile == null) {
      throw Exception('Gagal memperbarui cache profil.');
    }
  }

  @override
  Future<void> changePassword(ChangePasswordRequest request) async {
    await remoteDataSource.changePassword(
      currentPassword: request.currentPassword,
      newPassword: request.newPassword,
    );
  }

  // ================= UPDATE AVATAR =================

  @override
  Future<void> updateAvatar(File imageFile) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    // 1. Upload foto ke Supabase.
    final avatarUrl = await remoteDataSource.uploadAvatar(
      userId: user.id,
      filePath: imageFile.path,
    );

    // 2. Simpan file foto ke perangkat.
    final localPath = await localDataSource.saveAvatarLocally(
      userId: user.id,
      imageFile: imageFile,
    );

    // 3. Ambil data profil terbaru dari Supabase.
    final response = await remoteDataSource.getProfile(user.id);

    final profile = UserProfile.fromJson(response);

    // 4. Pastikan profil sudah masuk ke Drift.
    await localDataSource.saveProfile(profile);

    // 5. Update URL dan path avatar di Drift.
    await localDataSource.updateAvatar(
      userId: user.id,
      avatarUrl: avatarUrl,
      avatarLocalPath: localPath,
    );

    // Selesai.
  }
}
