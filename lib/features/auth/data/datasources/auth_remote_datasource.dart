import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/register_request.dart';
import '../../../../data/models/user_profile_model.dart';
import '../../../../data/models/user_device_model.dart';
import 'device_service.dart';

class AuthRemoteDataSource {
  final SupabaseClient supabase;
  final DeviceService deviceService;

  AuthRemoteDataSource(this.supabase, this.deviceService);

  // AUTH STATE
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

      // REGISTER DEVICE
      await syncCurrentDevice();

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
      throw const AuthException('User tidak ditemukan.');
    }

    // GET PROFILE
    final profile = await getUserProfile(user.id);

    // SYNC DEVICE
    // Tidak menggagalkan login jika FCM gagal.
    try {
      await syncCurrentDevice();
    } catch (e) {
      // Log error untuk retry sinkronisasi.
    }

    return profile;
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

  // REGISTER / UPDATE DEVICE
  Future<void> registerDevice({
    required String fcmToken,
    required String deviceType,
    String? deviceName,
  }) async {
    if (!isAuthenticated) {
      throw const AuthException('User belum login.');
    }

    await supabase.rpc(
      'register_user_device',
      params: {
        'p_fcm_token': fcmToken,
        'p_device_type': deviceType,
        'p_device_name': deviceName,
      },
    );
  }

  // SYNC CURRENT DEVICE

  Future<void> syncCurrentDevice() async {
    try {
      final device = await deviceService.getDeviceInformation();
      final token = device['fcmToken'];

      print('FCM token available: ${token != null && token.isNotEmpty}');

      if (token == null || token.isEmpty) {
        print('ERROR: FCM token kosong');
        return;
      }

      print('Sending device data to Supabase...');

      await registerDevice(
        fcmToken: token,
        deviceType: device['deviceType']!,
        deviceName: device['deviceName'],
      );

      print('SUCCESS: Device berhasil disimpan');

      print('========== DEVICE SYNC END ==========');
    } catch (e, stackTrace) {
      print('DEVICE SYNC ERROR: $e');
      print(stackTrace);
      rethrow;
    }
  }

  // GET ALL DEVICES
  Future<List<UserDevice>> getUserDevices() async {
    if (!isAuthenticated) {
      throw const AuthException('User belum login.');
    }

    final response = await supabase
        .from('user_devices')
        .select()
        .eq('user_id', currentUserId!)
        .order('last_seen_at', ascending: false);

    return response
        .map<UserDevice>((json) => UserDevice.fromJson(json))
        .toList();
  }

  // GET ACTIVE DEVICES
  Future<List<UserDevice>> getActiveDevices() async {
    if (!isAuthenticated) {
      throw const AuthException('User belum login.');
    }

    final response = await supabase
        .from('user_devices')
        .select()
        .eq('user_id', currentUserId!)
        .eq('is_active', true)
        .order('last_seen_at', ascending: false);

    return response
        .map<UserDevice>((json) => UserDevice.fromJson(json))
        .toList();
  }

  // DEACTIVATE DEVICE
  Future<void> deactivateDevice(String fcmToken) async {
    final userId = currentUserId;

    if (userId == null) return;

    await supabase
        .from('user_devices')
        .update({
          'is_active': false,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('user_id', userId)
        .eq('fcm_token', fcmToken);
  }

  // DEACTIVATE ALL DEVICES
  Future<void> deactivateAllDevices() async {
    final userId = currentUserId;

    if (userId == null) return;

    await supabase
        .from('user_devices')
        .update({
          'is_active': false,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('user_id', userId);
  }

  // LOGOUT CURRENT DEVICE
  Future<void> logout() async {
    final token = await deviceService.getFcmToken();

    if (token != null) {
      await deactivateDevice(token);
    }

    await supabase.auth.signOut(scope: SignOutScope.local);
  }

  // LOGOUT ALL DEVICES
  Future<void> logoutAllDevices() async {
    await deactivateAllDevices();
    await supabase.auth.signOut(scope: SignOutScope.global);
  }
}
