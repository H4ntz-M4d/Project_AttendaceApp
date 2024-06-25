import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_attendance_app/user/authentication/change_email.dart';
import 'package:project_attendance_app/user/authentication/forgot_password.dart';
import 'package:project_attendance_app/user/model/guru.dart';
import 'package:project_attendance_app/user/model/siswa.dart';
import 'package:project_attendance_app/user/userPreferences/current_user.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final CurrentUser _currentUser = Get.put(CurrentUser());
  String nama = '';
  String email= '';

  @override
  void initState() {
    super.initState();
    checkUserRole();
    _currentUser.syncUserInfo();
  }

  void checkUserRole() {
    if (_currentUser.user is Guru) {
      nama = (_currentUser.user as Guru).nama;
      email = (_currentUser.user as Guru).guru_email;
    } else if (_currentUser.user is Siswa) {
      nama = (_currentUser.user as Siswa).nama;
      email = (_currentUser.user as Siswa).email;
    } else {}
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
          'Akun',
          style: GoogleFonts.plusJakartaSans(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 12, right: 8, left: 8),
          child: Column(
            children: <Widget>[
              Text(
                'Detail Akun',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListTile(
                title: Text(
                  'Nama Pengguna',
                  style: GoogleFonts.plusJakartaSans(
                      color: Colors.black, fontSize: 15),
                ),
                subtitle: Text(
                  nama,
                  style: GoogleFonts.plusJakartaSans(
                      color: Color.fromARGB(255, 105, 105, 105), fontSize: 13),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => ChangeEmail()));
                },
                splashColor: Colors.white30,
                child: ListTile(
                  title: Text(
                    email,
                    style: GoogleFonts.plusJakartaSans(
                        color: Colors.black, fontSize: 15),
                  ),
                  subtitle: Text(
                    email,
                    style: GoogleFonts.plusJakartaSans(
                        color: Color.fromARGB(255, 105, 105, 105),
                        fontSize: 13),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => ForgotPasswordPage()));
                },
                splashColor: Colors.white30,
                child: ListTile(
                  title: Text(
                    'Password',
                    style: GoogleFonts.plusJakartaSans(
                        color: Colors.black, fontSize: 15),
                  ),
                  subtitle: Text(
                    'Klik untuk mengganti password',
                    style: GoogleFonts.plusJakartaSans(
                        color: Color.fromARGB(255, 105, 105, 105),
                        fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
