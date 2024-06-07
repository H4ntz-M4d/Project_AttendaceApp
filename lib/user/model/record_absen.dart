class RecordAbsen {
  String id_absen;
  String nis;
  DateTime record;
  String kd_ket;
  String namaKeterangan;

  RecordAbsen({
    required this.id_absen,
    required this.nis,
    required this.record,
    required this.kd_ket,
    required this.namaKeterangan,
  });

  factory RecordAbsen.fromJson(Map<String, dynamic> json) {
    return RecordAbsen(
      id_absen: json['id_absen'].toString() ?? '',
      nis: json['nis'] ?? '',
      record: DateTime.parse(json['kalender_absensi']),
      kd_ket: json['kode_keterangan'] ?? '',
      namaKeterangan: json['nama_keterangan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id_absen': id_absen,
        'nis': nis,
        'kalender_absensi': record.toIso8601String(),
        'kode_keterangan': kd_ket,
        'nama_keterangan': namaKeterangan,
  };
}
