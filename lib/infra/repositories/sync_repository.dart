// Domain Entity
import 'package:argos_home/domain/entity/sync.dart' as entity_sync;

// Domain Repository
import 'package:argos_home/domain/repository/sync_repository.dart' as domain_repository_sync;


class SqliteSyncRepository extends domain_repository_sync.SyncRepository {
  SqliteSyncRepository({required super.uow});

  @override
  Future<entity_sync.SyncStatus?> getByTableAndRecordId(String table, String recordId) async {
    const String selectByTableAndRecordIdQuery = "SELECT * FROM tbl_sync WHERE table_name = ? AND record_id = ?";

    var responseData = await uow.atomicGet<entity_sync.SyncStatus>(
      selectByTableAndRecordIdQuery,
      entity_sync.SyncStatus.fromRow,
      [table, recordId],
    );
    return responseData.isNotEmpty ? responseData.first : null;
  }

  @override
  Future<void> save(entity_sync.SyncStatus record) async {
    const String insertQuery = "INSERT INTO tbl_sync (table_name, record_id, last_sync) VALUES (?, ?, ?)";
    await uow.session((session) async {
      await session.execute(
        insertQuery,
        [
          record.table,
          record.recordId,
          record.lastSync.toIso8601String(),
        ]
      );
      await session.commit();
    });
  }

  @override
  Future<void> update(String id, entity_sync.SyncStatus record) async {
    const String updateQuery = "UPDATE tbl_sync SET table_name = ?, record_id = ?, last_sync = ? WHERE id = ?";

    await uow.session((session) async {
      await session.execute(
        updateQuery,
        [
          record.table,
          record.recordId,
          record.lastSync.toIso8601String(),
          id,
        ]
      );
      await session.commit();
    });
  }
}

