part of 'record_bloc.dart';

@immutable
sealed class RecordEvent {}

class LoadRecordEvent extends RecordEvent {}

class FilterRecordEvent extends RecordEvent {
  final String filter;

  FilterRecordEvent(this.filter);
}
