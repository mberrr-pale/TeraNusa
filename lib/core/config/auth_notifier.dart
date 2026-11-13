import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/config/supabase_config.dart';
import '../../../../core/providers/database_provider.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';

import '../../../../data/models/user_profile_model.dart';
import '../../features/auth/data/models/register_request.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

// Supabase Provider
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return SupabaseConfig.client;
});

// Local DataSource Provider
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource(ref.watch(databaseProvider));
});

// Remote DataSource Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(supabaseProvider));
});

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

// Auth Provider
final authProvider = AsyncNotifierProvider<AuthNotifier, UserProfile?>(
  AuthNotifier.new,
);

// Auth Notifier
class AuthNotifier extends AsyncNotifier<UserProfile?> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  SupabaseClient get _supabase => ref.read(supabaseProvider);

  @override
  @override
  Future<UserProfile?> build() async {
    final subscription = _supabase.auth.onAuthStateChange.listen((data) {
      final userId = data.session?.user.id;

      if (userId == null) {
        state = const AsyncData(null);
      } else {
        // Ambil profile dari database lokal.
        loadLocalProfile(userId);
      }
    });

    ref.onDispose(subscription.cancel);

    // Ambil session yang sudah tersimpan.
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) {
      return null;
    }

    // Tidak ada request internet di sini.
    return _repository.getProfile(userId);
  }

  Future<void> loadLocalProfile(String userId) async {
    try {
      final profile = await _repository.getProfile(userId);

      state = AsyncData(profile);
    } catch (e) {
      debugPrint('LOCAL PROFILE ERROR: $e');
    }
  }

  // REGISTER
  Future<void> register(RegisterRequest request) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.register(request);
      return null;
    });
  }

  // LOGIN
  Future<UserProfile> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final profile = await _repository.login(email: email, password: password);

      state = AsyncData(profile);

      return profile;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  // REFRESH PROFILE
  Future<void> refreshProfile([String? userId]) async {
    final id = userId ?? _supabase.auth.currentUser?.id;

    if (id == null) return;

    try {
      final profile = await _repository.syncProfile(id);
      state = AsyncData(profile);
    } catch (e) {
      // Jangan hapus profile lokal ketika sinkronisasi gagal.
      debugPrint('PROFILE SYNC ERROR: $e');
    }
  }

  // LOGOUT
  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      await _repository.logout();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
