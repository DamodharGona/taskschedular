// ignore_for_file: public_member_api_docs, sort_constructors_first
class DayModelClass {
  final String id;
  final String day;
  final bool isChecked;
  final List<String> selectedTimings;

  const DayModelClass({
    this.id = '',
    this.day = '',
    this.isChecked = false,
    this.selectedTimings = const[],
  });

  

  

  DayModelClass copyWith({
    String? id,
    String? day,
    bool? isChecked,
    List<String>? selectedTimings,
  }) {
    return DayModelClass(
      id: id ?? this.id,
      day: day ?? this.day,
      isChecked: isChecked ?? this.isChecked,
      selectedTimings: selectedTimings ?? this.selectedTimings,
    );
  }
}
