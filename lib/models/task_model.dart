import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? docID;
  final String title;
  final String description;
  final DateTime? dueDate;
  final String dueTime;

  const TaskModel({
    this.docID,
    required this.title,
    required this.description,
    this.dueDate,
    required this.dueTime,
  });

  // Factory constructor for creating a TaskModel from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return TaskModel(
      docID: id,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      dueDate: json['dueDate'] != null
          ? (json['dueDate'] as Timestamp).toDate()
          : null,
      dueTime: json['dueTime'] as String? ?? '',
    );
  }

  // Method to convert the TaskModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'docID': docID,
      'title': title,
      'description': description,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'dueTime': dueTime,
    };
  }

  TaskModel copyWith({
    String? docID,
    String? title,
    String? description,
    DateTime? dueDate,
    String? dueTime,
  }) {
    return TaskModel(
      docID: docID ?? this.docID,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
    );
  }
}
