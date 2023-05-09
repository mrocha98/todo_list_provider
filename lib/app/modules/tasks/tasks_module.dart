import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/database/sqlite_connection_factory.dart';
import 'package:todo_list_provider/app/core/modules/module.dart';
import 'package:todo_list_provider/app/modules/tasks/task_create_controller.dart';
import 'package:todo_list_provider/app/modules/tasks/task_create_page.dart';
import 'package:todo_list_provider/app/repositories/tasks/tasks.dart';
import 'package:todo_list_provider/app/services/tasks/tasks.dart';

class TasksModule extends Module {
  TasksModule()
      : super(
          routes: {
            TaskCreatePage.routeName: (context) => const TaskCreatePage(),
          },
          bindings: [
            Provider<TasksRepository>(
              create: (context) => TasksRepositoryImpl(
                context.read<SqliteConnectionFactory>(),
              ),
            ),
            Provider<TasksService>(
              create: (context) => TasksServiceImpl(
                context.read<TasksRepository>(),
              ),
            ),
            ChangeNotifierProvider(
              create: (context) => TaskCreateController(
                context.read<TasksService>(),
              ),
            ),
          ],
        );
}
