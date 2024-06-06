import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_attendance_app/user/model/record_absen.dart';
import 'package:project_attendance_app/user/userPreferences/record_preferences.dart';

part 'record_event.dart';
part 'record_state.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  RecordBloc() : super(RecordInitial()) {
    on<LoadRecordEvent>((event, emit) async {
      emit(RecordLoading());
      try {
        List<RecordAbsen> record =
            await RememberRecordPrefs.getRememberAbsensi();
        emit(RecordLoaded(record));
      } catch (e) {
        emit(RecordError(e.toString()));
      }
    });

    on<FilterRecordEvent>((event, emit) async {
      emit(RecordLoading());
      try {
        List<RecordAbsen> record =
            await RememberRecordPrefs.getRememberAbsensi();
        List<RecordAbsen> filteredRecord = record.where((record) {
          return record.kd_ket == event.filter;
        }).toList();
        emit(RecordLoaded(filteredRecord));
      } catch (e) {
        emit(RecordError(e.toString()));
      }
    });
  }
}
