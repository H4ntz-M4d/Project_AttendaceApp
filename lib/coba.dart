import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_attendance_app/Screen/record/record_detail_page.dart';
import 'package:project_attendance_app/Screen/record/record_screen.dart';
import 'package:project_attendance_app/switch.dart';
import 'package:project_attendance_app/user/authentication/login_layout.dart';
import 'package:project_attendance_app/user/fragments/about_screen.dart';
import 'package:project_attendance_app/user/fragments/account_screen.dart';
import 'package:project_attendance_app/user/fragments/detail_absen2.dart';
import 'package:project_attendance_app/user/userPreferences/record_preferences.dart';
import 'package:project_attendance_app/user/userPreferences/siswa_preference.dart';
import 'package:project_attendance_app/user/userPreferences/user_preferences.dart';

class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> logout() async {
      await RememberSiswaPrefs.clearSiswaInfo();
      await RememberRecordPrefs.clearRememberAbsensi();
      Get.offAll(() => const LoginPage());
    }

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Siabsen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          ListTile(
            leading: Icon(Icons.inbox),
            title: Text('Beranda'),
            onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 500), () {
                Get.to(() => const RecordPage());
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.auto_graph_outlined),
            title: Text('Grafik Absensi'),
            onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 500), () {
                Get.to(() => const RecordDetailPage());
              });
              // Add your logic here to navigate to Sent page
            },
          ),
          ListTile(
            leading: Icon(Icons.auto_graph_outlined),
            title: Text('Detail Absensi'),
            onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 500), () {
                Get.to(() => TableEventsExample());
              });
              // Add your logic here to navigate to Sent page
            },
          ),
          ListTile(
            leading: Icon(Icons.light),
            title: Text('Tema'),
            trailing: SwitchExample(),
            onTap: () {
              // Add your logic here to navigate to Sent page
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Tentang Kami'),
            onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 500), () {
                Get.to(() => AboutScreen());
              });
              // Add your logic here to navigate to Drafts page
            },
          ),
          Divider(
            color: Theme.of(context).dividerColor,
          ),
          ListTile(
            leading: Icon(Icons.account_circle_rounded),
            title: Text('Akun'),
            onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 500), () {
                Get.to(() => const AccountScreen());
              });
              // Add your logic here to navigate to Settings page
            },
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text('Keluar'),
            onTap: () {
              logout();
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 500), () {
                Get.to(() => const LoginPage());
                RememberUserPrefs.clearUserInfo();
              });
              // Add your logic here to navigate to Help page
            },
          ),
        ],
      ),
    );
  }
}
