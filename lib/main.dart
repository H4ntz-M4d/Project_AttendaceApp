import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_attendance_app/Screen/record/record_screen.dart';
import 'package:project_attendance_app/Screen/splashScreen/splash_layout.dart';
import 'package:project_attendance_app/user/authentication/login_layout.dart';
import 'package:project_attendance_app/user/fragments/dashboard.dart';
import 'package:project_attendance_app/user/fragments/detail_absen.dart';
import 'package:project_attendance_app/user/userPreferences/user_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Attendance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home:
          FutureBuilder(
        future: RememberUserPrefs.readUserInfo(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.data == null) {
            return const SplashScreen();
          } else {
            return const RecordPage();
          }
        },
      ),
    );
  }
}
