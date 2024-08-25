part of 'exam_cubit.dart';

abstract class ExamState {}

class ExamInitial extends ExamState{}

class ExamLoading extends ExamState{}

class ExamSuccess extends ExamState{
  final String? docID;
  ExamSuccess({this.docID});
}

class ExamLoaded extends ExamState{
  List<ExamModel> exams;
  ExamLoaded({required this.exams});
}

class ExamError extends ExamState{
  final String error;
  ExamError({required this.error});
}
