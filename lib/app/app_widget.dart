import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/database/sqlite_connection_observer.dart';
import 'package:todo_list_provider/app/core/ui/ui_config.dart';
import 'package:todo_list_provider/app/modules/auth/auth_module.dart';
import 'package:todo_list_provider/app/modules/splash/splash_page.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final _sqliteConnectionObserver = SqliteConnectionObserver();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_sqliteConnectionObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_sqliteConnectionObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List Provider',
      debugShowCheckedModeBanner: false,
      theme: UiConfig.theme,
      routes: {
        ...AuthModule().routes,
      },
      home: const SplashPage(),
    );
  }
}
