import 'package:flutter/foundation.dart';

import 'package:todo_list_provider/app/models/task_model.dart';

@immutable
class WeekTasksModel {
  const WeekTasksModel({
    required this.startDate,
    required this.endDate,
    required this.tasks,
  });

  final DateTime startDate;

  final DateTime endDate;

  final List<TaskModel> tasks;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeekTasksModel &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        listEquals(other.tasks, tasks);
  }

  @override
  int get hashCode => startDate.hashCode ^ endDate.hashCode ^ tasks.hashCode;

  @override
  String toString() =>
      'WeekTasksModel(startDate: $startDate, endDate: $endDate, tasks: $tasks)';

  WeekTasksModel copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<TaskModel>? tasks,
  }) {
    return WeekTasksModel(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      tasks: tasks ?? this.tasks,
    );
  }
}
