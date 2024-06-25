import 'dart:convert';
import 'dart:typed_data';
import 'package:project_attendance_app/user/model/profil_user.dart';
import 'package:project_attendance_app/user/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPrefs {
  // Menyimpan informasi pengguna
  static Future<void> storeUserInfo(User userInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);
  }

  // Membaca informasi pengguna
  static Future<User?> readUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString("currentUser");
    if (userInfo != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      return User.fromJson(userDataMap);
    }
    return null;
  }

  // Menghapus informasi pengguna dan gambar profil
  static Future<void> clearUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentUser");
    await preferences.remove("profile_image");
  }

  // Menyimpan gambar profil sebagai string base64
  static Future<void> storeProfileImage(Uint8List image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String base64String = base64Encode(image);
    await prefs.setString("profile_image", base64String);
  }

  // Membaca gambar profil dari string base64
  static Future<Uint8List?> loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? base64String = prefs.getString("profile_image");
    if (base64String != null) {
      return base64Decode(base64String);
    }
    return null;
  }
}
