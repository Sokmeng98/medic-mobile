class AuthModel {
  final int id;
  final String image;
  final String name;
  final String fullName;
  final String gender;
  final String dateOfBirth;
  final String email;
  final String phoneNumber;
  final bool isSuperUser;
  final bool isStaff;

  AuthModel({
    required this.id,
    required this.image,
    required this.name,
    required this.fullName,
    required this.gender,
    required this.dateOfBirth,
    required this.email,
    required this.phoneNumber,
    required this.isSuperUser,
    required this.isStaff,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      fullName: json['full_name'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      isSuperUser: json['is_superuser'],
      isStaff: json['is_staff'],
    );
  }
}
