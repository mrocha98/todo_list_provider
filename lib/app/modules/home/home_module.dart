import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/modules/module.dart';
import 'package:todo_list_provider/app/modules/home/home_page.dart';

class HomeModule extends Module {
  HomeModule()
      : super(
          routes: {
            HomePage.routeName: (context) => const HomePage(),
          },
          bindings: [
            Provider(
              create: (_) => Object(),
            ),
          ],
        );
}
