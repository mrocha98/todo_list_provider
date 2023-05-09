import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/modules/tasks/task_create_controller.dart';

class CalendarButton extends StatelessWidget {
  const CalendarButton({super.key});

  DateFormat get _dateformat => DateFormat('dd/MM/yyyy');

  Future<void> _handleTap(BuildContext context) async {
    final controller = context.read<TaskCreateController>();
    const tenYears = Duration(days: 365 * 10);
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(tenYears),
      lastDate: now.add(tenYears),
    );

    controller.selectedDate = selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _handleTap(context),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.today,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 10,
            ),
            Selector<TaskCreateController, String>(
              builder: (_, value, __) => Text(
                value,
                style: context.titleStyle,
              ),
              selector: (_, controller) => controller.selectedDate == null
                  ? 'SELECIONE UMA DATA'
                  : _dateformat.format(controller.selectedDate!),
            ),
          ],
        ),
      ),
    );
  }
}
