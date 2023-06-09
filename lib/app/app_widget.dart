import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_list_provider/app/core/database/sqlite_connection_observer.dart';
import 'package:todo_list_provider/app/core/navigator/custom_navigator.dart';
import 'package:todo_list_provider/app/core/ui/ui_config.dart';
import 'package:todo_list_provider/app/modules/auth/auth_module.dart';
import 'package:todo_list_provider/app/modules/home/home_module.dart';
import 'package:todo_list_provider/app/modules/splash/splash_page.dart';
import 'package:todo_list_provider/app/modules/tasks/tasks_module.dart';

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      navigatorKey: CustomNavigator.navigatorKey,
      routes: {
        ...AuthModule().routes,
        ...HomeModule().routes,
        ...TasksModule().routes,
      },
      home: const SplashPage(),
    );
  }
}
