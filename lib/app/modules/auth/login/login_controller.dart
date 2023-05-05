import 'package:todo_list_provider/app/core/notifiers/notifiers.dart';
import 'package:todo_list_provider/app/exceptions/exceptions.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';

class LoginController extends DefaultChangeNotifier {
  LoginController(this._userService);

  final UserService _userService;

  Future<void> login(String email, String password) async {
    showLoadingAndResetState();
    notifyListeners();
    try {
      final user = await _userService.login(email, password);
      if (user != null) {
        success();
      } else {
        error = 'Usuário ou senha inválidos';
      }
    } on AuthException catch (e) {
      error = e.message;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
