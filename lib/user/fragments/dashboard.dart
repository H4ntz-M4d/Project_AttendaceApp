import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_attendance_app/user/fragments/profile_screen.dart';
import 'package:project_attendance_app/user/userPreferences/current_user.dart';

class DashboardSiswa extends StatelessWidget {
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (CurrentUser) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Dashboard"),
          ),
          body: Center(
            child: IconButton(
              icon: const Icon(Icons.people),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ProfileScreen()
                )
              );
              },
            ),
          ),
        );
      },
    );
  }
}
