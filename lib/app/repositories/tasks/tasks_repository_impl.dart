import 'package:todo_list_provider/app/core/database/sqlite_connection_factory.dart';
import 'package:todo_list_provider/app/models/models.dart';
import 'package:todo_list_provider/app/repositories/tasks/tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  TasksRepositoryImpl(this._sqliteConnectionFactory);

  final SqliteConnectionFactory _sqliteConnectionFactory;

  @override
  Future<void> save(
    DateTime dateTime,
    String description, {
    String? userId,
  }) async {
    final conn = await _sqliteConnectionFactory.openConnection();
    await conn.insert('todo', {
      'id': null,
      'descricao': description,
      'data_hora': dateTime.toIso8601String(),
      'finalizado': 0,
      'user_id': userId,
    });
  }

  @override
  Future<List<TaskModel>> findByPeriod(
    DateTime start,
    DateTime end, {
    String? userId,
  }) async {
    final startFilter = start.copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
    final endFilter = end.copyWith(
      hour: 23,
      minute: 59,
      second: 59,
      millisecond: 59,
      microsecond: 59,
    );

    final conn = await _sqliteConnectionFactory.openConnection();
    final result = await conn.rawQuery(
      '''
      SELECT *
      FROM todo
      WHERE
        user_id = ? AND
        data_hora BETWEEN ? AND ?
      ORDER BY data_hora
    ''',
      [userId, startFilter.toIso8601String(), endFilter.toIso8601String()],
    );

    return result.map(TaskModel.fromSqlite).toList();
  }

  @override
  Future<void> checkOrUncheckTask(TaskModel task) async {
    final conn = await _sqliteConnectionFactory.openConnection();
    final finished = task.finished ? 1 : 0;
    await conn.rawUpdate(
      '''
      UPDATE todo SET finalizado = ? WHERE id = ?
    ''',
      [finished, task.id],
    );
  }
}
