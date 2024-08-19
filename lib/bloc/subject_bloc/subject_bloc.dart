import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskschedular/core/constants/firebase_constants.dart';
import 'package:taskschedular/core/services/firestore_service.dart';
import 'package:taskschedular/models/subject_model.dart';
import 'package:taskschedular/models/time_table_model.dart';
import 'package:taskschedular/models/timing_model_class.dart';
import 'package:taskschedular/screens/timetable/data.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  /* Global Declarations */
  SubjectModel selectedSubjectForEdit = const SubjectModel();
  SubjectModel selectedSubjectForEditCopy = const SubjectModel();

  SubjectBloc() : super(SubjectInitial()) {
    on<SubjectEvent>((event, emit) => emit(SubjectDataLoadingState()));

    on<CreateSubjectEvent>(_createSubject);

    on<FetchSubjectsBasedOnDayEvent>(_fetchSubjectBasedOnDay);

    on<FetchSubjectDataEvent>(_fetchSubjectData);

    on<ModifyOrEditSubjectDataEvent>(_modifyOrEditSubjectData);
  }

  Future<void> _modifyOrEditSubjectData(
    ModifyOrEditSubjectDataEvent event,
    Emitter<SubjectState> emit,
  ) async {}

  Future<void> _fetchSubjectData(
    FetchSubjectDataEvent event,
    Emitter<SubjectState> emit,
  ) async {
    /* Fetch all documents data in collection */

    try {
      emit(SubjectDataLoadingState());

      final docsData = await FirestoreService.instance
          .getAllDocuments<List<SubjectOfDay>, SubjectOfDay>(
        collection: FirebaseConstants.timeTableCollection,
        tFromJson: SubjectOfDay.fromJson,
        dataKey: 'timetable',
        isList: true,
      );

      final dataAccToDays = docsData.data
          .where((data) => data.subjectId == event.subjectId)
          .toList();

      SubjectModel subjectModel = SubjectModel(
        subjectId: event.subjectId,
        subjectName: dataAccToDays.first.subjectName,
      );

      List<DaysInWeek> daysInWeekList = [];

      for (final day in daysInWeekData) {
        final dayData = dataAccToDays
            .where((data) => data.day == day.day)
            .map((e) => e)
            .toList();

        if (dayData.isEmpty) {
          daysInWeekList.add(DaysInWeek(
            day: day.day,
            isChecked: false,
            timings: day.timings,
          ));
        } else {
          for (final data2 in dayData) {
            final subjectTimings = day.timings
                .map((e) => TimeInDay(
                      isSelected: e.time == data2.time,
                      time: e.time,
                    ))
                .toSet()
                .toList();

            DaysInWeek daysInWeek = DaysInWeek(
              day: data2.day,
              isChecked: true,
              timings: subjectTimings,
            );

            daysInWeekList.add(daysInWeek);
          }
        }
      }

      selectedSubjectForEdit = subjectModel.copyWith(timeTable: daysInWeekList);
      selectedSubjectForEditCopy = selectedSubjectForEdit;

      emit(IndividualSubjectDataFetched(subject: selectedSubjectForEditCopy));
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

      emit(SubjectDataFetchedState(selectedDayData: dayOfWeekData));
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
      emit(SubjectDataLoadingState());

      final subjectData = event.subject;

      // Upload Subject & Fetch Subject Id
      final subjectId = await FirestoreService.instance.addDocument(
        collection: FirebaseConstants.subjectsCollection,
        data: {"name": subjectData.subjectName},
        returnId: true,
      );

      // Update subject model with the generated subjectId
      SubjectModel updatedSubject = subjectData.copyWith(subjectId: subjectId);

      // Prepare days data based on the subject timetable
      final daysData = _prepareDaysData(updatedSubject.timeTable);

      for (final day in daysData) {
        // Fetch existing document data if it exists
        final existingData = await _getExistingDocumentData(day.day);

        final currentData = day.timings
            .map(
              (e) => SubjectOfDay(
                day: day.day,
                subjectId: updatedSubject.subjectId,
                subjectName: updatedSubject.subjectName,
                time: e.time,
              ),
            )
            .toList();

        List<SubjectOfDay> updatedData = [...existingData, ...currentData];

        // Add or update the document in the timetable collection
        await FirestoreService.instance.addDocument(
          collection: FirebaseConstants.timeTableCollection,
          documentId: day.day,
          data: {
            "timetable": updatedData.map((e) => e.toFirebaseJson()).toList()
          },
        );
      }

      emit(SubjectDataUploadedState());
    } catch (e, stack) {
      if (kDebugMode) {
        print("Error in _createSubject: $e");
        print("Stack trace: $stack");
      }
      emit(
          SubjectFailure(message: "Failed to create subject: ${e.toString()}"));
    }
  }

  List<DaysInWeek> _prepareDaysData(List<DaysInWeek> days) {
    return days.where((day) => day.isChecked).map((day) {
      return day.copyWith(
        timings: day.timings
            .where((time) => time.isSelected)
            .map((time) => time)
            .toList(),
      );
    }).toList();
  }

  // Future<bool> _documentExists(String documentId) async {
  //   final count = await FirestoreService.instance.getDocumentCount(
  //     FirebaseConstants.timeTableCollection,
  //   );
  //   return count > 0 &&
  //       await FirestoreService.instance.documentExists(
  //         collection: FirebaseConstants.timeTableCollection,
  //         documentId: documentId,
  //       );
  // }

  Future<List<SubjectOfDay>> _getExistingDocumentData(
    String documentId,
  ) async {
    final existingDoc = await FirestoreService.instance
        .getDocumentBasedOnId<List<SubjectOfDay>, SubjectOfDay>(
      collection: FirebaseConstants.timeTableCollection,
      documentId: documentId,
      tFromJson: SubjectOfDay.fromJson,
      dataKey: 'timetable',
      isList: true,
    );

    return existingDoc.data;
  }
}
