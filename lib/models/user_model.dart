import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String emailId;
  final String mobile;

  const UserModel({
    this.id = '',
    this.name = '',
    this.emailId = '',
    this.mobile = '',
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'emailId': emailId,
      'mobile': mobile,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      emailId: map['emailId'] ?? '',
      mobile: map['mobile'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, emailId, mobile];
}
