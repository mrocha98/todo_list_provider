import 'package:sqflite/sqlite_api.dart';
import 'package:todo_list_provider/app/core/database/migrations/migration.dart';

class MigrationV2 implements Migration {
  String get _query => '''
    ALTER TABLE todo
    ADD COLUMN user_id TEXT NULL
  ''';

  @override
  void create(Batch batch) {
    batch.execute(_query);
  }

  @override
  void update(Batch batch) {
    batch.execute(_query);
  }
}
