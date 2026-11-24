import 'package:drift/drift.dart';

class ArchivedOpportunities extends Table {
  TextColumn get opportunityId => text()();

  TextColumn get userId => text()();

  TextColumn get opportunityOwnerId => text().withDefault(const Constant(''))();

  TextColumn get title => text()();

  TextColumn get description => text()();

  TextColumn get category => text()();

  TextColumn get regionId => text()();

  TextColumn get regionName => text().nullable()();

  TextColumn get regionCity => text().nullable()();

  TextColumn get regionProvince => text().nullable()();

  DateTimeColumn get endDate => dateTime()();

  TextColumn get source => text().nullable()();

  TextColumn get contact => text().nullable()();

  TextColumn get imageUrl => text().nullable()();

  BlobColumn get localImageBytes => blob().nullable()();

  TextColumn get status => text().withDefault(const Constant('archived'))();

  DateTimeColumn get createdAt => dateTime().nullable()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId, opportunityId};
}
