import 'package:todo_list_provider/app/core/notifiers/notifiers.dart';
import 'package:todo_list_provider/app/exceptions/exceptions.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';

class RegisterController extends DefaultChangeNotifier {
  RegisterController(this._userService);

  final UserService _userService;

  Future<void> registerUser(String email, String password) async {
    showLoadingAndResetState();
    notifyListeners();
    try {
      final user = await _userService.register(email, password);
      if (user != null) {
        success();
      } else {
        error = 'Erro ao registrar usuário';
      }
    } on AuthException catch (e) {
      error = e.message;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
