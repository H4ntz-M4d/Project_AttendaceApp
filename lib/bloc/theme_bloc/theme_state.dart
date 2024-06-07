// theme_state.dart
part of 'theme_bloc.dart';

@immutable
sealed class ThemeState {}

final class ThemeInitial extends ThemeState {}

final class ThemeChanged extends ThemeState {
  final ThemeData themeData;

  ThemeChanged(this.themeData);
}
