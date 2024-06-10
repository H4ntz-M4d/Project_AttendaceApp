// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_attendance_app/user/fragments/account_screen.dart';
import 'package:project_attendance_app/user/fragments/detail_absen.dart';
import 'package:project_attendance_app/user/fragments/profile_screen.dart';
import 'package:project_attendance_app/user/userPreferences/current_user.dart';

class DashboardSiswa extends StatelessWidget {
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  DashboardSiswa({super.key});

  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Apakah Anda ingin meninggalkan aplikasi?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Iya'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (CurrentUser) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return WillPopScope(
          onWillPop: () => _onWillPop(context),
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Dashboard"),
            ),
            body: Center(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.people),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const ProfileScreen()));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.assignment_turned_in_sharp),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const AccountScreen()));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
