import 'dart:convert';
import 'package:project_attendance_app/user/model/profil_user.dart';
import 'package:project_attendance_app/user/model/siswa.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberSiswaPrefs {
  //save siswa info
  static Future<void> storeSiswaInfo(Siswa siswaInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String siswaJsonData = jsonEncode(siswaInfo.toJson());
    await preferences.setString("currentsiswa", siswaJsonData);
  }

  // static Future<void> profileSiswaInfo(ProfileUser siswaInfo) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String siswaJsonData = jsonEncode(siswaInfo.toJson());
  //   await preferences.setString("currentsiswa", siswaJsonData);
  // }

  static Future<Siswa?> readSiswaInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? siswaInfo = preferences.getString("currentsiswa");
    if (siswaInfo != null) {
      Map<String, dynamic> siswaDataMap = jsonDecode(siswaInfo);
      return Siswa.fromJson(siswaDataMap);
    }
    return null;
  }

  static Future<void> clearSiswaInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentsiswa");
  }
}
