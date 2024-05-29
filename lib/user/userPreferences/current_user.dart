import "package:get/get.dart";
import "package:project_attendance_app/user/model/user.dart";
import "package:project_attendance_app/user/userPreferences/user_preferences.dart";

class CurrentUser extends GetxController {
  Rx<Siswa> _currentUser = Siswa('', '').obs;

  Siswa get user => _currentUser.value;

  getUserInfo() async {
    Siswa? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
  }
}
