import 'dart:convert';
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:project_attendance_app/user/model/guru.dart';
import 'package:project_attendance_app/user/model/record_absen.dart';
import 'package:project_attendance_app/user/model/siswa.dart';
import 'package:project_attendance_app/user/model/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<List<String>> getCountRecordsInfo(User user) async {
    String id;
    String role;

    if (user is Guru) {
      id = user.nip;
      role = user.role;
    } else if (user is Siswa) {
      id = user.nis;
      role = user.role;
    } else {
      // Handle unknown user type
      throw Exception('Unknown user type');
    }

    try {
      final results = await http.post(
        Uri.parse(API.getCountTotalRecords),
        body: {
          "nis": id,
          "role": role,
        },
      );
      var resultsDecode = json.decode(results.body)['userData'];
      return [
        resultsDecode['jumlah_hadir'].toString(),
        resultsDecode['jumlah_sakit'].toString(),
        resultsDecode['jumlah_izin'].toString(),
        resultsDecode['jumlah_alpha'].toString(),
      ];
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      return [];
    }
  }

  static Future<List<RecordAbsen>> getTopFiveRecords(User user) async {
    String id;
    String role;

    if (user is Guru) {
      id = user.nip;
      role = user.role;
    } else if (user is Siswa) {
      id = user.nis;
      role = user.role;
    } else {
      // Handle unknown user type
      throw Exception('Unknown user type');
    }

    try {
      final results = await http.post(
        Uri.parse(API.getTop5Record),
        body: {
          "nis": id,
          "role": role,
        },
      );
      var resultsDecode = json.decode(results.body);
      List<RecordAbsen> topFiveRecords = [];
      for (var record in resultsDecode['userData']) {
        topFiveRecords.add(RecordAbsen.fromJson(record));
      }
      return topFiveRecords;
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      return [];
    }
  }
}
