import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:project_attendance_app/user/model/user.dart';
import 'package:project_attendance_app/user/userPreferences/current_user.dart';
import 'package:project_attendance_app/user/userPreferences/edit_Photo.dart';
import 'package:project_attendance_app/user/userPreferences/edit_screen.dart';
import 'package:project_attendance_app/user/model/profil_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() {
    return _ProfileScreen();
  }
}

class _ProfileScreen extends State<ProfileScreen> {
  final List<ProfilItem> _editingProfil = [];
  List _listdata = [];
  String _alamat = ''; // Tambahkan variabel name
  String _phone = ''; // Tambahkan variabel phone

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentUser.syncUserInfo();
  }

  void _openEditOverlay() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return EditScreen(editProfile: _editProfile);
        });
  }

  void _editProfile(ProfilItem item) {
    setState(() {
      _alamat = item.alamat;
      _phone = item.noHp;
    });
    _updateUserProfile(_alamat, _phone);
  }

  final CurrentUser _currentUser = Get.put(CurrentUser());

  Future<void> _updateUserProfile(String alamat, String phone) async {
    try {
      var res = await http.post(
        Uri.parse(API.updateProfile),
        body: {
          "nis": _currentUser.user.nis,
          "alamat": alamat,
          "phone": phone,
        },
      );

      if (res.statusCode == 200) {
        var resBodyOfEdit = jsonDecode(res.body);
        if (resBodyOfEdit['success'] == true) {
          Fluttertoast.showToast(msg: "Profil berhasil diperbarui.");
          setState(() {
            _currentUser.user.alamat = alamat;
            _currentUser.user.phone = phone;
          });

          // Update data lokal
          Siswa updatedUser = Siswa(
            _currentUser.user.nis,
            _currentUser.user.siswaPassword,
            _currentUser.user.nama,
            _currentUser.user.ttl,
            alamat,
            phone,
          );

          _currentUser.updateUserInfo(updatedUser);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          'Profil',
          style: GoogleFonts.lato(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
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
                  Column(children: [
                    InputDecorator(
                      decoration: const InputDecoration(
                          icon: Icon(Icons.assignment_ind),
                          labelText: 'NIP',
                          contentPadding: EdgeInsets.symmetric(vertical: 10)),
                      child: Text(
                        _currentUser.user.nis,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    InputDecorator(
                      decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Nama',
                          contentPadding: EdgeInsets.symmetric(vertical: 10)),
                      child: Text(
                        _currentUser.user.nama,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    InputDecorator(
                      decoration: const InputDecoration(
                          icon: Icon(Icons.assignment_ind),
                          labelText: 'Tempat/Tanggal Lahir',
                          contentPadding: EdgeInsets.symmetric(vertical: 10)),
                      child: Text(
                        _currentUser.user.ttl,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    InputDecorator(
                      decoration: const InputDecoration(
                          icon: Icon(Icons.assignment_ind),
                          labelText: 'Alamat',
                          contentPadding: EdgeInsets.symmetric(vertical: 10)),
                      child: Text(
                        _currentUser.user.alamat,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    InputDecorator(
                      decoration: const InputDecoration(
                          icon: Icon(Icons.phone),
                          labelText: 'No. Handphone',
                          contentPadding: EdgeInsets.symmetric(vertical: 10)),
                      child: Text(
                        _currentUser.user.phone,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: _openEditOverlay, child: const Text('Edit')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
