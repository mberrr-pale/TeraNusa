import 'package:drift/drift.dart';

class UserProfiles extends Table {
  TextColumn get userId => text()();

  TextColumn get name => text().withDefault(const Constant(''))();

  TextColumn get username => text().withDefault(const Constant(''))();

  TextColumn get email => text().withDefault(const Constant(''))();

  TextColumn get phone => text().withDefault(const Constant(''))();

  TextColumn get regionId => text().withDefault(const Constant(''))();

  BoolColumn get isContributor =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get isAdmin => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {userId};
}
