// theme_bloc.dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    canvasColor: Colors.white,
    primaryColor: const Color(0xff3977ff),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff3977ff),
      foregroundColor: Colors.white,
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xff3977ff),
      primaryContainer: Color(0xff3977ff),
      secondary: Color(0xffecebee),
      secondaryContainer: Color(0xffecebee),
      tertiary: Colors.black,
      tertiaryContainer: Colors.white,
      background: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      error: Color(0xFFB00020),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: Colors.black,
      onSurface: Colors.black,
      onError: Colors.white,
    ),
    dividerColor: Colors.black,
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        titleSmall: TextStyle(
          color: Color.fromARGB(200, 0, 0, 0),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        labelLarge: TextStyle(
          color: Color.fromARGB(200, 0, 0, 0),
          fontSize: 16,
        ),
        labelMedium: TextStyle(
          color: Color.fromARGB(200, 255, 255, 255),
          fontSize: 12,
        ),
        labelSmall: TextStyle(
          color: Color.fromARGB(200, 0, 0, 0),
          fontSize: 12,
        )),
  );

// Definisi Tema Gelap
  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xff3977ff),
    canvasColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff3977ff),
      foregroundColor: Colors.white,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff3977ff),
      primaryContainer: Color(0xff3977ff),
      secondary: Colors.white,
      secondaryContainer: Color(0xFF696969),
      tertiary: Colors.white,
      tertiaryContainer: Color(0xFF1B2339),
      background: Color(0xFF121212),
      surface: Color(0xFF121212),
      error: Color(0xFFCF6679),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onBackground: Colors.white,
      onSurface: Colors.white,
      onError: Colors.black,
    ),
    scaffoldBackgroundColor: const Color(0xFF282E45),
    dividerColor: Color(0xff3977ff),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFF50E2FD),
        fontSize: 25,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 24,
      ),
      headlineSmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      titleSmall: TextStyle(
        color: Color.fromARGB(200, 255, 255, 255),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      labelLarge: TextStyle(
        color: Color.fromARGB(200, 255, 255, 255),
        fontSize: 16,
      ),
      labelMedium: TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
      labelSmall: TextStyle(
        color: Color.fromARGB(200, 255, 255, 255),
        fontSize: 12,
      ),
    ),
  );

  static ThemeData get lightTheme => _lightTheme;
  static ThemeData get darkTheme => _darkTheme;

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    final isCurrentlyDark = state is ThemeChanged &&
        (state as ThemeChanged).themeData.brightness == Brightness.dark;
    final newTheme = isCurrentlyDark ? _lightTheme : _darkTheme;
    emit(ThemeChanged(newTheme));
  }
}
