import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/database/sqlite_connection_factory.dart';
import 'package:todo_list_provider/app/core/modules/module.dart';
import 'package:todo_list_provider/app/modules/home/home_controller.dart';
import 'package:todo_list_provider/app/modules/home/home_page.dart';
import 'package:todo_list_provider/app/repositories/tasks/tasks.dart';
import 'package:todo_list_provider/app/services/tasks/tasks.dart';

class HomeModule extends Module {
  HomeModule()
      : super(
          routes: {
            HomePage.routeName: (context) => const HomePage(),
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
                context.read<FirebaseAuth>(),
              ),
            ),
            ChangeNotifierProvider(
              create: (context) => HomeController(
                context.read<TasksService>(),
              ),
            ),
          ],
        );
}
