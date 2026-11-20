import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:drift/drift.dart';

import '../../../../data/local/app_database.dart' as db;
import '../../../../data/models/user_profile_model.dart' as model;

class ProfileLocalDataSource {
  final db.AppDatabase database;

  ProfileLocalDataSource(this.database);

  // Simpan atau sinkronisasi profil
  Future<void> saveProfile(model.UserProfile profile) async {
    await database.transaction(() async {
      // Ambil path foto lama agar tidak hilang ketika
      // profil disinkronisasi dari Supabase.
      final existing = await (database.select(
        database.userProfiles,
      )..where((t) => t.userId.equals(profile.userId))).getSingleOrNull();

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
              avatarUrl: Value(profile.avatarUrl),
              avatarLocalPath: Value(existing?.avatarLocalPath),
              isContributor: Value(profile.isContributor),
              isAdmin: Value(profile.isAdmin),
            ),
          );
    });
  }

  // Ambil profil dari Drift
  Future<model.UserProfile?> getProfile(String userId) async {
    final result = await (database.select(
      database.userProfiles,
    )..where((table) => table.userId.equals(userId))).getSingleOrNull();

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

  // Update profil
  Future<void> updateProfile({
    required String userId,
    required String name,
    required String username,
    required String phone,
    required String regionId,
  }) async {
    await (database.update(
      database.userProfiles,
    )..where((table) => table.userId.equals(userId))).write(
      db.UserProfilesCompanion(
        name: Value(name),
        username: Value(username),
        phone: Value(phone),
        regionId: Value(regionId),
      ),
    );
  }

  // Update foto profil
  Future<void> updateAvatar({
    required String userId,
    required String avatarUrl,
    required String avatarLocalPath,
  }) async {
    await (database.update(
      database.userProfiles,
    )..where((table) => table.userId.equals(userId))).write(
      db.UserProfilesCompanion(
        avatarUrl: Value(avatarUrl),
        avatarLocalPath: Value(avatarLocalPath),
      ),
    );
  }

  Future<void> syncAvatar({
    required String userId,
    required String avatarUrl,
    required String avatarLocalPath,
  }) async {
    await database.transaction(() async {
      final existing = await (database.select(
        database.userProfiles,
      )..where((t) => t.userId.equals(userId))).getSingleOrNull();

      if (existing == null) {
        throw Exception(
          'Profil belum tersimpan di Drift. '
          'Silakan sinkronkan profil terlebih dahulu.',
        );
      }

      await (database.update(
        database.userProfiles,
      )..where((t) => t.userId.equals(userId))).write(
        db.UserProfilesCompanion(
          avatarUrl: Value(avatarUrl),
          avatarLocalPath: Value(avatarLocalPath),
        ),
      );
    });
  }

  // Hapus profil
  Future<void> clearProfile(String userId) async {
    await (database.delete(
      database.userProfiles,
    )..where((table) => table.userId.equals(userId))).go();
  }

  Future<String> saveAvatarLocally({
    required String userId,
    required File imageFile,
  }) async {
    final directory = await getApplicationDocumentsDirectory();

    final avatarDirectory = Directory(p.join(directory.path, 'avatars'));

    if (!await avatarDirectory.exists()) {
      await avatarDirectory.create(recursive: true);
    }

    final extension = p.extension(imageFile.path);
    final destination = p.join(avatarDirectory.path, '$userId$extension');

    final savedFile = await imageFile.copy(destination);

    return savedFile.path;
  }

  // Hapus foto profil lokal dan kosongkan cache avatar di Drift
  Future<void> deleteAvatarLocally({required String userId}) async {
    await database.transaction(() async {
      // 1. Ambil data profil lokal.
      final profile = await (database.select(
        database.userProfiles,
      )..where((t) => t.userId.equals(userId))).getSingleOrNull();

      if (profile == null) return;

      // 2. Hapus file avatar dari perangkat.
      final localPath = profile.avatarLocalPath;

      if (localPath != null && localPath.isNotEmpty) {
        final file = File(localPath);

        if (await file.exists()) {
          await file.delete();
        }
      }

      // 3. Kosongkan URL dan path avatar di Drift.
      await (database.update(
        database.userProfiles,
      )..where((t) => t.userId.equals(userId))).write(
        const db.UserProfilesCompanion(
          avatarUrl: Value(null),
          avatarLocalPath: Value(null),
        ),
      );
    });
  }
}
