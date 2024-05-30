import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_attendance_app/user/model/absensi_siswa.dart';
import 'package:project_attendance_app/user/userPreferences/present_preference.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on<LoadAbsensiEvent>((event, emit) async {
      emit(HistoryLoading());
      try {
        List<AbsensiSiswa> absensi =
            await RememberPresentPrefs.getRememberAbsensi();
        emit(HistoryLoaded(absensi));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });

    on<FilterAbsensiEvent>((event, emit) async {
      emit(HistoryLoading());
      try {
        List<AbsensiSiswa> absensi =
            await RememberPresentPrefs.getRememberAbsensi();
        List<AbsensiSiswa> filteredAbsensi = absensi.where((absensi) {
          return absensi.kodeKeterangan == event.filter;
        }).toList();
        emit(HistoryLoaded(filteredAbsensi));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });
  }
}
