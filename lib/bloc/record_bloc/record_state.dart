part of 'record_bloc.dart';

@immutable
abstract class RecordState {}

class RecordInitial extends RecordState {}

class RecordLoading extends RecordState {}

class RecordLoaded extends RecordState {
  final List<RecordAbsen> record;

  RecordLoaded(this.record);
}

class RecordError extends RecordState {
  final String message;

  RecordError(this.message);
}
