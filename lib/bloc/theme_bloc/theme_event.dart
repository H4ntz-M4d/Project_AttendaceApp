// theme_event.dart
part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

// Event to toggle the theme between light and dark
final class ToggleThemeEvent extends ThemeEvent {}
