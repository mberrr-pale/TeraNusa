import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/user_profiles.dart';
import 'tables/regions.dart';
import 'tables/saved_opportunities.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [UserProfiles, Regions, SavedOpportunities])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

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
