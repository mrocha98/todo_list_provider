import 'package:meta/meta.dart';

@immutable
class TotalTasksModel {
  const TotalTasksModel({
    required this.totalTasks,
    required this.totalTasksFinished,
  });

  final int totalTasks;

  final int totalTasksFinished;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TotalTasksModel &&
        other.totalTasks == totalTasks &&
        other.totalTasksFinished == totalTasksFinished;
  }

  @override
  int get hashCode => totalTasks.hashCode ^ totalTasksFinished.hashCode;

  @override
  String toString() => 'TotalTasksModel('
      'totalTasks: $totalTasks, '
      'totalTasksFinished: $totalTasksFinished'
      ')';

  TotalTasksModel copyWith({
    int? totalTasks,
    int? totalTasksFinished,
  }) {
    return TotalTasksModel(
      totalTasks: totalTasks ?? this.totalTasks,
      totalTasksFinished: totalTasksFinished ?? this.totalTasksFinished,
    );
  }
}
