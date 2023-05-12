import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/models/models.dart';
import 'package:todo_list_provider/app/modules/home/home_controller.dart';

class TodoCardFilter extends StatelessWidget {
  const TodoCardFilter({
    required this.label,
    required this.taskFilter,
    required this.selected,
    this.totalTasksModel,
    super.key,
  });

  final String label;

  final TaskFilterEnum taskFilter;

  final bool selected;

  final TotalTasksModel? totalTasksModel;

  double get _percentFinished {
    final total = totalTasksModel?.totalTasks ?? 0;
    if (total == 0) return 0;
    final totalFinished = totalTasksModel?.totalTasksFinished ?? 0;
    final percent = (totalFinished * 100) / total;
    return percent / 100;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<HomeController>().findTasks(filter: taskFilter),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 120,
          maxWidth: 150,
        ),
        decoration: BoxDecoration(
          color: selected ? context.primaryColor : Colors.white,
          border: Border.all(
            color: Colors.grey.withOpacity(.8),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              totalTasksModel != null && totalTasksModel!.totalTasks > 0
                  ? '${totalTasksModel!.totalTasks} TASKS'
                  : 'NENHUMA TASK',
              style: context.titleStyle.copyWith(
                fontSize: 10,
                color: selected ? Colors.white : Colors.grey,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _percentFinished),
              duration: const Duration(seconds: 1),
              builder: (context, value, child) => LinearProgressIndicator(
                value: value,
                backgroundColor:
                    selected ? context.primaryColorLight : Colors.grey.shade300,
                valueColor: selected
                    ? const AlwaysStoppedAnimation<Color>(Colors.white)
                    : AlwaysStoppedAnimation(context.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
