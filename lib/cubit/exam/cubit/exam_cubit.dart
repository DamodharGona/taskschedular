import 'package:bloc/bloc.dart';
import 'package:taskschedular/core/services/exam_firestore.dart';
import 'package:taskschedular/models/exam_model.dart';



part 'exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  final ExamFirestore examFirestore;
  ExamCubit(this.examFirestore) : super(ExamInitial());

  // create the exam
  Future<void> createExam(ExamModel exam)async{
    try{
       emit(ExamLoading());
       final docID = await examFirestore.createExam(exam);
       emit(ExamSuccess(docID:docID ));
    }catch(e){
      emit(ExamError(error: 'failed to create exam'));
    }
  }
  
  // update exams
  Future<void> updateExam(String docID,ExamModel exam)async{
    try{
      emit((ExamLoading()));
      await examFirestore.updateExam(docID,exam);
      emit(ExamSuccess());
    }catch(e){
      emit(ExamError(error: 'failed to update exam : $e'));
    }
  }
  
  // fetch all exams
  Future<void> fetchExams()async{
    try{
      emit(ExamLoading());
      final exams = await examFirestore.fetchAllExams();
      emit(ExamLoaded(exams: exams));
    }catch(e){
      emit(ExamError(error: 'failed to fetch exams : $e'));
    }
  }

  // delete exams
  Future<void> deleteExam(String docID)async{
    try{
      emit(ExamInitial());
      await examFirestore.deleteExam(docID);
      emit(ExamSuccess());
    }catch(e){
      emit(ExamError(error: 'failed to delete exam'));
    }
  }
}
