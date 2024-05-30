part of 'history_bloc.dart';

@immutable
abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<AbsensiSiswa> absensi;

  HistoryLoaded(this.absensi);
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}
