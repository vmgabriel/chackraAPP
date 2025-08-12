import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

// Ports
import 'package:argos_home/domain/port/uow/commons.dart' as commons_port;

// Configurations
import 'package:argos_home/infra/uow/configuration.dart' as configuration_uow;


class SessionSqlite extends commons_port.Session {
  Batch batch;

  SessionSqlite({required this.batch});

  @override
  Future<void> commit() async {
    await batch.commit();
  }

  @override
  Future<void> rollback() async {
    // no required
  }

  @override
  Future<void> flush() async {
    // no required
  }

  @override
  Future<void> execute(String script, [List<String>? args]) async {
    if (args != null) {
      batch.execute(script, args);
      return;
    }
    batch.execute(script);
  }
}


class UOW extends commons_port.AbstractUOW {
  String databaseFile = configuration_uow.DATABASE_FILE;
  late Database db;
  late String databasePath;

  UOW();

  @override
  Future<void> session(
      Future<void> Function(SessionSqlite session) callback
  ) async {
    try {
      await open();
      await callback(SessionSqlite(batch: db.batch()));
    } catch(e) {
      print("Error in Session Execution: $e");
    } finally {
      await close();
    };
  }

  @override
  Future<List<T>> atomicGet<T>(
      String query,
      T Function(Map<String, dynamic> row) serialize,
      [List<String>? args]
  ) async {
    List<T> futures = [];
    try {
      await open();
      List<Map<String, dynamic>> rows;
      if (args == null) {
        rows = await db.rawQuery(query);
      } else {
        rows = await db.rawQuery(query, args);
      }
      for (Map<String, dynamic> row in rows) {
        futures.add(serialize(row));
      }
    } catch(e) {
      print("Error in Atomic Get Execution: $e");
    } finally {
      await close();
    }
    return futures;
  }

  @override
  Future<void> open() async {
    var databasePath = await databaseFactory.getDatabasesPath();
    if (!await Directory(databasePath).exists()) {
      await Directory(databasePath).create(recursive: true);
    }
    String path = join(databasePath, databaseFile);
    db = await databaseFactory.openDatabase(path);
  }

  @override
  Future<void> close() async {
    await db.close();
  }

  @override
  void destroy() async {
    var databasePath = await databaseFactory.getDatabasesPath();
    String path = join(databasePath, databaseFile);
    await deleteDatabase(path);
  }
}