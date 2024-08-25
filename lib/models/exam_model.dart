import 'package:cloud_firestore/cloud_firestore.dart';

class ExamModel {
  final String? docID;
  final String title;
  final DateTime? date;
  final String startTime;
  final String endTime;

  const ExamModel({
    this.docID,
    required this.title,
    this.date,
    required this.startTime,
    required this.endTime,
  });

  ExamModel copyWith({
    String? docID,
    String? title,
    DateTime? date,
    String? startTime,
    String? endTime,
  }) {
    return ExamModel(
      docID: docID ?? this.docID,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'docID': docID,
      'title': title,
      'date': Timestamp.fromDate(date!), // Convert DateTime to Timestamp
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory ExamModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return ExamModel(
      docID: id,
      title: json['title'] ?? '',
      date: json['date'] != null
          ? (json['date'] as Timestamp).toDate()
          : DateTime.now(), // Or handle it as per your requirement
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }
}
