import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/models/models.dart';
import 'package:todo_list_provider/app/modules/home/home_controller.dart';

class Task extends StatelessWidget {
  const Task({
    required this.task,
    super.key,
  });

  final TaskModel task;

  DateFormat get _dateFormat => DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.grey),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: IntrinsicHeight(
        child: ListTile(
          leading: Checkbox(
            value: task.finished,
            onChanged: (_) =>
                context.read<HomeController>().checkOrUncheckTask(task),
            activeColor: context.primaryColor,
          ),
          title: Text(
            task.description,
            style: task.finished
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
          subtitle: Text(
            _dateFormat.format(task.dateTime),
            style: task.finished
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
          contentPadding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(),
          ),
        ),
      ),
    );
  }
}
