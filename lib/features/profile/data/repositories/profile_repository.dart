import 'dart:io';

import '../../../../data/models/user_profile_model.dart';
import '../models/profile_request.dart';
import '../models/change_password_request.dart';

abstract class ProfileRepository {
  Future<UserProfile?> getProfile();

  Future<void> updateProfile(UpdateProfileRequest request);

  Future<void> changePassword(ChangePasswordRequest request);

  Future<void> updateAvatar(File imageFile);

  Future<void> deleteAvatar();
}
