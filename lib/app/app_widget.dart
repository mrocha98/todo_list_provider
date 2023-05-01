import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/database/sqlite_connection_observer.dart';
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
    return const MaterialApp(
      title: 'Todo List Provider',
      home: SplashPage(),
    );
  }
}