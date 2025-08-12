
import 'dart:collection';

import 'package:argos_home/domain/port/uow/commons.dart';

class Migrator {
  int priority;
  String name;

  String execute;
  String rollback;

  Migrator({
    required this.priority,
    required this.name,
    required this.execute,
    required this.rollback
  });
}


class MigratorHandler {
  final List<Migrator> _migrations;
  final AbstractUOW uow;

  UnmodifiableListView<Migrator> get migrations => UnmodifiableListView(_migrations);

  MigratorHandler({List<Migrator>? migrations, required this.uow}) : _migrations = migrations ?? [];

  Future<void> migrate() async {
    print("- Migrating -");
    if (migrations.isEmpty) {
      print("No migrations found");
      return;
    }
    migrations.forEach((Migrator migrator) => print("migration ${migrator.name}"));
    for (Migrator migration in migrations) {
      print("Executing migration ${migration.name}");
      if (migration.priority > 0 && await isMigrated(migration)) {
        print("Migration ${migration.name} already executed");
      } else {
        try {
          await makeMigration(migration);
          if (migration.priority > 0) {
            await markAsMigrated(migration);
          }
          print("Migration ${migration.name} executed successfully");
        } catch (e) {
          print("Error executing migration ${migration.name}");
          print(e);
          print("Rolling back migration ${migration.name}");
          await makeRollback(migration);
          break;
        }
      }
    }
  }

  Future<void> makeMigration(Migrator migration) {
    throw UnimplementedError();
  }

  Future<void> makeRollback(Migrator migration) {
    throw UnimplementedError();
  }

  Future<bool> isMigrated(Migrator migration) {
    throw UnimplementedError();
  }

  Future<void> markAsMigrated(Migrator migration) {
    throw UnimplementedError();
  }
}