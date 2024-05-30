part of 'history_bloc.dart';

@immutable
abstract class HistoryEvent {}

class LoadAbsensiEvent extends HistoryEvent {}

class FilterAbsensiEvent extends HistoryEvent {
  final String filter;

  FilterAbsensiEvent(this.filter);
}
