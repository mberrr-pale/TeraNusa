import '../../domain/repositories/auth_repository.dart';

import '../../../../../data/models/user_profile_model.dart';
import '../models/register_request.dart';

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

    // Simpan profile untuk penggunaan offline.
    await localDataSource.saveUserProfile(profile);

    return profile;
  }

  // GET PROFILE: LOCAL FIRST
  @override
  @override
  Future<UserProfile?> getProfile(String userId) async {
    // 1. Periksa database lokal.
    final localProfile = await localDataSource.getUserProfile(userId);

    if (localProfile != null) {
      return localProfile;
    }

    // 2. Jika belum tersedia, ambil dari Supabase.
    try {
      final remoteProfile = await remoteDataSource.getUserProfile(userId);

      // 3. Simpan ke database lokal.
      await localDataSource.saveUserProfile(remoteProfile);

      return remoteProfile;
    } catch (e) {
      // Jika profil lokal tidak tersedia dan server gagal,
      // propagasikan error agar tidak dianggap sebagai logout.
      rethrow;
    }
  }

  // SYNC PROFILE: REMOTE
  @override
  Future<UserProfile> syncProfile(String userId) async {
    final profile = await remoteDataSource.getUserProfile(userId);

    await localDataSource.saveUserProfile(profile);

    return profile;
  }

  // REGISTER ONLINE
  @override
  Future<void> register(RegisterRequest request) async {
    await remoteDataSource.register(request);
  }

  // LOGOUT LOCAL
  @override
  Future<void> logout() async {
    final userId = remoteDataSource.currentUserId;

    try {
      // Hapus session lokal tanpa membutuhkan internet.
      await remoteDataSource.logout();
    } finally {
      // Tetap bersihkan profile lokal.
      if (userId != null) {
        await localDataSource.clearUserProfile(userId);
      }
    }
  }
}
