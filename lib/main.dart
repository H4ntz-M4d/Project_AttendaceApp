import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:project_attendance_app/Screen/record/record_screen.dart';
import 'package:project_attendance_app/Screen/splashScreen/splash_layout.dart';
import 'package:project_attendance_app/bloc/theme_bloc/theme_bloc.dart';
import 'package:project_attendance_app/user/userPreferences/user_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BlocProvider(
      create: (context) => ThemeBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        ThemeData themeData;
        if (state is ThemeInitial) {
          themeData = ThemeBloc._lightTheme;
        } else if (state is ThemeChanged) {
          themeData = (state as ThemeChanged).themeData;
        } else {
          themeData = ThemeBloc._lightTheme;
        }
        return GetMaterialApp(
          title: 'Attendance App',
          debugShowCheckedModeBanner: false,
          home: FutureBuilder(
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
      },
    );
  }
}
