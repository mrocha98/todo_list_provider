import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/notifiers/notifiers.dart';
import 'package:todo_list_provider/app/core/ui/custom_icons.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/modules/home/home_controller.dart';
import 'package:todo_list_provider/app/modules/home/widgets/widgets.dart';
import 'package:todo_list_provider/app/modules/tasks/task_create_page.dart';
import 'package:todo_list_provider/app/modules/tasks/tasks_module.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final controller = context.read<HomeController>();
    DefaultListenerNotifier(notifier: controller).listen(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller
        ..findTasks(filter: controller.filterSelected)
        ..loadTotalTasks();
    });
  }

  Future<void> _gotoTaskCreate(BuildContext context) async {
    final controller = context.read<HomeController>();

    await Navigator.of(context).push(
      PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TasksModule().getPage(
          context,
          routeName: TaskCreatePage.routeName,
        ),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInQuad,
          );
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.bottomRight,
            child: child,
          );
        },
      ),
    );

    await controller.refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.primaryColor),
        elevation: 0,
        backgroundColor: const Color(0xfffafbfe),
        actions: [
          PopupMenuButton(
            icon: const Icon(CustomIcons.filter),
            itemBuilder: (context) => [
              PopupMenuItem<bool>(
                value: context.read<HomeController>().showFinishedTasks,
                child: context.read<HomeController>().showFinishedTasks
                    ? const Text('Ocultrar tarefas concluídas')
                    : const Text('Mostrar tarefas concluídas'),
              ),
            ],
            onSelected: (_) =>
                context.read<HomeController>().showOrHideFinishedTasks(),
          ),
        ],
      ),
      backgroundColor: const Color(0xfffafbfe),
      drawer: const HomeDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _gotoTaskCreate(context),
        backgroundColor: context.primaryColor,
        child: const Icon(Icons.add),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    HomeHeader(),
                    HomeFilters(),
                    HomeWeekFilter(),
                    HomeTasks(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
