import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/modules/module.dart';
import 'package:todo_list_provider/app/modules/auth/login/login_controller.dart';
import 'package:todo_list_provider/app/modules/auth/login/login_page.dart';

class AuthModule extends Module {
  AuthModule()
      : super(
          routes: {
            LoginPage.routeName: (context) => const LoginPage(),
          },
          bindings: [
            ChangeNotifierProvider(
              create: (_) => LoginController(),
            ),
          ],
        );
}
