import 'package:meta/meta.dart';

@immutable
class TaskModel {
  const TaskModel({
    required this.id,
    required this.description,
    required this.dateTime,
    required this.finished,
  });

  factory TaskModel.fromSqlite(Map<String, dynamic> data) {
    return TaskModel(
      id: data['id'] as int,
      description: data['descricao'] as String,
      dateTime: DateTime.parse(data['data_hora'] as String),
      finished: data['finalizado'] as int > 0,
    );
  }

  final int id;

  final String description;

  final DateTime dateTime;

  final bool finished;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskModel &&
        other.id == id &&
        other.description == description &&
        other.dateTime == dateTime &&
        other.finished == finished;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        dateTime.hashCode ^
        finished.hashCode;
  }

  @override
  String toString() {
    return 'TaskModel('
        'id: $id, '
        'description: $description, '
        'dateTime: $dateTime, '
        'finished: $finished'
        ')';
  }

  TaskModel copyWith({
    int? id,
    String? description,
    DateTime? dateTime,
    bool? finished,
  }) {
    return TaskModel(
      id: id ?? this.id,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      finished: finished ?? this.finished,
    );
  }

  Map<String, dynamic> toSqlite() => {
        'id': id,
        'descricao': description,
        'data_hora': dateTime.toIso8601String(),
        'finalizado': finished ? 1 : 0,
      };
}
