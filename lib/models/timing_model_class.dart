// ignore_for_file: public_member_api_docs, sort_constructors_first
class TimingModelClass {
  final String id;
  final String timing;
  final bool isChecked;
  const TimingModelClass({
    required this.id,
    required this.timing,
    required this.isChecked,
  });
  

  

  TimingModelClass copyWith({
    String? id,
    String? timing,
    bool? isChecked,
  }) {
    return TimingModelClass(
      id: id ?? this.id,
      timing: timing ?? this.timing,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
