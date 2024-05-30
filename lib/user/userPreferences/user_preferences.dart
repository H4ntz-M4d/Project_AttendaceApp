import 'dart:convert';

import 'package:project_attendance_app/user/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPrefs {
  //save user info
  static Future<void> saveRememberUser(Siswa userInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);
  }

  static Future<Siswa?> readUserInfo() async {
    Siswa? currentUserInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString("currentUser");
    if (userInfo != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      currentUserInfo = Siswa.fromJson(userDataMap);
    }
    return currentUserInfo;
  }
}
