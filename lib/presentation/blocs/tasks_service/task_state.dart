import 'package:equatable/equatable.dart';
import 'package:task_manager/domain/entities/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> allTasks;
  final List<Task> filteredTasks;
  final String searchQuery;

  const TaskLoaded({
    required this.allTasks,
    required this.filteredTasks,
    required this.searchQuery,
  });

  TaskLoaded copyWith({
    List<Task>? allTasks,
    List<Task>? filteredTasks,
    String? searchQuery,
  }) {
    return TaskLoaded(
      allTasks: allTasks ?? this.allTasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [allTasks, filteredTasks, searchQuery];
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}
