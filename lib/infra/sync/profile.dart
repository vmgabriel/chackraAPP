// Entity
import 'package:argos_home/domain/entity/sync.dart' as entity_sync;
import 'package:argos_home/domain/entity/profile.dart' as entity_profile;

// Ports
import 'package:argos_home/domain/port/server/profile.dart' as port_server_profile;

// Infra Commons
import 'package:argos_home/infra/sync/common.dart' as infra_sync_common;


class SqliteProfileSyncing extends infra_sync_common.SqliteSyncing<entity_profile.Profile> {
  SqliteProfileSyncing({
    required super.sync,
    required super.record,
    required super.persistenceAdapter,
    required super.syncRepository,
  });

  @override
  String getIdRecord(entity_profile.Profile record) {
    return record.id;
  }

  @override
  DateTime getUpdatedAtRecord(entity_profile.Profile record) {
    return record.updatedAt;
  }
}


class ProfileSync extends entity_sync.Sync<entity_profile.Profile> {
  ProfileSync({
    required super.serverAdapter,
    required super.persistenceAdapter,
    required super.syncRepository,
    super.name = "profile"
  });

  @override
  Future<entity_sync.FetchStatus<Profile>> fetchServer<Profile>(entity_sync.FetchStatus<Profile>? lastFetch) async {
    var serverConnector = serverAdapter as port_server_profile.ProfileApiHttp;
    var record = await serverConnector.get();
    return entity_sync.FetchStatus<Profile>(requireFetch: false, elements: [record as Profile]);
  }

  @override
  SqliteProfileSyncing getSyncing(entity_profile.Profile record) {
    return SqliteProfileSyncing(
        sync: this,
        record: record,
        syncRepository: syncRepository,
        persistenceAdapter: persistenceAdapter
    );
  }
}