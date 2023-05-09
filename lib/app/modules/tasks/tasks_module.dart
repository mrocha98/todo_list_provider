import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/modules/module.dart';
import 'package:todo_list_provider/app/modules/tasks/task_create_controller.dart';
import 'package:todo_list_provider/app/modules/tasks/task_create_page.dart';

class TasksModule extends Module {
  TasksModule()
      : super(
          routes: {
            TaskCreatePage.routeName: (context) => TaskCreatePage(
                  controller: context.read(),
                ),
          },
          bindings: [
            ChangeNotifierProvider(
              create: (context) => TaskCreateController(),
            ),
          ],
        );
}
