import 'dart:convert';
import 'package:project_attendance_app/user/model/profil_user.dart';
import 'package:project_attendance_app/user/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPrefs {
  //save siswa info
  static Future<void> storeUserInfo(User userInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);
  }

  static Future<void> profileUserInfo(ProfileUser userInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);
  }

  static Future<User?> readUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString("currentUser");
    if (userInfo != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      return User.fromJson(userDataMap);
    }
    return null;
  }

  static Future<void> clearUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentUser");
  }
}
