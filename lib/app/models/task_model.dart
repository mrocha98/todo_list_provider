import 'package:meta/meta.dart';

@immutable
class TaskModel {
  const TaskModel({
    required this.id,
    required this.description,
    required this.dateTime,
    required this.finished,
    this.userId,
  });

  factory TaskModel.fromSqlite(Map<String, dynamic> data) {
    return TaskModel(
      id: data['id'] as int,
      description: data['descricao'] as String,
      dateTime: DateTime.parse(data['data_hora'] as String),
      finished: data['finalizado'] as int > 0,
      userId: data['user_id'] as String?,
    );
  }

  final int id;

  final String description;

  final DateTime dateTime;

  final bool finished;

  final String? userId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskModel &&
        other.id == id &&
        other.description == description &&
        other.dateTime == dateTime &&
        other.finished == finished &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        dateTime.hashCode ^
        finished.hashCode ^
        userId.hashCode;
  }

  @override
  String toString() {
    return 'TaskModel('
        'id: $id, '
        'description: $description, '
        'dateTime: $dateTime, '
        'finished: $finished, '
        'userId: $userId'
        ')';
  }

  TaskModel copyWith({
    int? id,
    String? description,
    DateTime? dateTime,
    bool? finished,
    String? userId,
  }) {
    return TaskModel(
      id: id ?? this.id,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      finished: finished ?? this.finished,
      userId: userId,
    );
  }

  Map<String, dynamic> toSqlite() => {
        'id': id,
        'descricao': description,
        'data_hora': dateTime.toIso8601String(),
        'finalizado': finished ? 1 : 0,
        'user_id': userId,
      };
}
