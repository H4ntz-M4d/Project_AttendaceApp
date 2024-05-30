import 'dart:convert';

import 'package:project_attendance_app/user/model/absensi_siswa.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberPresentPrefs {
  static Future<void> saveRememberAbsensi(List<AbsensiSiswa> history) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String absensiJsonData =
        jsonEncode(history.map((e) => e.toJson()).toList());
    await preferences.setString("historyAbsensi", absensiJsonData);
  }

  static Future<List<AbsensiSiswa>> getRememberAbsensi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? absensiJsonData = preferences.getString("historyAbsensi");
    if (absensiJsonData != null) {
      List<dynamic> jsonList = jsonDecode(absensiJsonData);
      return jsonList.map((json) => AbsensiSiswa.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
