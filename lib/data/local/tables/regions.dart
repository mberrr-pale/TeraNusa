import 'package:drift/drift.dart';

class Regions extends Table {
  TextColumn get regionId => text()();

  TextColumn get province => text()();

  TextColumn get city => text()();

  TextColumn get district => text()();

  TextColumn get village => text()();

  @override
  Set<Column> get primaryKey => {regionId};
}
