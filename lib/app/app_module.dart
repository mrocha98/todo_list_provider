import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/app_widget.dart';
import 'package:todo_list_provider/app/core/auth/auth_provider.dart';
import 'package:todo_list_provider/app/core/database/sqlite_connection_factory.dart';
import 'package:todo_list_provider/app/repositories/user/user_repository.dart';
import 'package:todo_list_provider/app/repositories/user/user_repository_impl.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';
import 'package:todo_list_provider/app/services/user/user_service_impl.dart';

class AppModule extends StatelessWidget {
  const AppModule({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => FirebaseAuth.instance),
        Provider(
          create: (context) => SqliteConnectionFactory(),
          lazy: false,
        ),
        Provider<UserRepository>(
          create: (context) => UserRepositoryImpl(
            context.read<FirebaseAuth>(),
          ),
        ),
        Provider<UserService>(
          create: (context) => UserServiceImpl(
            context.read<UserRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            context.read<FirebaseAuth>(),
            context.read<UserService>(),
          )..loadListeners(),
          lazy: false,
        ),
      ],
      child: const AppWidget(),
    );
  }
}
