// Entity
import 'package:argos_home/domain/entity/paginator.dart';
import 'package:argos_home/domain/entity/sync.dart' as entity_sync;
import 'package:argos_home/domain/entity/board.dart' as entity_board;

// Ports
import 'package:argos_home/domain/port/server/board.dart' as port_server_board;

// Infra Commons
import 'package:argos_home/infra/sync/common.dart' as infra_sync_common;


class SqliteBoardSyncing extends infra_sync_common.SqliteSyncing<entity_board.Board> {
  SqliteBoardSyncing({
    required super.sync,
    required super.record,
    required super.persistenceAdapter,
    required super.syncRepository,
  });

  @override
  String getIdRecord(entity_board.Board record) {
    return record.id;
  }

  @override
  DateTime getUpdatedAtRecord(entity_board.Board record) {
    return record.updatedAt ?? DateTime.now();
  }
}


class BoardSync extends entity_sync.Sync<entity_board.Board> {
  BoardSync({
    required super.serverAdapter,
    required super.persistenceAdapter,
    required super.syncRepository,
    super.name = "board"
  });

  @override
  Future<entity_sync.FetchStatus<Board>> fetchServer<Board>(entity_sync.FetchStatus<Board>? lastFetch) async {
    var pager = (lastFetch == null) ? null : ((lastFetch.paginator == null) ? null : lastFetch.paginator!.getRequestForNextPaginator());
    var serverConnector = serverAdapter as port_server_board.BoardApiHttp;
    try {
      var currentPaginator = await serverConnector.get(pager);
      print("currentPaginator $currentPaginator");
      print(currentPaginator!.elements);
      return entity_sync.FetchStatus<Board>(
        requireFetch: (currentPaginator != null) ? currentPaginator.hasNext : false,
        elements: (currentPaginator != null) ? currentPaginator.elements as List<Board> : [],
        paginator: currentPaginator as Paginator<Board>?,
      );
    } catch (e) {
      print("e $e");
    }
    return entity_sync.FetchStatus<Board>(
      requireFetch: false,
      elements: [],
      paginator: null,
    );
  }

  @override
  SqliteBoardSyncing getSyncing(entity_board.Board record) {
    return SqliteBoardSyncing(
        sync: this,
        record: record,
        syncRepository: syncRepository,
        persistenceAdapter: persistenceAdapter
    );
  }
}