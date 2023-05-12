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

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    final controller = context.read<HomeController>();
    var confirmedDeletion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deseja realmente deletar essa task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'CANCELAR',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('CONFIRMAR'),
          ),
        ],
      ),
    );
    confirmedDeletion ??= false;

    if (confirmedDeletion) {
      await controller.delete(task);
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Dismissible(
        key: Key(task.id.toString()),
        confirmDismiss: (_) => _showDeleteConfirmation(context),
        direction: DismissDirection.endToStart,
        dismissThresholds: const {DismissDirection.endToStart: 0.1},
        background: Container(
          color: Colors.red,
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(right: 12),
          child: const Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        child: Container(
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
        ),
      ),
    );
  }
}
