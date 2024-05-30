class AbsensiSiswa {
  String idAbsensi;
  String nis;
  DateTime kalenderAbsensi;
  String kodeKeterangan;

  AbsensiSiswa({
    required this.idAbsensi,
    required this.nis,
    required this.kalenderAbsensi,
    required this.kodeKeterangan,
  });

  factory AbsensiSiswa.fromJson(Map<String, dynamic> json) {
    return AbsensiSiswa(
      idAbsensi: json['id_absensi'].toString(),
      nis: json['nis'],
      kalenderAbsensi: DateTime.parse(json['kalender_absensi']),
      kodeKeterangan: json['kode_keterangan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_absensi': idAbsensi,
      'nis': nis,
      'kalender_absensi': kalenderAbsensi.toIso8601String(),
      'kode_keterangan': kodeKeterangan,
    };
  }

  String get _nis => nis;
  DateTime get _kalenderAbsensi => kalenderAbsensi;
  String get _kodeKeterangan => kodeKeterangan;
}
