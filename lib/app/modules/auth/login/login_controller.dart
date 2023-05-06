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

  Future<void> forgotPassword(String email) async {
    showLoadingAndResetState();
    notifyListeners();

    try {
      await _userService.forgotPassword(email);
      info = 'Confira seu email para redefinir sua senha';
    } on AuthException catch (e) {
      error = e.message;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> googleLogin() async {
    showLoadingAndResetState();
    notifyListeners();

    try {
      final user = await _userService.googleLogin();
      if (user != null) {
        success();
      } else {
        await _userService.logout();
        error = 'Erro ao realizar login com Google';
      }
    } on AuthException catch (e) {
      await _userService.logout();
      error = e.message;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
