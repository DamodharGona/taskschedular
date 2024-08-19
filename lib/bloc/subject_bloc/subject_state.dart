part of 'subject_bloc.dart';

@immutable
sealed class SubjectState {}

final class SubjectInitial extends SubjectState {}

final class SubjectDataLoadingState extends SubjectState {}

final class SubjectDataUploadingState extends SubjectState {}

final class SubjectDataUploadedState extends SubjectState {}

final class IndividualSubjectDataFetched extends SubjectState {
  final SubjectModel subject;

  IndividualSubjectDataFetched({required this.subject});
}

final class SubjectDataFetchedState extends SubjectState {
  final List<SubjectOfDay> selectedDayData;

  SubjectDataFetchedState({required this.selectedDayData});
}

final class SubjectFailure extends SubjectState {
  final String message;

  SubjectFailure({required this.message});
}
