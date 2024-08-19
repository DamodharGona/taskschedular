part of 'subject_bloc.dart';

@immutable
sealed class SubjectEvent {}

final class CreateSubjectEvent extends SubjectEvent {
  final SubjectModel subject;

  CreateSubjectEvent({required this.subject});
}

final class FetchSubjectsBasedOnDayEvent extends SubjectEvent {
  final String dayOfWeek;

  FetchSubjectsBasedOnDayEvent({required this.dayOfWeek});
}

final class FetchSubjectDataEvent extends SubjectEvent {
  final String subjectId;

  FetchSubjectDataEvent({required this.subjectId});
}

final class ModifyOrEditSubjectDataEvent extends SubjectEvent {
  final List<TimingModelClass> selectedTimings;
  final String day;

  ModifyOrEditSubjectDataEvent({
    required this.day,
    required this.selectedTimings,
  });
}
