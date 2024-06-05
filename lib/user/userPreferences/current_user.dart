import "dart:convert";
import "package:get/get.dart";
import "package:project_attendance_app/api_connection/api_connection.dart";
import "package:project_attendance_app/user/model/user.dart";
import "package:project_attendance_app/user/userPreferences/user_preferences.dart";
import 'package:http/http.dart' as http;

class CurrentUser extends GetxController {
  Rx<Siswa> _currentUser = Siswa(
          nis: '',
          siswaPassword: '',
          nama: '',
          tmpt_lahir: '',
          tgl_lahir: '',
          alamat: '',
          phone: '')
      .obs;

  Siswa get user => _currentUser.value;

  getUserInfo() async {
    Siswa? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    if (getUserInfoFromLocalStorage != null) {
      _currentUser.value = getUserInfoFromLocalStorage;
    } else {
      // Handle the case when getUserInfoFromLocalStorage is null
      // For example, you could set a default value or display an error message
    }
  }

  updateUserInfo(Siswa updatedUser) async {
    _currentUser.value = updatedUser;
    await RememberUserPrefs.storeUserInfo(updatedUser);
  }

  Future<void> syncUserInfo() async {
    try {
      var res = await http
          .get(Uri.parse('${API.getData}?nis=${_currentUser.value.nis}'));
      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);
        if (resBody['success'] == true) {
          Siswa updatedUser = Siswa.fromJson(resBody['userData']);
          updateUserInfo(updatedUser);
        }
      }
    } catch (error) {
      print("Error syncing user info: $error");
    }
  }
}
