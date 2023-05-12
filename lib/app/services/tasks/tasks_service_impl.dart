import 'package:todo_list_provider/app/models/models.dart';
import 'package:todo_list_provider/app/repositories/tasks/tasks.dart';
import 'package:todo_list_provider/app/services/tasks/tasks_service.dart';

class TasksServiceImpl implements TasksService {
  TasksServiceImpl(this._tasksRepository);

  final TasksRepository _tasksRepository;

  @override
  Future<void> save(DateTime dateTime, String description) =>
      _tasksRepository.save(dateTime, description);

  @override
  Future<List<TaskModel>> getTasksForToday() => _tasksRepository.findByPeriod(
        DateTime.now(),
        DateTime.now(),
      );

  @override
  Future<List<TaskModel>> getTasksForTomorrow() {
    final tomorrowDate = DateTime.now().add(const Duration(days: 1));
    return _tasksRepository.findByPeriod(tomorrowDate, tomorrowDate);
  }

  @override
  Future<WeekTasksModel> getTasksForWeek() async {
    final today = DateTime.now();
    var startFilter =
        today.copyWith(hour: 0, minute: 0, millisecond: 0, microsecond: 0);
    if (startFilter.weekday != DateTime.monday) {
      startFilter = startFilter.subtract(
        Duration(days: startFilter.weekday - 1),
      );
    }
    final endFilter = startFilter.add(const Duration(days: 7));

    final tasks = await _tasksRepository.findByPeriod(startFilter, endFilter);
    return WeekTasksModel(
      startDate: startFilter,
      endDate: endFilter,
      tasks: tasks,
    );
  }

  @override
  Future<void> checkOrUncheckTask(TaskModel task) =>
      _tasksRepository.checkOrUncheckTask(task);
}
