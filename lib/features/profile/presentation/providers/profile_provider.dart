import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/providers/database_provider.dart';
import '../../data/models/profile_request.dart';
import '../../data/models/change_password_request.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/datasources/profile_local_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/profile_repository.dart';
import '../../../auth/data/datasources/auth_remote_datasource.dart';

// Remote DataSource
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  return ProfileRemoteDataSource(Supabase.instance.client);
});

// Local DataSource
final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  return ProfileLocalDataSource(ref.watch(databaseProvider));
});

// Repository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
    localDataSource: ref.watch(profileLocalDataSourceProvider),
    supabase: Supabase.instance.client,
  );
});

// Get Profile
final profileProvider = FutureProvider.autoDispose((ref) async {
  return ref.watch(profileRepositoryProvider).getProfile();
});

// Update Profile
final updateProfileProvider = Provider((ref) {
  return (UpdateProfileRequest request) {
    return ref.read(profileRepositoryProvider).updateProfile(request);
  };
});

// Change Password Provider
final changePasswordProvider = Provider((ref) {
  return (ChangePasswordRequest request) {
    return ref.read(profileRepositoryProvider).changePassword(request);
  };
});

final logoutAllDevicesProvider = Provider((ref) {
  final authRemoteDataSource = AuthRemoteDataSource(Supabase.instance.client);

  return () async {
    await authRemoteDataSource.logoutAllDevices();
  };
});

// Update Avatar Provider
final updateAvatarProvider = Provider((ref) {
  return (File imageFile) {
    return ref.read(profileRepositoryProvider).updateAvatar(imageFile);
  };
});

// Delete Avatar Provider
final deleteAvatarProvider = Provider((ref) {
  return () {
    return ref.read(profileRepositoryProvider).deleteAvatar();
  };
});
