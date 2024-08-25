part of 'task_cubit.dart';

abstract class TaskState {}

class TaskIntial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskSucess extends TaskState {
  final String? docID;
  TaskSucess({
    this.docID,
  });
}

class TaskLoaded extends TaskState {
  List<TaskModel> tasks;
  TaskLoaded({
    required this.tasks,
  });
}

class TaskError extends TaskState {
  final String error;
  TaskError({
    required this.error,
  });
}
