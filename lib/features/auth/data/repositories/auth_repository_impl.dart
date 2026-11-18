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

  // REGISTER ONLINE
  @override
  Future<UserProfile> register(RegisterRequest request) async {
    // 1. Register ke Supabase Auth
    final response = await remoteDataSource.register(request);

    // 2. Ambil user ID
    final user = response.user;

    if (user == null) {
      throw Exception('User tidak ditemukan setelah registrasi');
    }

    // 3. Ambil profile dari tabel profiles
    final profile = await remoteDataSource.getUserProfile(user.id);

    // 4. Simpan profile ke local database
    await localDataSource.saveUserProfile(profile);

    // 5. Return profile
    return profile;
  }

  // LOGOUT CURRENT DEVICE
  @override
  Future<void> logout() async {
    final userId = remoteDataSource.currentUserId;

    // Logout hanya pada device saat ini.
    await remoteDataSource.logout();

    // Hapus cache user pada device saat ini.
    if (userId != null) {
      await localDataSource.clearUserProfile(userId);
    }
  }
}
