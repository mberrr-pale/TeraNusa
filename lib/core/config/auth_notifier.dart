import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/supabase_config.dart';
import '../../../../core/providers/database_provider.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/device_service.dart';

import '../../../../data/models/user_profile_model.dart';
import '../../features/auth/data/models/register_request.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

// Supabase Provider
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return SupabaseConfig.client;
});

// Device Service Provider
final deviceServiceProvider = Provider<DeviceService>((ref) {
  return DeviceService();
});

// Local DataSource Provider
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource(ref.watch(databaseProvider));
});

// Remote DataSource Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(
    ref.watch(supabaseProvider),
    ref.watch(deviceServiceProvider),
  );
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

  StreamSubscription<AuthState>? _authSubscription;

  bool _disposed = false;
  String? _syncingUserId;

  @override
  Future<UserProfile?> build() async {
    _disposed = false;

    // 1. Listen perubahan autentikasi.
    _authSubscription = _supabase.auth.onAuthStateChange.listen(
      _handleAuthChange,
      onError: (error, stackTrace) {
        debugPrint('AUTH STREAM ERROR: $error');
      },
    );

    ref.onDispose(() {
      _disposed = true;
      _authSubscription?.cancel();
    });

    // 2. Periksa session yang sudah dipulihkan.
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) {
      return null;
    }

    // 3. Ambil profile dari SQLite.
    final localProfile = await _repository.getProfile(userId);

    if (_disposed) return null;

    // 4. Jika cache tersedia, tampilkan langsung.
    if (localProfile != null) {
      // Sinkronisasi tidak memblokir startup.
      unawaited(refreshProfile(userId));

      return localProfile;
    }

    // 5. Jika cache belum tersedia, ambil dari server.
    // Contohnya setelah reinstall aplikasi.
    try {
      return await _repository.syncProfile(userId);
    } catch (e) {
      debugPrint('INITIAL PROFILE ERROR: $e');

      // Session masih ada, jangan langsung menganggap logout.
      // State null di sini perlu dibedakan oleh UI dari
      // kondisi benar-benar belum login.
      rethrow;
    }
  }

  // AUTH STATE LISTENER
  void _handleAuthChange(AuthState data) {
    if (_disposed) return;

    final event = data.event;
    final userId = data.session?.user.id;

    switch (event) {
      case AuthChangeEvent.signedOut:
        state = const AsyncData(null);
        break;

      case AuthChangeEvent.signedIn:
        if (userId != null) {
          unawaited(_handleSignedIn(userId));
        }
        break;

      case AuthChangeEvent.userUpdated:
        if (userId != null) {
          unawaited(refreshProfile(userId));
        }
        break;

      case AuthChangeEvent.tokenRefreshed:
        // Tidak perlu mengambil profile lagi.
        break;

      default:
        break;
    }
  }

  // HANDLE LOGIN
  Future<void> _handleSignedIn(String userId) async {
    try {
      final profile = await _repository.getProfile(userId);

      if (_disposed) return;

      if (profile != null) {
        state = AsyncData(profile);
        unawaited(refreshProfile(userId));
      } else {
        await refreshProfile(userId);
      }
    } catch (e) {
      debugPrint('SIGNED IN ERROR: $e');
    }
  }

  // BACKGROUND PROFILE SYNC
  Future<void> refreshProfile([String? userId]) async {
    final id = userId ?? _supabase.auth.currentUser?.id;

    if (id == null || _disposed) return;

    // Hindari request bersamaan untuk user yang sama.
    if (_syncingUserId == id) return;

    _syncingUserId = id;

    try {
      final profile = await _repository.syncProfile(id);

      if (_disposed) return;

      // Pastikan session masih aktif dan user belum berganti.
      if (_supabase.auth.currentSession == null) return;

      if (_supabase.auth.currentUser?.id != id) return;

      state = AsyncData(profile);
    } catch (e) {
      debugPrint('PROFILE SYNC ERROR: $e');
    } finally {
      if (_syncingUserId == id) {
        _syncingUserId = null;
      }
    }
  }

  // REGISTER
  Future<UserProfile> register(RegisterRequest request) async {
    if (_disposed) {
      throw Exception('AuthNotifier sudah disposed.');
    }

    state = const AsyncLoading();

    try {
      // 1. Register dan dapatkan UserProfile.
      final registeredProfile = await _repository.register(request);

      if (_disposed) return registeredProfile;

      // 2. Periksa session Supabase.
      var session = _supabase.auth.currentSession;

      // 3. Jika session belum tersedia, lakukan login.
      if (session == null) {
        final profile = await _repository.login(
          email: request.email.trim().toLowerCase(),
          password: request.password,
        );

        if (_disposed) return profile;

        session = _supabase.auth.currentSession;

        if (session == null) {
          throw const AuthException(
            'Session tidak tersedia setelah registrasi.',
          );
        }

        state = AsyncData(profile);
        return profile;
      }

      // 4. Validasi bahwa session adalah milik user yang baru didaftarkan.
      if (session.user.id != _supabase.auth.currentUser?.id) {
        throw const AuthException('Session tidak valid.');
      }

      // 5. Gunakan profile yang sudah didapatkan dari repository.
      state = AsyncData(registeredProfile);

      return registeredProfile;
    } catch (e, st) {
      if (!_disposed) {
        state = AsyncError(e, st);
      }

      rethrow;
    }
  }

  // LOGIN
  Future<UserProfile> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final profile = await _repository.login(email: email, password: password);

      if (!_disposed) {
        state = AsyncData(profile);
      }

      return profile;
    } catch (e, st) {
      if (!_disposed) {
        state = AsyncError(e, st);
      }
      rethrow;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      await _repository.logout();

      if (!_disposed) {
        state = const AsyncData(null);
      }
    } catch (e, st) {
      if (!_disposed) {
        state = AsyncError(e, st);
      }
      rethrow;
    }
  }

  // LOGOUT ALL DEVICES
  Future<void> logoutAllDevices() async {
    try {
      await ref.read(authRemoteDataSourceProvider).logoutAllDevices();

      if (!_disposed) {
        state = const AsyncData(null);
      }
    } catch (e, st) {
      debugPrint('LOGOUT ALL DEVICES ERROR: $e');

      if (!_disposed) {
        state = AsyncError(e, st);
      }

      rethrow;
    }
  }
}
