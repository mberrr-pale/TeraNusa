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
    final username = request.username.trim().toLowerCase();
    final email = request.email.trim().toLowerCase();

    // 1. Cek username melalui RPC
    final isTaken = await supabase.rpc(
      'is_username_taken',
      params: {'p_username': username},
    );

    if (isTaken == true) {
      throw const AuthException('Username sudah digunakan.');
    }

    try {
      // 2. Registrasi Supabase Auth
      final response = await supabase.auth.signUp(
        email: email,
        password: request.password,
        data: {...request.toMetadata(), 'username': username},
      );

      if (response.user == null) {
        throw const AuthException('User tidak ditemukan setelah registrasi');
      }

      if (response.session == null) {
        throw const AuthException(
          'Session tidak tersedia. Periksa konfigurasi Email Confirmation.',
        );
      }

      return response;
    } on AuthException catch (e) {
      // 3. Custom error email duplikat
      final message = e.message.toLowerCase();

      if (message.contains('already registered') ||
          message.contains('already exists')) {
        throw const AuthException(
          'Email sudah terdaftar. Silakan gunakan email lain.',
        );
      }

      rethrow;
    }
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
