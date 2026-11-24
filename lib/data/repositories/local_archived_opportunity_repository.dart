import 'package:drift/drift.dart';

import '../local/app_database.dart';
import '../models/opportunity.dart';

class LocalArchivedOpportunityRepository {
  final AppDatabase _database;

  LocalArchivedOpportunityRepository(this._database);

  // Mengambil seluruh ID arsip milik pengguna secara lokal.
  Future<Set<String>> getArchivedOpportunityIds(String userId) async {
    final query = _database.select(_database.archivedOpportunities)
      ..where((table) => table.userId.equals(userId));

    final results = await query.get();

    return results.map((item) => item.opportunityId).toSet();
  }

  // Mengambil seluruh arsip milik pengguna secara lokal.
  Future<List<Opportunity>> getArchivedOpportunities(String userId) async {
    final query = _database.select(_database.archivedOpportunities)
      ..where((table) => table.userId.equals(userId))
      ..orderBy([(table) => OrderingTerm.desc(table.endDate)]);

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
        deletedAt: item.deletedAt,
      );
    }).toList();
  }

  // Menyimpan atau memperbarui satu arsip secara lokal.
  Future<void> saveArchivedOpportunity({
    required Opportunity opportunity,
    required String userId,
    Uint8List? localImageBytes,
  }) async {
    final opportunityId = opportunity.opportunityId;

    if (opportunityId == null || opportunityId.trim().isEmpty) {
      throw ArgumentError('ID peluang tidak boleh kosong.');
    }

    final existingQuery = _database.select(_database.archivedOpportunities)
      ..where(
        (table) =>
            table.userId.equals(userId) &
            table.opportunityId.equals(opportunityId),
      );

    final existing = await existingQuery.getSingleOrNull();

    final keepExistingImage = existing?.imageUrl == opportunity.imageUrl;

    await _database
        .into(_database.archivedOpportunities)
        .insertOnConflictUpdate(
          ArchivedOpportunitiesCompanion.insert(
            opportunityId: opportunityId,
            userId: userId,
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
            deletedAt: Value(opportunity.deletedAt),
          ),
        );
  }

  // Menghapus satu arsip dari penyimpanan lokal.
  Future<void> removeArchivedOpportunity({
    required String userId,
    required String opportunityId,
  }) async {
    await (_database.delete(_database.archivedOpportunities)..where(
          (table) =>
              table.userId.equals(userId) &
              table.opportunityId.equals(opportunityId),
        ))
        .go();
  }

  // Menyinkronkan arsip lokal dengan data arsip terbaru dari server.
  // Hanya dipanggil setelah pengambilan data Supabase berhasil.
  Future<void> syncArchivedOpportunities({
    required String userId,
    required List<Opportunity> opportunities,
  }) async {
    await _database.transaction(() async {
      // Simpan atau perbarui data arsip dari server.
      for (final opportunity in opportunities) {
        await saveArchivedOpportunity(opportunity: opportunity, userId: userId);
      }

      // Ambil ID arsip terbaru dari server.
      final serverIds = opportunities
          .map((item) => item.opportunityId)
          .whereType<String>()
          .where((id) => id.trim().isNotEmpty)
          .toSet();

      // Bandingkan dengan ID arsip yang tersimpan secara lokal.
      final localIds = await getArchivedOpportunityIds(userId);
      final removedIds = localIds.difference(serverIds);

      // Hapus cache yang sudah tidak tersedia di server.
      for (final id in removedIds) {
        await removeArchivedOpportunity(userId: userId, opportunityId: id);
      }
    });
  }
}
