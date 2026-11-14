import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Core
import '../../../../core/config/supabase_config.dart';
import '../../../../core/providers/database_provider.dart';

// Data Sources
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';

// Models
import '../../../../data/models/user_profile_model.dart';
import '../../data/models/register_request.dart';

// Repository
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

// ============================================================
// SUPABASE PROVIDER
// ============================================================

final supabaseProvider = Provider<SupabaseClient>((ref) {
  return SupabaseConfig.client;
});

// ============================================================
// LOCAL DATA SOURCE PROVIDER
// ============================================================

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource(ref.watch(databaseProvider));
});

// ============================================================
// REMOTE DATA SOURCE PROVIDER
// ============================================================

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(supabaseProvider));
});

// ============================================================
// REPOSITORY PROVIDER
// ============================================================

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

// ============================================================
// AUTH PROVIDER
// ============================================================

final authProvider = AsyncNotifierProvider<AuthNotifier, UserProfile?>(
  AuthNotifier.new,
);

// ============================================================
// AUTH NOTIFIER
// ============================================================

class AuthNotifier extends AsyncNotifier<UserProfile?> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  SupabaseClient get _supabase => ref.read(supabaseProvider);

  @override
  Future<UserProfile?> build() async {
    final subscription = _supabase.auth.onAuthStateChange.listen((data) {
      switch (data.event) {
        case AuthChangeEvent.signedOut:
          state = const AsyncData(null);
          break;

        case AuthChangeEvent.userDeleted:
          state = const AsyncData(null);
          break;

        case AuthChangeEvent.userUpdated:
          refreshProfile(data.session?.user.id);
          break;

        default:
          break;
      }
    });

    ref.onDispose(subscription.cancel);

    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) {
      return null;
    }

    return _repository.getProfile(userId);
  }

  // ==========================================================
  // REGISTER
  // ==========================================================

  Future<void> register(RegisterRequest request) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.register(request);
      return null;
    });
  }

  // ==========================================================
  // LOGIN
  // ==========================================================

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

  // ==========================================================
  // REFRESH PROFILE
  // ==========================================================

  Future<void> refreshProfile([String? userId]) async {
    final id = userId ?? _supabase.auth.currentUser?.id;

    if (id == null) {
      state = const AsyncData(null);
      return;
    }

    state = await AsyncValue.guard(() {
      return _repository.getProfile(id);
    });
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================

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
