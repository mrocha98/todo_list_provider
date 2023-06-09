import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/modules/module.dart';
import 'package:todo_list_provider/app/modules/auth/login/login_controller.dart';
import 'package:todo_list_provider/app/modules/auth/login/login_page.dart';
import 'package:todo_list_provider/app/modules/auth/register/register_controller.dart';
import 'package:todo_list_provider/app/modules/auth/register/register_page.dart';

class AuthModule extends Module {
  AuthModule()
      : super(
          routes: {
            LoginPage.routeName: (context) => const LoginPage(),
            RegisterPage.routeName: (context) => const RegisterPage(),
          },
          bindings: [
            ChangeNotifierProvider(
              create: (context) => LoginController(
                context.read(),
              ),
            ),
            ChangeNotifierProvider(
              create: (context) => RegisterController(
                context.read(),
              ),
            ),
          ],
        );
}
