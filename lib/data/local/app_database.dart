import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/user_profiles.dart';
import 'tables/regions.dart';
import 'tables/saved_opportunities.dart';
import 'tables/archived_opportunities.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [UserProfiles, Regions, SavedOpportunities, ArchivedOpportunities],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(savedOpportunities);
      }

      if (from < 3) {
        await migrator.addColumn(
          savedOpportunities,
          savedOpportunities.opportunityOwnerId as GeneratedColumn<Object>,
        );
      }
      if (from < 4) {
        await migrator.createTable(archivedOpportunities);
      }
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'teranusa_database',

    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.dart.js'),
    ),
  );
}
