import 'package:equatable/equatable.dart';

class TimeTableModel extends Equatable {
  final List<DayOfWeek> daysInWeek;

  const TimeTableModel({this.daysInWeek = const <DayOfWeek>[]});

  factory TimeTableModel.fromJson(Map<String, dynamic> map) {
    return TimeTableModel(
      daysInWeek: map['daysInWeek'] != null
          ? List<DayOfWeek>.from(
              (map['daysInWeek']).map<DayOfWeek>(
                (x) => DayOfWeek.fromJson(x as Map<String, dynamic>),
              ),
            )
          : const <DayOfWeek>[],
    );
  }

  @override
  List<Object?> get props => [daysInWeek];
}

class DayOfWeek extends Equatable {
  final String day;
  final List<SubjectOfDay> subjects;

  const DayOfWeek({this.day = '', this.subjects = const []});

  factory DayOfWeek.fromJson(Map<String, dynamic> map) {
    return DayOfWeek(
      day: map['day'] ?? '',
      subjects: map['subjects'] != null
          ? List<SubjectOfDay>.from(
              (map['subjects'] as List<int>).map<SubjectOfDay>(
                (x) => SubjectOfDay.fromJson(x as Map<String, dynamic>),
              ),
            )
          : const <SubjectOfDay>[],
    );
  }

  @override
  List<Object?> get props => [day, subjects];
}

class SubjectOfDay extends Equatable {
  final String day;
  final String subjectId;
  final String subjectName;
  final String time;

  const SubjectOfDay({
    this.day = '',
    this.subjectId = '',
    this.subjectName = '',
    this.time = '',
  });

  factory SubjectOfDay.fromJson(Map<String, dynamic> map) {
    return SubjectOfDay(
      day: map['id'] ?? '',
      subjectId: map['subjectId'] ?? '',
      subjectName: map['subjectName'] ?? '',
      time: map['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'day': day,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'time': time,
    };
  }

  Map<String, dynamic> toFirebaseJson() {
    return <String, dynamic>{
      'subjectId': subjectId,
      'subjectName': subjectName,
      'time': time,
    };
  }

  @override
  List<Object?> get props => [subjectId, subjectName, time];
}
