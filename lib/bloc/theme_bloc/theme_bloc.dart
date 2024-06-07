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
    // Define other light theme properties here
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    // Define other dark theme properties here
  );

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    final isCurrentlyDark = state is ThemeChanged &&
        (state as ThemeChanged).themeData.brightness == Brightness.dark;
    final newTheme = isCurrentlyDark ? _lightTheme : _darkTheme;
    emit(ThemeChanged(newTheme));
  }
}
