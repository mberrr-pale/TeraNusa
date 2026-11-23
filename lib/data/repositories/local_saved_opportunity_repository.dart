import 'package:drift/drift.dart';

import '../local/app_database.dart';
import '../models/opportunity.dart';

class LocalSavedOpportunityRepository {
  final AppDatabase _database;

  LocalSavedOpportunityRepository(this._database);

  // Mengambil ID seluruh peluang yang tersimpan secara lokal.
  Future<Set<String>> getSavedOpportunityIds(String userId) async {
    final query = _database.select(_database.savedOpportunities)
      ..where((table) => table.userId.equals(userId));

    final results = await query.get();

    return results.map((item) => item.opportunityId).toSet();
  }

  // Mengambil detail peluang yang tersimpan secara lokal.
  Future<List<Opportunity>> getSavedOpportunities(String userId) async {
    final query = _database.select(_database.savedOpportunities)
      ..where((table) => table.userId.equals(userId))
      ..orderBy([(table) => OrderingTerm.desc(table.cachedAt)]);

    final results = await query.get();

    return results.map((item) {
      return Opportunity(
        opportunityId: item.opportunityId,
        userId: item.opportunityOwnerId,
        title: item.title,
        description: item.description,
        category: item.category,
        regionId: item.regionId,
        regionName: item.regionName,
        regionCity: item.regionCity,
        regionProvince: item.regionProvince,
        endDate: item.endDate,
        source: item.source,
        contact: item.contact,
        imageUrl: item.imageUrl,
        localImageBytes: item.localImageBytes,
        status: item.status,
        createdAt: item.createdAt,
      );
    }).toList();
  }

  // Menyimpan atau memperbarui cache peluang.
  Future<void> saveOpportunity({
    required Opportunity opportunity,
    required String savedByUserId,
    Uint8List? localImageBytes,
  }) async {
    final opportunityId = opportunity.opportunityId;

    if (opportunityId == null || opportunityId.trim().isEmpty) {
      throw ArgumentError('ID peluang tidak boleh kosong.');
    }

    final existingQuery = _database.select(_database.savedOpportunities)
      ..where(
        (table) =>
            table.userId.equals(savedByUserId) &
            table.opportunityId.equals(opportunityId),
      );

    final existing = await existingQuery.getSingleOrNull();

    final keepExistingImage = existing?.imageUrl == opportunity.imageUrl;

    await _database
        .into(_database.savedOpportunities)
        .insertOnConflictUpdate(
          SavedOpportunitiesCompanion.insert(
            opportunityId: opportunityId,
            userId: savedByUserId,
            opportunityOwnerId: Value(opportunity.userId),
            title: opportunity.title,
            description: opportunity.description,
            category: opportunity.category,
            regionId: opportunity.regionId,
            endDate: opportunity.endDate,
            cachedAt: DateTime.now(),
            regionName: Value(opportunity.regionName),
            regionCity: Value(opportunity.regionCity),
            regionProvince: Value(opportunity.regionProvince),
            source: Value(opportunity.source),
            contact: Value(opportunity.contact),
            imageUrl: Value(opportunity.imageUrl),
            localImageBytes: Value(
              localImageBytes ??
                  (keepExistingImage ? existing?.localImageBytes : null),
            ),
            status: Value(opportunity.status),
            createdAt: Value(opportunity.createdAt),
          ),
        );
  }

  // Menghapus peluang dari penyimpanan lokal.
  Future<void> removeSavedOpportunity({
    required String userId,
    required String opportunityId,
  }) async {
    await (_database.delete(_database.savedOpportunities)..where(
          (table) =>
              table.userId.equals(userId) &
              table.opportunityId.equals(opportunityId),
        ))
        .go();
  }
}
