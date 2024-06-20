import 'dart:convert';
import 'package:project_attendance_app/user/model/guru.dart';
import 'package:project_attendance_app/user/model/profil_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberGuruPrefs {
  //save user info
  static Future<void> storeGuruInfo(Guru userInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);
  }

  // static Future<void> profileGuruInfo(ProfileUser userInfo) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String userJsonData = jsonEncode(userInfo.toJson());
  //   await preferences.setString("currentUser", userJsonData);
  // }

  static Future<Guru?> readGuruInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString("currentUser");
    if (userInfo != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      return Guru.fromJson(userDataMap);
    }
    return null;
  }

  static Future<void> clearGuruInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentUser");
  }
}
