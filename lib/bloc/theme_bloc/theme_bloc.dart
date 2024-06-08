// theme_bloc.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: const Color(0xfff8f8ff),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff3977ff),
      foregroundColor: Colors.white,
    ),
    colorScheme: const ColorScheme.light(
        primary: Colors.blue,
        secondary: Colors.purple,
        tertiary: Colors.orange,
        surface: Colors.pink),
    // Define other light theme properties here
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor:  const Color(0xFF12202F),
    scaffoldBackgroundColor:  const Color(0xFF12202F),
    // Define other dark theme properties here
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
