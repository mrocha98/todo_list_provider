import 'package:todo_list_provider/app/models/models.dart';

abstract class TasksRepository {
  Future<void> save(
    DateTime dateTime,
    String description, {
    String? userId,
  });
  Future<List<TaskModel>> findByPeriod(
    DateTime start,
    DateTime end, {
    String? userId,
  });
  Future<void> checkOrUncheckTask(TaskModel task);
}
