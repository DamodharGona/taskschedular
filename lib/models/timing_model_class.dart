class TimingModelClass {
  final String id;
  final String subjectId;
  final String subjectName;
  final String timing;
  final bool isChecked;
  final bool isBlocked;

  const TimingModelClass({
    this.id = '',
    this.subjectId = '',
    this.subjectName = '',
    this.timing = '',
    this.isChecked = false,
    this.isBlocked = false,
  });

  TimingModelClass copyWith({
    String? id,
    String? timing,
    String? subjectName,
    bool? isChecked,
    bool? isBlocked,
    String? subjectId,
  }) {
    return TimingModelClass(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      timing: timing ?? this.timing,
      isChecked: isChecked ?? this.isChecked,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'timing': timing,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'isChecked': isChecked,
    };
  }

  Map<String, dynamic> toDaysJson() {
    return <String, dynamic>{
      'timing': timing,
      'subjectId': subjectId,
    };
  }

  factory TimingModelClass.fromJson(Map<String, dynamic> map) {
    return TimingModelClass(
      id: map['id'] ?? '',
      subjectId: map['subjectId'] ?? '',
      timing: map['timing'] ?? '',
      subjectName: map['subjectName'] ?? '',
      isChecked: map['isChecked'] ?? false,
    );
  }
}
