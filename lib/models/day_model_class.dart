import 'package:taskschedular/models/timing_model_class.dart';

class Subject {
  final String id;
  final String name;
  final List<DayModelClass> days;

  const Subject({
    this.id = '',
    this.name = '',
    this.days = const <DayModelClass>[],
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'days': days.map((e) => e.toJson()).toList(),
    };
  }

  factory Subject.fromJson(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      days: map['days'] != null
          ? List<DayModelClass>.from(
              (map['days']).map<DayModelClass>(
                (x) => DayModelClass.fromJson(x as Map<String, dynamic>),
              ),
            )
          : const <DayModelClass>[],
    );
  }

  Subject copyWith({
    String? id,
    String? name,
    List<DayModelClass>? days,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      days: days ?? this.days,
    );
  }
}

class DayModelClass {
  final String id;
  final String day;
  final bool isChecked;
  final List<TimingModelClass> selectedTimings;

  const DayModelClass({
    this.id = '',
    this.day = '',
    this.isChecked = false,
    this.selectedTimings = const [],
  });

  DayModelClass copyWith({
    String? id,
    String? day,
    bool? isChecked,
    List<TimingModelClass>? selectedTimings,
  }) {
    return DayModelClass(
      id: id ?? this.id,
      day: day ?? this.day,
      isChecked: isChecked ?? this.isChecked,
      selectedTimings: selectedTimings ?? this.selectedTimings,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'day': day,
      'isChecked': isChecked,
      'selectedTimings': selectedTimings.map((x) => x.toJson()).toList(),
    };
  }

  Map<String, dynamic> toDayTimingsJson() {
    return <String, dynamic>{
      'selectedTimings': selectedTimings.map((x) => x.toDaysJson()).toList(),
    };
  }

  factory DayModelClass.fromJson(Map<String, dynamic> map) {
    return DayModelClass(
      id: map['id'] ?? '',
      day: map['day'] ?? '',
      isChecked: map['isChecked'] ?? false,
      selectedTimings: map['selectedTimings'] != null
          ? List<TimingModelClass>.from(
              (map['selectedTimings']).map(
                (x) => TimingModelClass.fromJson(x as Map<String, dynamic>),
              ),
            )
          : const <TimingModelClass>[],
    );
  }
}
