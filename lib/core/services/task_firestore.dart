import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskschedular/models/task_model.dart';


class TaskFirestore {
  // create task
  Future<String?> createTask(TaskModel task) async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('task')
          .add(task.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Error creating task : $e');
    }
  }

  // update  the task
  Future<void> updateTask(String? docID, TaskModel task) async {
    if (task.docID != null) {
      await FirebaseFirestore.instance
          .collection('task')
          .doc(task.docID)
          .update(task.toJson());
    }
  }

  // deleting the task
  Future<void> deleteTask(String docId) async {
    await FirebaseFirestore.instance.collection('task').doc(docId).delete();
  }

  // fectching all the docs
  Future<List<TaskModel>> fetchAllTasks() async {
    try {
      final taskList =
          await FirebaseFirestore.instance.collection('task').get();
      return taskList.docs.map((doc) {
        final data = doc.data();
        return TaskModel.fromJson(data, id: doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching the tasks : $e');
    }
  }
}
