import 'package:argos_home/domain/entity/sync.dart' as entity_sync;

// Repository
import 'package:argos_home/domain/repository/commons.dart' as commons_repository;


class SyncRepository extends commons_repository.Repository<entity_sync.SyncStatus> {
  SyncRepository({required super.uow});

  Future<entity_sync.SyncStatus?> getByTableAndRecordId(String table, String recordId) {
    throw UnimplementedError();
  }
}