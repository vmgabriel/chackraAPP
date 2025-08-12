// Offline Persistence
import 'package:argos_home/infra/uow/commons.dart' as commons_uow;
import 'package:argos_home/infra/migrations/migrations.dart' as migrations_infra;

// Server
import 'package:argos_home/infra/server/login_adapter.dart' as login_infra;
import 'package:argos_home/infra/server/profile_adapter.dart' as profile_infra;
import 'package:argos_home/infra/server/board_adapter.dart' as board_infra;

// Ports
import 'package:argos_home/domain/port/uow/commons.dart' as uow_commons_port;
import 'package:argos_home/domain/port/uow/migration.dart' as migration_port;

import 'package:argos_home/domain/port/server/commons.dart' as server_commons_port;
import 'package:argos_home/domain/entity/sync.dart' as entity_sync;

// Domain Repository
import 'package:argos_home/domain/repository/commons.dart' as commons_repository;

// Infra Repositories
import 'package:argos_home/infra/repositories/access_repository.dart' as infra_access_repository;
import 'package:argos_home/infra/repositories/profile_repository.dart' as infra_profile_repository;
import 'package:argos_home/infra/repositories/sync_repository.dart' as infra_sync_repository;
import 'package:argos_home/infra/repositories/board_repository.dart' as infra_board_repository;

// Infra Syncs
import 'package:argos_home/infra/sync/profile.dart' as infra_sync_profile;
import 'package:argos_home/infra/sync/board.dart' as infra_sync_board;


class InfraBuilder {
  final uow_commons_port.AbstractUOW UOW;
  final migration_port.MigratorHandler migrator;
  final entity_sync.SyncHandler syncHandler;

  final Map<String, server_commons_port.AbstractServerHttp> servers;
  final Map<String, commons_repository.Repository> repositories;

  InfraBuilder({
    required this.UOW,
    required this.migrator,
    required this.servers,
    required this.repositories,
    required this.syncHandler,
  });

  factory InfraBuilder.build() {
    var uow = commons_uow.UOW();

    Map<String, server_commons_port.AbstractServerHttp> servers = {
      "login": login_infra.LoginAdapterApiServer(),
      "profile": profile_infra.ProfileAdapterApiServer(),
      "user": profile_infra.UserAdapterApiServer(),
      "board": board_infra.BoardAdapterApiService(),
    };

    var syncRepository = infra_sync_repository.SqliteSyncRepository(uow: uow);
    Map<String, commons_repository.Repository> repositories = {
      "access": infra_access_repository.SqliteAccessRepository(uow: uow),
      "profile": infra_profile_repository.SqliteProfileRepository(uow: uow),
      "sync": syncRepository,
      "board": infra_board_repository.SqliteBoardRepository(uow: uow),
    };

    var syncHandler = entity_sync.SyncHandler(
        allSyncs: [
          infra_sync_profile.ProfileSync(
              serverAdapter: servers["profile"]!,
              persistenceAdapter: repositories["profile"]!,
              syncRepository: syncRepository,
          ),
          infra_sync_board.BoardSync(
            serverAdapter: servers["board"]!,
            persistenceAdapter: repositories["board"]!,
            syncRepository: syncRepository,
          )
        ]
    );

    return InfraBuilder(
      UOW: uow,
      migrator: migrations_infra.build(uow),
      servers: servers,
      repositories: repositories,
      syncHandler:syncHandler,
    );
  }

  Future<void> migrate() async {
    await migrator.migrate();
  }

  T getRepository<T>(String name) {
    return repositories[name]! as T;
  }

  T getServer<T>(String name) {
    return servers[name]! as T;
  }

  Future<void> executeSync(String name) async {
    await syncHandler.executeOnly(name);
  }

  Future<void> executeSyncs() async {
    await syncHandler.execute();
  }
}