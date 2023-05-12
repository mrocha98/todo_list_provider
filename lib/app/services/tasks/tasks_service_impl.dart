import 'package:clock/clock.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list_provider/app/models/models.dart';
import 'package:todo_list_provider/app/repositories/tasks/tasks.dart';
import 'package:todo_list_provider/app/services/tasks/tasks_service.dart';

class TasksServiceImpl implements TasksService {
  TasksServiceImpl(this._tasksRepository, this._firebaseAuth);

  final TasksRepository _tasksRepository;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<void> save(DateTime dateTime, String description) {
    final userId = _firebaseAuth.currentUser?.uid;
    return _tasksRepository.save(dateTime, description, userId: userId);
  }

  @override
  Future<List<TaskModel>> getTasksForToday() {
    final userId = _firebaseAuth.currentUser?.uid;
    return _tasksRepository.findByPeriod(
      clock.now(),
      clock.now(),
      userId: userId,
    );
  }

  @override
  Future<List<TaskModel>> getTasksForTomorrow() {
    final tomorrowDate = clock.now().add(const Duration(days: 1));
    final userId = _firebaseAuth.currentUser?.uid;
    return _tasksRepository.findByPeriod(
      tomorrowDate,
      tomorrowDate,
      userId: userId,
    );
  }

  @override
  Future<WeekTasksModel> getTasksForWeek() async {
    final userId = _firebaseAuth.currentUser?.uid;
    final today = clock.now();
    var startFilter =
        today.copyWith(hour: 0, minute: 0, millisecond: 0, microsecond: 0);
    if (startFilter.weekday != DateTime.monday) {
      startFilter = startFilter.subtract(
        Duration(days: startFilter.weekday - 1),
      );
    }
    final endFilter = startFilter.add(const Duration(days: 7));

    final tasks = await _tasksRepository.findByPeriod(
      startFilter,
      endFilter,
      userId: userId,
    );
    return WeekTasksModel(
      startDate: startFilter,
      endDate: endFilter,
      tasks: tasks,
    );
  }

  @override
  Future<void> checkOrUncheckTask(TaskModel task) =>
      _tasksRepository.checkOrUncheckTask(task);

  @override
  Future<void> delete(TaskModel task) => _tasksRepository.delete(task.id);
}
