// Entity
import 'package:argos_home/domain/entity/paginator.dart';
import 'package:argos_home/domain/entity/sync.dart' as entity_sync;
import 'package:argos_home/domain/entity/task.dart' as entity_task;

// Ports
import 'package:argos_home/domain/port/server/task.dart' as port_server_task;

// Infra Commons
import 'package:argos_home/infra/sync/common.dart' as infra_sync_common;


class SqliteTaskSyncing extends infra_sync_common.SqliteSyncing<entity_task.Task> {
  SqliteTaskSyncing({
    required super.sync,
    required super.record,
    required super.persistenceAdapter,
    required super.syncRepository,
  });

  @override
  String getIdRecord(entity_task.Task record) {
    return record.id;
  }

  @override
  DateTime getUpdatedAtRecord(entity_task.Task record) {
    return record.updatedAt ?? DateTime.now();
  }
}


class TaskSync extends entity_sync.Sync<entity_task.Task> {
  TaskSync({
    required super.serverAdapter,
    required super.persistenceAdapter,
    required super.syncRepository,
    super.name = "task"
  });

  @override
  Future<entity_sync.FetchStatus<Task>> fetchServer<Task>(entity_sync.FetchStatus<Task>? lastFetch) async {
    var pager = (lastFetch == null) ? null : ((lastFetch.paginator == null) ? null : lastFetch.paginator!.getRequestForNextPaginator());
    var serverConnector = serverAdapter as port_server_task.TaskApiHttp;
    try {
      var currentPaginator = await serverConnector.get(pager);
      return entity_sync.FetchStatus<Task>(
        requireFetch: (currentPaginator != null) ? currentPaginator.hasNext : false,
        elements: (currentPaginator != null) ? currentPaginator.elements as List<Task> : [],
        paginator: currentPaginator as Paginator<Task>?,
      );
    } catch (e) {
      print("e $e");
    }
    return entity_sync.FetchStatus<Task>(
      requireFetch: false,
      elements: [],
      paginator: null,
    );
  }

  @override
  SqliteTaskSyncing getSyncing(entity_task.Task record) {
    return SqliteTaskSyncing(
        sync: this,
        record: record,
        syncRepository: syncRepository,
        persistenceAdapter: persistenceAdapter
    );
  }
}