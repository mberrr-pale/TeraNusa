import 'package:drift/drift.dart';

class UserProfiles extends Table {
  TextColumn get userId => text()();

  TextColumn get name => text().withDefault(const Constant(''))();

  TextColumn get username => text().withDefault(const Constant(''))();

  TextColumn get email => text().withDefault(const Constant(''))();

  TextColumn get phone => text().withDefault(const Constant(''))();

  TextColumn get regionId => text().withDefault(const Constant(''))();

  // URL foto dari Supabase Storage
  TextColumn get avatarUrl => text().nullable()();

  // Path foto yang disimpan secara lokal
  TextColumn get avatarLocalPath => text().nullable()();

  BoolColumn get isContributor =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get isAdmin => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {userId};
}
