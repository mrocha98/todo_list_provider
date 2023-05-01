import 'package:todo_list_provider/app/core/database/migrations/migrations.dart';

class SqliteMigrationFactory {
  factory SqliteMigrationFactory() =>
      _instance ??= SqliteMigrationFactory._internal();

  SqliteMigrationFactory._internal();

  static SqliteMigrationFactory? _instance;

  List<Migration> getCreateMigrations() => [MigrationV1()];

  List<Migration> getUpgradeMigrations(int oldVersion) =>
      getCreateMigrations().sublist(oldVersion);
}
