import '../../data/models/register_request.dart';
import '../../../../../data/models/user_profile_model.dart';
import '../../../../../data/models/user_device_model.dart';

abstract class AuthRepository {
  Future<UserProfile> register(RegisterRequest request);

  Future<UserProfile> login({required String email, required String password});

  // Baca profile dari database lokal.
  Future<UserProfile?> getProfile(String userId);

  // Sinkronisasi profile dari Supabase.
  Future<UserProfile> syncProfile(String userId);

  // DEVICE
  Future<void> syncDevice();

  Future<List<UserDevice>> getUserDevices();

  Future<List<UserDevice>> getActiveDevices();

  // LOGOUT CURRENT DEVICE
  Future<void> logout();

  // LOGOUT ALL DEVICES
  Future<void> logoutAllDevices();
}
