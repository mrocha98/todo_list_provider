import 'package:todo_list_provider/app/repositories/tasks/tasks.dart';
import 'package:todo_list_provider/app/services/tasks/tasks_service.dart';

class TasksServiceImpl implements TasksService {
  TasksServiceImpl(this._tasksRepository);

  final TasksRepository _tasksRepository;

  @override
  Future<void> save(DateTime dateTime, String description) =>
      _tasksRepository.save(dateTime, description);
}
