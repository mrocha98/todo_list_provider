import 'package:todo_list_provider/app/core/database/sqlite_connection_factory.dart';
import 'package:todo_list_provider/app/repositories/tasks/tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  TasksRepositoryImpl(this._sqliteConnectionFactory);

  final SqliteConnectionFactory _sqliteConnectionFactory;

  @override
  Future<void> save(DateTime dateTime, String description) async {
    final conn = await _sqliteConnectionFactory.openConnection();
    await conn.insert('todo', {
      'id': null,
      'descricao': description,
      'data_hora': dateTime.toIso8601String(),
      'finalizado': 0,
    });
  }
}
