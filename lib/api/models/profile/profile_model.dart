import 'package:intl/intl.dart';

class ProfileModel {
  final int? id;
  String? phoneNumber;
  final String? fullName;
  String? dateOfBirth;
  String? gender;
  final String? profile;
  final int? map;

  ProfileModel({required this.id, required this.phoneNumber, required this.fullName, required this.dateOfBirth, required this.gender, required this.profile, required this.map});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      phoneNumber: json['phone_number'],
      fullName: json['full_name'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      profile: json['profile'],
      map: json['map'],
    );
  }

  void formatPhoneNumber() {
    if (phoneNumber != null && phoneNumber!.startsWith('+855')) {
      phoneNumber = phoneNumber!.replaceFirst('+855', '0');
    }
    if (phoneNumber!.length >= 9) {
      // Split the phone number into groups and format it
      phoneNumber = phoneNumber!.replaceFirstMapped(RegExp(r'(\d{1,3})(\d{1,3})(\d{1,4})'), (match) {
        final part1 = match[1] ?? '';
        final part2 = match[2] ?? '';
        final part3 = match[3] ?? '';
        return '$part1 $part2 $part3';
      });
    }
  }

  // Custom method to format the date
  void formatDateOfBirth() {
    final inputFormat = DateFormat('yyyy-MM-dd');
    final outputFormat = DateFormat('dd MMM yyyy', 'en_US');
    final date = inputFormat.parse(dateOfBirth!);
    dateOfBirth = outputFormat.format(date);
  }

  // Custom method to format the gender
  void formatGender() {
    gender = gender!.substring(0, 1).toUpperCase() + gender!.substring(1).toLowerCase();
  }
}
