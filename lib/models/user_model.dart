class UserModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String type;

  UserModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.type,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'type': type,
    };
  }
}
