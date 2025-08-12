import 'package:argos_home/domain/port/uow/migration.dart' as migration_port;


final String createTableOfProfileExecute = """
CREATE TABLE IF NOT EXISTS tbl_profile (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  username TEXT NOT NULL,
  email TEXT NOT NULL,
  image_url TEXT NULL,
  description TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
""";
final String createTableOfProfileRollback = """
DROP TABLE IF EXISTS tbl_profile;
""";
final createTableOfProfile = migration_port.Migrator(
  priority: 1,
  name: "create_table_profile",
  execute: createTableOfProfileExecute,
  rollback: createTableOfProfileRollback,
);


final String createTableOfAccessExecute = """
CREATE TABLE IF NOT EXISTS tbl_access (
  email TEXT PRIMARY KEY NOT NULL,
  access_token TEXT NOT NULL,
  refresh_token TEXT NOT NULL,
  type TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP NOT NULL
);
""";
final String createTableOfAccessRollback = """
DROP TABLE IF EXISTS tbl_access;
""";
final createTableOfAccess = migration_port.Migrator(
  priority: 2,
  name: "create_table_access",
  execute: createTableOfAccessExecute,
  rollback: createTableOfAccessRollback,
);

final String createTableOfSyncExecute = """
CREATE TABLE IF NOT EXISTS tbl_sync (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  table_name TEXT NOT NULL,
  record_id TEXT NOT NULL,
  last_sync TIMESTAMP NOT NULL
);
""";
final String createTableOfSyncRollback = """
DROP TABLE IF EXISTS tbl_sync;
""";
final createTableOfSync = migration_port.Migrator(
  priority: 3,
  name: "create_table_sync",
  execute: createTableOfSyncExecute,
  rollback: createTableOfSyncRollback,
);


final String createTableOfBoardExecute = """
CREATE TABLE IF NOT EXISTS tbl_board (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  icon_url TEXT NULL,
  background_color TEXT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
""";
final String createTableOfBoardRollback = """
DROP TABLE IF EXISTS tbl_board;
""";
final createTableOfBoard = migration_port.Migrator(
  priority: 4,
  name: "create_table_board",
  execute: createTableOfBoardExecute,
  rollback: createTableOfBoardRollback,
);