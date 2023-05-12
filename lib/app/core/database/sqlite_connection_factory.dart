import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:todo_list_provider/app/core/database/sqlite_migration_factory.dart';

class SqliteConnectionFactory {
  factory SqliteConnectionFactory() =>
      _instance ??= SqliteConnectionFactory._internal();

  SqliteConnectionFactory._internal();

  static SqliteConnectionFactory? _instance;

  static const int _version = 2;

  static const String _databaseName = 'TODO_LIST_PROVIDER';

  Database? _db;

  final _lock = Lock();

  void closeConnection() {
    _db?.close();
    _db = null;
  }

  Future<Database> openConnection() async {
    if (_db != null) return _db!;

    final systemDatabasesPath = await getDatabasesPath();
    final databasePath = path.join(systemDatabasesPath, _databaseName);
    await _lock.synchronized(() async {
      if (_db != null) return;
      _db = await _openDatabase(databasePath);
    });

    return _db!;
  }

  Future<Database> _openDatabase(String databasePath) async => openDatabase(
        databasePath,
        version: _version,
        onConfigure: _onConfigure,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onDowngrade: _onDowngrade,
      );

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    final migrations = SqliteMigrationFactory().getCreateMigrations();
    for (final migration in migrations) {
      migration.create(batch);
    }

    await batch.commit();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();

    final migrations = SqliteMigrationFactory().getUpgradeMigrations(
      oldVersion,
    );
    for (final migration in migrations) {
      migration.update(batch);
    }

    await batch.commit();
  }

  Future<void> _onDowngrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {}
}
