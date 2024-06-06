import 'dart:convert';

import 'package:project_attendance_app/user/model/record_absen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberRecordPrefs {
  static Future<void> saveRememberAbsensi(List<RecordAbsen> history) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String absensiJsonData =
        jsonEncode(history.map((e) => e.toJson()).toList());
    await preferences.setString("historyAbsensi", absensiJsonData);
  }

  static Future<List<RecordAbsen>> getRememberAbsensi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? absensiJsonData = preferences.getString("historyAbsensi");
    if (absensiJsonData != null) {
      List<dynamic> jsonList = jsonDecode(absensiJsonData);
      return jsonList.map((json) => RecordAbsen.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  static Future<void> clearRememberAbsensi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("historyAbsensi");
  }
}
