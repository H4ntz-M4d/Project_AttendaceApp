import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:project_attendance_app/user/model/guru.dart';
import 'package:project_attendance_app/user/model/user.dart';
import 'package:project_attendance_app/user/userPreferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class CurrentSiswa extends GetxController {
  
  final Rx<User> _currentUser = Guru(
          nip: '',
          nik: '',
          nuptk: '',
          nama: '',
          jkel: '',
          alamat: '',
          tmpt_lahir: '',
          tgl_lahir: '',
          guru_status: '',
          phone: '',
          agama: '',
          guru_password: '',
          guru_email: '',
          verifikasi_kode: '',
          role: '')
      .obs;

  User get user => _currentUser.value;

  getUserInfo() async {
    User? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    if (getUserInfoFromLocalStorage != null) {
      _currentUser.value = getUserInfoFromLocalStorage;
    } else {
      // Handle the case when getUserInfoFromLocalStorage is null
      // For example, you could set a default value or display an error message
    }
  }

  updateUserInfo(User updatedUser) async {
    _currentUser.value = updatedUser;
    await RememberUserPrefs.storeUserInfo(updatedUser);
  }

  Future<void> syncUserInfo() async {
    try {
      // Cek apakah _currentUser adalah instansi dari Siswa atau Guru
      String id = '';
      if (_currentUser.value is Guru) {
        id = (_currentUser.value as Guru).nip;
      }

      var res = await http.get(Uri.parse('${API.getData}?id=$id'));
      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);
        if (resBody['success'] == true) {
          // Periksa tipe data user yang diupdate dan instansiasi yang sesuai
          User updatedUser;
          if (resBody['userData']['role'] == 'guru') {
            updatedUser = Guru.fromJson(resBody['userData']);
            updateUserInfo(updatedUser);
          } 
        }
      }
    } catch (error) {
      print("Error syncing user info: $error");
    }
  }
}
