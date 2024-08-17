import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskschedular/core/constants/firebase_constants.dart';
import 'package:taskschedular/core/services/firestore_service.dart';
import 'package:taskschedular/models/day_model_class.dart';
import 'package:taskschedular/models/timing_model_class.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  SubjectBloc() : super(SubjectInitial()) {
    on<SubjectEvent>((event, emit) => emit(SubjectDataLoadingState()));

    on<CreateSubjectEvent>(_createSubject);

    on<FetchSubjectsBasedOnDayEvent>(_fetchSubjectBasedOnDay);

    on<FetchSubjectDataEvent>(_fetchSubjectData);
  }

  Future<void> _fetchSubjectData(
    FetchSubjectDataEvent event,
    Emitter<SubjectState> emit,
  ) async {
    /* Fetch all documents data in collection */

    try {
      emit(SubjectDataLoadingState());

      final docsData = await FirestoreService.instance
          .getAllDocuments<List<TimingModelClass>, TimingModelClass>(
        collection: FirebaseConstants.timeTableCollection,
        tFromJson: TimingModelClass.fromJson,
        dataKey: 'selectedTimings',
        isList: true,
      );

      final finalData = docsData.data
          .where((docs) => docs.subjectId == event.subjectId)
          .map((item) => item);

      final apiData = await FirestoreService.instance
          .getDocumentBasedOnId<Subject, Subject>(
        collection: FirebaseConstants.subjectsCollection,
        documentId: event.subjectId,
        tFromJson: Subject.fromJson,
        isList: false,
      );

      List<DayModelClass> days = [];
      List<TimingModelClass> timings = [];

      // Populate the days and timings lists
      for (final data in finalData) {
        days.add(DayModelClass(day: data.id));
        timings.add(
            data.copyWith(subjectName: apiData.data.name, isChecked: true));
      }

      // Map timings to days based on matching IDs
      days = days.map((day) {
        final selectedTimings =
            timings.where((timing) => timing.id == day.day).toList();
        return day.copyWith(selectedTimings: selectedTimings, isChecked: true);
      }).toList();

      emit(
        IndividualSubjectDataFetched(
          subject: Subject(
            id: apiData.data.id,
            name: apiData.data.name,
            days: days,
          ),
        ),
      );
    } catch (e, stack) {
      if (kDebugMode) {
        print("error: $e");
        print("stack: $stack");
      }
      emit(SubjectFailure(message: e.toString()));
    }
  }

  Future<void> _fetchSubjectBasedOnDay(
    FetchSubjectsBasedOnDayEvent event,
    Emitter<SubjectState> emit,
  ) async {
    try {
      /* fetch doc based on dayofweek */
      final dayOfWeekData = await _getExistingDocumentData(event.dayOfWeek);

      List<TimingModelClass> timings = [];

      /* fetch subjects data & get name based on id */

      for (var time in dayOfWeekData) {
        final subject = await FirestoreService.instance
            .getDocumentBasedOnId<Subject, Subject>(
          collection: FirebaseConstants.subjectsCollection,
          documentId: time.subjectId,
          tFromJson: Subject.fromJson,
          isList: false,
        );

        timings.add(time.copyWith(subjectName: subject.data.name));
      }

      final dayData = DayModelClass(
        day: event.dayOfWeek,
        selectedTimings: timings,
      );

      emit(SubjectDataFetchedState(selectedDayData: dayData));
    } catch (e, stack) {
      if (kDebugMode) {
        print("error: $e");
        print("stack: $stack");
      }
      emit(SubjectFailure(message: e.toString()));
    }
  }

  Future<void> _createSubject(
    CreateSubjectEvent event,
    Emitter<SubjectState> emit,
  ) async {
    try {
      emit(SubjectDataUploadedState());
      final subjectData = event.subject;

      // Upload Subject & Fetch Subject Id
      final subjectId = await FirestoreService.instance.addDocument(
        collection: FirebaseConstants.subjectsCollection,
        data: {"name": subjectData.name},
        returnId: true,
      );

      final daysData = _prepareDaysData(subjectData.days, subjectId);

      for (final day in daysData) {
        final docExists = await _documentExists(day.day);
        final existingData =
            docExists ? await _getExistingDocumentData(day.day) : [];

        final updatedDay = day.copyWith(
            selectedTimings: [...existingData, ...day.selectedTimings]);

        await FirestoreService.instance.addDocument(
          collection: FirebaseConstants.timeTableCollection,
          documentId: day.day,
          data: updatedDay.toDayTimingsJson(),
        );
      }

      emit(SubjectDataUploadedState());
    } catch (e, stack) {
      if (kDebugMode) {
        print("error: $e");
        print("stack: $stack");
      }
      emit(SubjectFailure(message: e.toString()));
    }
  }

  List<DayModelClass> _prepareDaysData(
      List<DayModelClass> days, String? subjectId) {
    return days.where((day) => day.isChecked).map((day) {
      return day.copyWith(
        selectedTimings: day.selectedTimings
            .where((time) => time.isChecked)
            .map((time) => time.copyWith(subjectId: subjectId))
            .toList(),
      );
    }).toList();
  }

  Future<bool> _documentExists(String documentId) async {
    final count = await FirestoreService.instance.getDocumentCount(
      FirebaseConstants.timeTableCollection,
    );
    return count > 0 &&
        await FirestoreService.instance.documentExists(
          collection: FirebaseConstants.timeTableCollection,
          documentId: documentId,
        );
  }

  Future<List<TimingModelClass>> _getExistingDocumentData(
    String documentId,
  ) async {
    final existingDoc = await FirestoreService.instance
        .getDocumentBasedOnId<List<TimingModelClass>, TimingModelClass>(
      collection: FirebaseConstants.timeTableCollection,
      documentId: documentId,
      tFromJson: TimingModelClass.fromJson,
      dataKey: 'selectedTimings',
      isList: true,
    );
    return existingDoc.data;
  }
}
