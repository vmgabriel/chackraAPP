import 'package:argos_home/domain/port/uow/migration.dart' as migration_port;
import 'package:argos_home/domain/port/uow/commons.dart' as abstract_uow;

// Custom Migrations
import 'package:argos_home/infra/migrations/custom_migrations.dart' as custom_migrations;


final String createTableOfMigrationsExecute = """
CREATE TABLE IF NOT EXISTS tbl_migrations (
  priority INTEGER PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
""";
final String createTableOfMigrationsRollback = """
DROP TABLE IF EXISTS tbl_migrations;
""";
final createTableOfMigrations = migration_port.Migrator(
    priority: 0,
    name: "create_table_migrations",
    execute: createTableOfMigrationsExecute,
    rollback: createTableOfMigrationsRollback,
);


final String isMigratedExecute = """
SELECT COUNT(*) as quantity FROM tbl_migrations WHERE priority = ? and name = ?;
""";
final String markAsMigratedExecute = """
INSERT INTO tbl_migrations (priority, name) VALUES (?, ?);
""";

class MigrationHandlerSqlite extends migration_port.MigratorHandler {
  MigrationHandlerSqlite({super.migrations, required super.uow});

  @override
  Future<void> makeMigration(migration_port.Migrator migration) async {
    await uow.session((session) async {
      await session.execute(migration.execute);
      await session.commit();
    });
  }

  @override
  Future<void> makeRollback(migration_port.Migrator migration) async {
    await uow.session((session) async {
      await session.execute(migration.rollback);
      await session.commit();
    });
  }

  @override
  Future<bool> isMigrated(migration_port.Migrator migration) async {
    List<int> context = await uow.atomicGet<int>(
        isMigratedExecute,
        (Map<String, dynamic> row) => row["quantity"] ?? 0,
        [migration.priority.toString(), migration.name],
    );
    return context.first == 1;
  }

  @override
  Future<void> markAsMigrated(migration_port.Migrator migration) async {
    await uow.session((session) async {
      await session.execute(
          markAsMigratedExecute,
          [migration.priority.toString(), migration.name]
      );
      await session.commit();
    });
  }
}


MigrationHandlerSqlite build(abstract_uow.AbstractUOW uow) {
  return MigrationHandlerSqlite(
      migrations: [
        createTableOfMigrations,
        custom_migrations.createTableOfProfile,
        custom_migrations.createTableOfAccess,
        custom_migrations.createTableOfSync,
        custom_migrations.createTableOfBoard,
        custom_migrations.createTableOfTask,
      ],
      uow: uow
  );
}