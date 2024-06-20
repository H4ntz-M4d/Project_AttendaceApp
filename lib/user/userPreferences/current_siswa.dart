import "dart:convert";
import "package:get/get.dart";
import "package:project_attendance_app/api_connection/api_connection.dart";
import "package:project_attendance_app/user/model/siswa.dart";
import "package:project_attendance_app/user/userPreferences/siswa_preference.dart";
import "package:project_attendance_app/user/userPreferences/user_preferences.dart";
import 'package:http/http.dart' as http;

class CurrentSiswa extends GetxController {
  Rx<Siswa> _currentSiswa = Siswa(
          nis: '',
          siswaPassword: '',
          nama: '',
          tmpt_lahir: '',
          tgl_lahir: '',
          alamat: '',
          phone: '',
          role: '')
      .obs;

  Siswa get user => _currentSiswa.value;

  getUserInfo() async {
    Siswa? getUserInfoFromLocalStorage =
        await RememberSiswaPrefs.readSiswaInfo();
    if (getUserInfoFromLocalStorage != null) {
      _currentSiswa.value = getUserInfoFromLocalStorage;
    } else {
      // Handle the case when getUserInfoFromLocalStorage is null
      // For example, you could set a default value or display an error message
    }
  }

  updateUserInfo(Siswa updatedUser) async {
    _currentSiswa.value = updatedUser;
    await RememberSiswaPrefs.storeSiswaInfo(updatedUser);
  }

  Future<void> syncUserInfo() async {
    try {
      var res = await http
          .get(Uri.parse('${API.getData}?nis=${_currentSiswa.value.nis}'));
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
