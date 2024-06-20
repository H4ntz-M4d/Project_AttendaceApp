import 'package:project_attendance_app/user/model/guru.dart';
import 'package:project_attendance_app/user/model/siswa.dart';

abstract class User {
  User(); // Abstract constructor

  factory User.fromJson(Map<String, dynamic> json) {
    if (json['role'] == 'siswa') {
      return Siswa.fromJson(json); // Return Siswa object
    } else if (json['role'] == 'guru') {
      return Guru.fromJson(json); // Return Guru object
    }
    throw Exception('Invalid role');
  }

  // Abstract methods to be implemented by subclasses
  Map<String, dynamic> toJson();
}
