import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:month_year_picker2/month_year_picker2.dart';
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
        if (state is ThemeChanged) {
          themeData = state.themeData;
        } else {
          // Default theme when state is not ThemeChanged
          themeData = ThemeBloc.lightTheme; // or any other default theme
        }
        return GetMaterialApp(
          theme: themeData,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            MonthYearPickerLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('id', 'ID'), // Tambahkan dukungan untuk bahasa Indonesia
          ],
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
