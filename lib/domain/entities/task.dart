import 'package:uuid/uuid.dart';

class Task {
  String id;
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false}) : id = Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isCompleted: json['isCompleted'],
    )..id = json['id'];
  }
}
