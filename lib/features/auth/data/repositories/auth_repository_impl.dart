import '../../domain/repositories/auth_repository.dart';

import '../../../../../data/models/user_profile_model.dart';
import '../models/register_request.dart';
import '../../../../../data/models/user_device_model.dart';

import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // LOGIN ONLINE
  @override
  Future<UserProfile> login({
    required String email,
    required String password,
  }) async {
    // Login harus divalidasi oleh Supabase.
    final profile = await remoteDataSource.login(
      email: email,
      password: password,
    );

    await localDataSource.saveUserProfile(profile);
    return profile;
  }

  // REGISTER ONLINE
  @override
  Future<UserProfile> register(RegisterRequest request) async {
    final response = await remoteDataSource.register(request);
    final user = response.user;

    if (user == null) {
      throw Exception('User tidak ditemukan setelah registrasi.');
    }

    final profile = await remoteDataSource.getUserProfile(user.id);

    await localDataSource.saveUserProfile(profile);

    return profile;
  }

  // GET PROFILE: LOCAL FIRST
  @override
  Future<UserProfile?> getProfile(String userId) async {
    return localDataSource.getUserProfile(userId);
  }

  // SYNC PROFILE: REMOTE
  @override
  Future<UserProfile> syncProfile(String userId) async {
    final profile = await remoteDataSource.getUserProfile(userId);

    await localDataSource.saveUserProfile(profile);

    return profile;
  }

  // SYNC DEVICE
  @override
  Future<void> syncDevice() async {
    await remoteDataSource.syncCurrentDevice();
  }

  // GET ALL USER DEVICES
  @override
  Future<List<UserDevice>> getUserDevices() async {
    return remoteDataSource.getUserDevices();
  }

  // GET ACTIVE DEVICES
  @override
  Future<List<UserDevice>> getActiveDevices() async {
    return remoteDataSource.getActiveDevices();
  }

  // LOGOUT CURRENT DEVICE
  @override
  Future<void> logout() async {
    final userId = remoteDataSource.currentUserId;

    // Logout hanya pada device saat ini.
    await remoteDataSource.logout();

    if (userId != null) {
      await localDataSource.clearUserProfile(userId);
    }
  }

  // LOGOUT ALL DEVICES
  @override
  Future<void> logoutAllDevices() async {
    final userId = remoteDataSource.currentUserId;

    await remoteDataSource.logoutAllDevices();

    if (userId != null) {
      await localDataSource.clearUserProfile(userId);
    }
  }
}
