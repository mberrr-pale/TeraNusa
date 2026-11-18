import 'package:drift/drift.dart';

import '../../../../data/local/app_database.dart' as db;
import '../../../../data/models/user_profile_model.dart' as model;

class AuthLocalDataSource {
  final db.AppDatabase database;

  AuthLocalDataSource(this.database);

  // SIMPAN / SINKRONISASI PROFIL
  Future<void> saveUserProfile(model.UserProfile profile) async {
    await database.transaction(() async {
      // Ambil data lokal sebelumnya.
      final existing =
          await (database.select(database.userProfiles)
                ..where((table) => table.userId.equals(profile.userId)))
              .getSingleOrNull();

      await database
          .into(database.userProfiles)
          .insertOnConflictUpdate(
            db.UserProfilesCompanion.insert(
              userId: profile.userId,
              name: Value(profile.name),
              username: Value(profile.username),
              email: Value(profile.email),
              phone: Value(profile.phone),
              regionId: Value(profile.regionId),

              // Simpan URL avatar dari Supabase.
              avatarUrl: Value(profile.avatarUrl),

              // Pertahankan file avatar lokal.
              avatarLocalPath: Value(existing?.avatarLocalPath),

              isContributor: Value(profile.isContributor),
              isAdmin: Value(profile.isAdmin),
            ),
          );
    });
  }

  // AMBIL PROFIL DARI DRIFT
  Future<model.UserProfile?> getUserProfile(String userId) async {
    final query = database.select(database.userProfiles)
      ..where((table) => table.userId.equals(userId));

    final result = await query.getSingleOrNull();

    if (result == null) return null;

    return model.UserProfile(
      userId: result.userId,
      name: result.name,
      username: result.username,
      email: result.email,
      phone: result.phone,
      regionId: result.regionId,
      avatarUrl: result.avatarUrl,
      avatarLocalPath: result.avatarLocalPath,
      isContributor: result.isContributor,
      isAdmin: result.isAdmin,
    );
  }

  // HAPUS PROFIL
  Future<void> clearUserProfile(String userId) async {
    await (database.delete(
      database.userProfiles,
    )..where((table) => table.userId.equals(userId))).go();
  }
}
