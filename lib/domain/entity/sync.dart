// Ports
import 'package:argos_home/domain/entity/paginator.dart';
import 'package:argos_home/domain/port/server/commons.dart' as port_server_commons;
import 'package:argos_home/domain/repository/commons.dart' as repository_commons;

import 'package:argos_home/domain/repository/sync_repository.dart' as repository_sync;


enum SyncStatusType {
  synced,
  syncing,
  error,
}


class SyncStatus {
  int id;
  String table;
  String recordId;
  DateTime lastSync;

  SyncStatus({required this.id, required this.table, required this.recordId, required this.lastSync});

  factory SyncStatus.fromRow(Map<String, dynamic> row) {
    return SyncStatus(
      id: row["id"],
      table: row["table_name"],
      recordId: row["record_id"],
      lastSync: DateTime.parse(row["last_sync"]),
    );
  }

  bool isSynced(DateTime other) {
    return lastSync == other || lastSync.isAfter(other);
  }
}


class FetchStatus<T> {
  Paginator<T>? _paginator;
  bool requireFetch;
  List<T> elements;

  FetchStatus({required this.requireFetch, required this.elements, Paginator<T>? paginator}): _paginator = paginator;

  Paginator<T>? get paginator => _paginator;
}


class Sync<T> {
  String name;
  port_server_commons.AbstractServerHttp serverAdapter;
  repository_commons.Repository persistenceAdapter;
  repository_sync.SyncRepository syncRepository;

  Sync({
    required this.name,
    required this.serverAdapter,
    required this.persistenceAdapter,
    required this.syncRepository,
  });

  Future<FetchStatus<T>> fetchServer<T>(FetchStatus<T>? lastFetch) {
    throw UnimplementedError();
  }

  Syncing<T> getSyncing(T record) {
    throw UnimplementedError();
  }
}


class Syncing<T> {
  repository_commons.Repository persistenceAdapter;
  repository_sync.SyncRepository syncRepository;
  Sync sync;
  T record;

  Syncing({
    required this.sync,
    required this.record,
    required this.persistenceAdapter,
    required this.syncRepository,
  });

  Future<bool> requireSync() {
    throw UnimplementedError();
  }

  Future<void> upsert() {
    throw UnimplementedError();
  }

  Future<void> markAsSynced() {
    throw UnimplementedError();
  }
}


class SyncHandler {
  Map<String, Sync> syncs;

  SyncHandler({required List<Sync> allSyncs}): syncs = { for (var sync in allSyncs) sync.name : sync };

  Future<void> execute<T>() async {
    print("Syncing All");
    for (var syncName in syncs.keys) {
      await executeOnly<T>(syncName);
    }
    print("Sync All finished");
  }

  Future<void> executeOnly<T>(String syncName) async {
    if (!syncs.containsKey(syncName)) {
      throw Exception("Sync with name $syncName not found");
    }
    var sync = syncs[syncName]!;
    print("Sync to execute: ${sync.name}");
    bool requireFetch = true;
    FetchStatus<T>? lastFetch;
    while(requireFetch) {
      lastFetch = await sync.fetchServer(lastFetch);
      for (var element in lastFetch.elements) {
        var syncing = sync.getSyncing(element);
        if (!await syncing.requireSync()) {
          print("Sync already done");
          continue;
        }
        await syncing.upsert();
        await syncing.markAsSynced();
      };
      requireFetch = lastFetch.requireFetch;
    }
    print("Sync ${sync.name} finished");
  }
}