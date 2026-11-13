import '../../data/models/register_request.dart';
import '../../../../../data/models/user_profile_model.dart';

abstract class AuthRepository {
  Future<void> register(RegisterRequest request);

  Future<UserProfile> login({required String email, required String password});

  // Baca profile dari database lokal.
  Future<UserProfile?> getProfile(String userId);

  // Sinkronisasi profile dari Supabase.
  Future<UserProfile> syncProfile(String userId);

  Future<void> logout();
}
