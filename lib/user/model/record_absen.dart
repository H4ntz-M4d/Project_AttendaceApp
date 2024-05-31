class RecordAbsen {
  String nis;
  DateTime record;
  String ket;
  String namaKeterangan;

  RecordAbsen(this.nis, this.record, this.ket, this.namaKeterangan);

  factory RecordAbsen.fromJson(Map<String, dynamic> json) => RecordAbsen(
    json['nis'], 
    json['record'], 
    json['kode_keterangan'], 
    json['nama_keterangan'],
  );

  Map<String, dynamic> toJson() => {
    'nis': nis,
    'record': record,
    'kode_keterangan': ket,
    'nama_keterangan': namaKeterangan,
  };
}
