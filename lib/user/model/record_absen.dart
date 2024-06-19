class RecordAbsen {
  String id_absen;
  String nis;
  String kode_mapel;
  DateTime record;
  String kd_ket;
  String namaKeterangan;

  RecordAbsen({
    required this.id_absen,
    required this.nis,
    required this.kode_mapel,
    required this.record,
    required this.kd_ket,
    required this.namaKeterangan,
  });

  factory RecordAbsen.fromJson(Map<String, dynamic> json) {
    return RecordAbsen(
      id_absen: json['id_absensi'].toString() ?? '',
      nis: json['nis'] ?? '',
      kode_mapel: json['kode_mapel'] ?? '',
      record: DateTime.parse(json['kalender_absensi']),
      kd_ket: json['kode_keterangan'] ?? '',
      namaKeterangan: json['nama_keterangan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id_absensi': id_absen,
        'nis': nis,
        'kode_mapel': kode_mapel,
        'kalender_absensi': record.toIso8601String(),
        'kode_keterangan': kd_ket,
        'nama_keterangan': namaKeterangan,
      };
}
