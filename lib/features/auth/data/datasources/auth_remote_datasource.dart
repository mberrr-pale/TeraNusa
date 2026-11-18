import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/register_request.dart';
import '../../../../data/models/user_profile_model.dart';

class AuthRemoteDataSource {
  final SupabaseClient supabase;

  AuthRemoteDataSource(this.supabase);
  String? get currentUserId => supabase.auth.currentUser?.id;
  bool get isAuthenticated => supabase.auth.currentSession != null;

  // Register
  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await supabase.auth.signUp(
      email: request.email.trim().toLowerCase(),
      password: request.password,
      data: request.toMetadata(),
    );
    debugPrint('USER ID: ${response.user?.id}');
    debugPrint('SESSION: ${response.session != null}');
    debugPrint('CURRENT SESSION: ${supabase.auth.currentSession != null}');

    if (response.user == null) {
      throw const AuthException('User tidak ditemukan setelah registrasi');
    }

    if (response.session == null) {
      throw const AuthException(
        'Registrasi berhasil, tetapi session tidak tersedia. '
        'Periksa konfigurasi Email Confirmation di Supabase.',
      );
    }

    return response;
  }

  // Login
  Future<UserProfile> login({
    required String email,
    required String password,
  }) async {
    final response = await supabase.auth.signInWithPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );

    final user = response.user;

    if (user == null) {
      throw const AuthException('User tidak ditemukan');
    }

    return getUserProfile(user.id);
  }

  // Get Profile
  Future<UserProfile> getUserProfile(String userId) async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .single();

    return UserProfile.fromJson(response);
  }

  // LOGOUT CURRENT DEVICE
  Future<void> logout() async {
    await supabase.auth.signOut(scope: SignOutScope.local);
  }

  // LOGOUT ALL DEVICES
  Future<void> logoutAllDevices() async {
    await supabase.auth.signOut(scope: SignOutScope.global);
  }
}
