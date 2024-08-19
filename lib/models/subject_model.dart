class SubjectModel {
  final String subjectId;
  final String subjectName;
  final List<DaysInWeek> timeTable;

  const SubjectModel({
    this.subjectId = '',
    this.subjectName = '',
    this.timeTable = const <DaysInWeek>[],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subjectId': subjectId,
      'subjectName': subjectName,
      'timeTable': timeTable.map((x) => x.toJson()).toList(),
    };
  }

  /* this will generate key value pairs to save in firebase collection */
  Map<String, dynamic> toAddTimeTable({String? id}) {
    final subjectIdToUse = id ?? subjectId;

    return <String, dynamic>{
      'timeTable': timeTable.where((day) => day.isChecked).map((x) {
        return x.timings.where((time) => time.isSelected).map((time) {
          return {
            "subjectId": subjectIdToUse,
            "subjectName": subjectName,
            "time": time.time,
          };
        }).toList();
      }).toList(),
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      subjectId: map['subjectId'] ?? '',
      subjectName: map['subjectName'] ?? '',
      timeTable: map['timeTable'] != null
          ? List<DaysInWeek>.from(
              (map['timeTable']).map<DaysInWeek>(
                (x) => DaysInWeek.fromJson(x as Map<String, dynamic>),
              ),
            )
          : const <DaysInWeek>[],
    );
  }

  SubjectModel copyWith({
    String? subjectId,
    String? subjectName,
    List<DaysInWeek>? timeTable,
  }) {
    return SubjectModel(
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      timeTable: timeTable ?? this.timeTable,
    );
  }
}

class DaysInWeek {
  final String day;
  final bool isChecked;
  final List<TimeInDay> timings;

  const DaysInWeek({
    this.day = '',
    this.isChecked = false,
    this.timings = const <TimeInDay>[],
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'day': day,
      'isChecked': isChecked,
      'timings': timings.map((e) => e.toJson()).toList(),
    };
  }

  Map<String, dynamic> toFirebaseJson({
    required String id,
    required String name,
  }) {
    return <String, dynamic>{
      'timetable': timings
          .map((time) => time.toFirebaseJson(id: id, name: name))
          .toList(),
    };
  }

  factory DaysInWeek.fromJson(Map<String, dynamic> map) {
    return DaysInWeek(
      day: map['day'] ?? '',
      isChecked: map['isChecked'] ?? false,
      timings: map['timings'] != null
          ? List<TimeInDay>.from(
              (map['timings']).map<TimeInDay>(
                (x) => TimeInDay.fromJson(x as Map<String, dynamic>),
              ),
            )
          : const <TimeInDay>[],
    );
  }

  DaysInWeek copyWith({
    String? day,
    bool? isChecked,
    List<TimeInDay>? timings,
  }) {
    return DaysInWeek(
      day: day ?? this.day,
      isChecked: isChecked ?? this.isChecked,
      timings: timings ?? this.timings,
    );
  }
}

class TimeInDay {
  final String time;
  final String valueX;
  final bool isSelected;
  final bool isBlocked;

  const TimeInDay({
    this.time = '',
    this.valueX = '',
    this.isSelected = false,
    this.isBlocked = false,
  });

  factory TimeInDay.fromJson(Map<String, dynamic> map) {
    return TimeInDay(
      time: map['time'] ?? '',
      isBlocked: map['isBlocked'] ?? false,
      isSelected: map['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "time": time,
      "isSelected": isSelected,
      "valueX": valueX,
    };
  }

  Map<String, dynamic> toFirebaseJson({
    required String id,
    required String name,
  }) {
    return <String, dynamic>{
      'subjectId': id,
      'subjectName': name,
      'time': time,
    };
  }

  TimeInDay copyWith({
    String? time,
    bool? isSelected,
    bool? isBlocked,
    String? valueX,
  }) {
    return TimeInDay(
      time: time ?? this.time,
      valueX: valueX ?? this.valueX,
      isSelected: isSelected ?? this.isSelected,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }
}
