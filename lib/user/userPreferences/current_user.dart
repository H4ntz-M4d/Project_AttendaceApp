import 'dart:convert';
import 'package:get/get.dart';
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:project_attendance_app/user/model/guru.dart';
import 'package:project_attendance_app/user/model/siswa.dart';
import 'package:project_attendance_app/user/model/user.dart';
import 'package:project_attendance_app/user/userPreferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class CurrentUser extends GetxController {
  Rx<User?> _currentUser = Rx<User?>(null);

  User get user => _currentUser.value!;

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    User? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();

    if (getUserInfoFromLocalStorage != null) {
      if (getUserInfoFromLocalStorage is Guru) {
        _currentUser.value = Guru.fromJson(getUserInfoFromLocalStorage.toJson());
      } else if (getUserInfoFromLocalStorage is Siswa) {
        _currentUser.value = Siswa.fromJson(getUserInfoFromLocalStorage.toJson());
      }
    } else {
      print("No user info found in local storage");
    }
  }

  Future<void> updateUserInfo(User updatedUser) async {
    _currentUser.value = updatedUser;
    await RememberUserPrefs.storeUserInfo(updatedUser);
  }

  Future<void> syncUserInfo() async {
    try {
      String id = '';
      if (_currentUser.value is Guru) {
        id = (_currentUser.value as Guru).nip;
      } else if (_currentUser.value is Siswa) {
        id = (_currentUser.value as Siswa).nis;
      }

      var res = await http.get(Uri.parse('${API.getData}?id=$id'));
      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);
        if (resBody['success'] == true) {
          User updatedUser;
          if (resBody['userData']['role'] == 'guru') {
            updatedUser = Guru.fromJson(resBody['userData']);
          } else {
            updatedUser = Siswa.fromJson(resBody['userData']);
          }
          updateUserInfo(updatedUser);
        }
      }
    } catch (error) {
      print("Error syncing user info: $error");
    }
  }
}
