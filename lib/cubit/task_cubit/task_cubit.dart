import 'package:bloc/bloc.dart';
import 'package:taskschedular/core/services/task_firestore.dart';
import 'package:taskschedular/models/task_model.dart';


part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskFirestore taskFirestore;
  TaskCubit(this.taskFirestore) : super(TaskIntial());

  // creating task
  Future<void> createTask(TaskModel task) async {
    try {
      emit(TaskLoading());
      final docID = await taskFirestore.createTask(task);
      emit(TaskSucess(docID: docID));
    } catch (e) {
      emit(TaskError(error: 'failed to create task : $e'));
    }
  }

  // updating task
  Future<void> updateTask(String docID, TaskModel task) async {
    try {
      emit(TaskLoading());
      await taskFirestore.updateTask(docID, task);
      emit(TaskSucess());
    } catch (e) {
      emit(TaskError(error: 'failed to update the task : $e'));
    }
  }

  // fetching the tasks
  Future<void> fetchTasks() async {
    try {
      emit(TaskLoading());
      final tasks = await taskFirestore.fetchAllTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(error: 'failed to fetch the tasks : $e'));
    }
  }

  // deleting the tasks
  Future<void> deleteTasks(String docID) async {
    try {
      emit(TaskLoading());
      await taskFirestore.deleteTask(docID);
      emit(TaskSucess());
    } catch (e) {
      emit(TaskError(error: 'failed to delete the task : $e'));
    }
  }
}
