import 'package:todo_list_provider/app/models/models.dart';

abstract class TasksService {
  Future<void> save(DateTime dateTime, String description);
  Future<List<TaskModel>> getTasksForToday();
  Future<List<TaskModel>> getTasksForTomorrow();
  Future<WeekTasksModel> getTasksForWeek();
  Future<void> checkOrUncheckTask(TaskModel task);
}
