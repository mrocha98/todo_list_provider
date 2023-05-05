import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list_provider/app/repositories/user/user_repository.dart';

import 'package:todo_list_provider/app/services/user/user_service.dart';

class UserServiceImpl implements UserService {
  UserServiceImpl(this._userRepository);
  final UserRepository _userRepository;

  @override
  Future<User?> register(String email, String password) =>
      _userRepository.register(email, password);
}
