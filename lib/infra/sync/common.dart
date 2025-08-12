// Entity
import 'package:argos_home/domain/entity/sync.dart' as entity_sync;


class SqliteSyncing<T> extends entity_sync.Syncing<T> {
  late entity_sync.SyncStatus? _syncStatus;
  late bool executed = false;

  SqliteSyncing({
    required super.sync,
    required super.record,
    required super.persistenceAdapter,
    required super.syncRepository,
  });

  Future<entity_sync.SyncStatus?> getSyncStatus() async {
    if (executed) {
      return _syncStatus;
    }
    _syncStatus = await syncRepository.getByTableAndRecordId(
        sync.name,
        getIdRecord(record)
    );
    executed = true;
    return _syncStatus;
  }

  @override
  Future<bool> requireSync() async {
    var syncRepositoryResponse = await getSyncStatus();
    if (syncRepositoryResponse == null) {
      return true;
    }
    return syncRepositoryResponse.isSynced(DateTime.now());
  }

  @override
  Future<void> upsert() async {
    var currentRepository = persistenceAdapter;
    if (await getSyncStatus() == null) {
      await currentRepository.save(record);
    } else {
      await currentRepository.update(getIdRecord(record), record);
    };
  }

  @override
  Future<void> markAsSynced() async {
    var syncRepositoryResponse = await getSyncStatus();
    if (syncRepositoryResponse == null) {
      await syncRepository.save(entity_sync.SyncStatus(
          id: 0,
          table: sync.name,
          recordId: getIdRecord(record),
          lastSync: getUpdatedAtRecord(record)
      ));
    } else {
      await syncRepository.update(
          syncRepositoryResponse.id as String,
          entity_sync.SyncStatus(
              id: syncRepositoryResponse.id,
              table: sync.name,
              recordId: getIdRecord(record),
              lastSync: getUpdatedAtRecord(record)
          )
      );
    }
  }

  String getIdRecord(T record) {
    throw UnimplementedError();
  }

  DateTime getUpdatedAtRecord(T record) {
    throw UnimplementedError();
  }
}