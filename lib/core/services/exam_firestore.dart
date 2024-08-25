import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskschedular/models/exam_model.dart';


class ExamFirestore {
  // Create exam
  Future<String?> createExam(ExamModel exam) async {
    try {
      final examRef = await FirebaseFirestore.instance
          .collection('exam')
          .add(exam.toJson());
      return examRef.id;
    } catch (e) {
      throw Exception('Error while creating exam: $e');
    }
  }

  // Update exam
  Future<void> updateExam(String docID, ExamModel exam) async {
    if (exam.docID != null) {
      await FirebaseFirestore.instance
          .collection('exam')
          .doc(exam.docID) // Use docID parameter here
          .update(exam.toJson());
    }
  }

  // Fetch all the exams
  Future<List<ExamModel>> fetchAllExams() async {
    try {
      final examsList =
          await FirebaseFirestore.instance.collection('exam').get();
      return examsList.docs.map((doc) {
        final data = doc.data();
        return ExamModel.fromJson(data, id: doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error while fetching exams: $e');
    }
  }

  // Delete exam
  Future<void> deleteExam(String docID) async {
    try {
      await FirebaseFirestore.instance.collection('exam').doc(docID).delete();
    } catch (e) {
      throw Exception('Error while deleting the exam: $e');
    }
  }
}
