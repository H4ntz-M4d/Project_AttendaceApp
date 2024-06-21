import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:project_attendance_app/user/model/siswa.dart';
import 'package:project_attendance_app/user/model/guru.dart';
import 'package:project_attendance_app/user/model/user.dart';
import 'package:project_attendance_app/user/userPreferences/current_user.dart';
import 'package:project_attendance_app/user/userPreferences/edit_Photo.dart';
import 'package:project_attendance_app/user/userPreferences/edit_alamat.dart';
import 'package:project_attendance_app/user/model/profil_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:project_attendance_app/user/userPreferences/edit_phoneNum.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() {
    return _ProfileScreen();
  }
}

class _ProfileScreen extends State<ProfileScreen> {
  final CurrentUser _currentUser = Get.put(CurrentUser());

  String _alamat = '';
  String _phone = '';

  @override
  void initState() {
    super.initState();
    _currentUser.syncUserInfo();
  }

  Future<void> _updateUserProfile(String alamat, String phone) async {
    User? user = _currentUser.user;

    try {
      var res = await http.post(
        Uri.parse(API.updateProfile),
        body: {
          "nis": (user is Guru)
              ? user.nip
              : (user is Siswa)
                  ? user.nis
                  : '',
          "role": (user is Guru)
              ? user.role
              : (user is Siswa)
                  ? user.role
                  : '',
          "alamat": alamat,
          "phone": phone,
        },
      );

      if (res.statusCode == 200) {
        var resBodyOfEdit = jsonDecode(res.body);
        if (resBodyOfEdit['success'] == true) {
          Fluttertoast.showToast(msg: "Profil berhasil diperbarui.");
          setState(() {
            if (_currentUser is Guru) {
              (_currentUser.user as Guru).alamat = alamat;
              (_currentUser.user as Guru).phone = phone;
            } else if (_currentUser is Siswa) {
              (_currentUser.user as Siswa).alamat = alamat;
              (_currentUser.user as Siswa).phone = phone;
            } else {}
          });
        } else {
          Fluttertoast.showToast(msg: "Gagal memperbarui profil.");
        }
      } else {
        Fluttertoast.showToast(msg: "Server error.");
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Terjadi kesalahan.");
    }
  }

  void _editProfile(ProfilItem item) {
    setState(() {
      _alamat = item.alamat;
      _phone = item.noHp;
    });
    _updateUserProfile(_alamat, _phone);
  }

  void _openEditAlamat() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return EditAlamat(editProfile: _editProfile);
        });
  }

  void _openEditPhone() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return EditPhone(editProfile: _editProfile);
        });
  }

  String formatDate(String date) {
    DateTime dateTime = DateFormat('dd-MM-yyyy').parse(date);
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).appBarTheme.foregroundColor,
            )),
        title: Text(
          'Profil',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Container(
              width: 300,
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  const BuildEditImage(),
                  const SizedBox(
                    height: 35,
                  ),
                  Obx(() {
                    if (_currentUser.user == null) {
                      return CircularProgressIndicator();
                    }

                    final user = _currentUser.user;
                    return Column(
                      children: [
                        InputDecorator(
                          decoration: InputDecoration(
                              icon: Icon(Icons.assignment_ind),
                              labelText: (user is Guru) ? 'NIP' : 'NIS',
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10)),
                          child: Text(
                            (user is Guru)
                                ? user.nip
                                : (user is Siswa)
                                    ? user.nis
                                    : '',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        InputDecorator(
                          decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              labelText: 'Nama',
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10)),
                          child: Text(
                            (user is Guru)
                                ? user.nama
                                : (user is Siswa)
                                    ? user.nama
                                    : '',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        InputDecorator(
                          decoration: const InputDecoration(
                              icon: Icon(Icons.assignment_ind),
                              labelText: 'Tempat/Tanggal Lahir',
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10)),
                          child: Text(
                            (user is Guru)
                                ? '${user.tmpt_lahir}, ${user.tgl_lahir}'
                                : (user is Siswa)
                                    ? '${user.tmpt_lahir}, ${user.tgl_lahir}'
                                    : '',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        InkWell(
                          onTap: _openEditAlamat,
                          splashColor: Colors.blueGrey,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                                icon: Icon(Icons.location_on_outlined),
                                labelText: 'Alamat',
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _alamat,
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ),
                                const Icon(Icons.edit)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        InkWell(
                          onTap: _openEditPhone,
                          splashColor: Colors.blueGrey,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                                icon: Icon(Icons.phone),
                                labelText: 'No. Handphone',
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _phone,
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ),
                                const Icon(Icons.edit)
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
