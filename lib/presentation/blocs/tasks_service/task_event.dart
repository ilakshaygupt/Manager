import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final String title;
  const AddTask(this.title);

  @override
  List<Object> get props => [title];
}

class ToggleTaskCompletion extends TaskEvent {
  final String id;
  final bool value;

  const ToggleTaskCompletion(this.id, this.value);

  @override
  List<Object> get props => [id, value];
}

class DeleteTask extends TaskEvent {
  final String id;

  const DeleteTask(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateSearchQuery extends TaskEvent {
  final String query;

  const UpdateSearchQuery(this.query);

  @override
  List<Object> get props => [query];
}
