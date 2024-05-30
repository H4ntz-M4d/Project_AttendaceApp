class Siswa {
  final String nis;
  final String nama;
  final String kodeKelas;
  final String kodeJurusan;
  final String jkel;
  final String agama;
  final String alamat;
  final DateTime tglLahir;
  final String siswaPassword;

  Siswa({
    required this.nis,
    required this.nama,
    required this.kodeKelas,
    required this.kodeJurusan,
    required this.jkel,
    required this.agama,
    required this.alamat,
    required this.tglLahir,
    required this.siswaPassword,
  });

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      nis: json['nis'],
      nama: json['nama'] ?? '', // Handle nullable fields
      kodeKelas: json['kode_kelas'] ?? '',
      kodeJurusan: json['kode_jurusan'] ?? '',
      jkel: json['jkel'] ?? '',
      agama: json['agama'] ?? '',
      alamat: json['alamat'] ?? '',
      tglLahir: json['tgl_lahir'] != null
          ? DateTime.parse(json['tgl_lahir'])
          : DateTime.now(), // Parse date from string
      siswaPassword: json['siswa_password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'nama': nama,
      'kode_kelas': kodeKelas,
      'kode_jurusan': kodeJurusan,
      'jkel': jkel,
      'agama': agama,
      'alamat': alamat,
      'tgl_lahir': tglLahir.toIso8601String(), // Convert DateTime to string
      'siswa_password': siswaPassword,
    };
  }

  // Getters
  String get getNis => nis;
  String get getNama => nama;
  String get getKodeKelas => kodeKelas;
  String get getKodeJurusan => kodeJurusan;
  String get getJkel => jkel;
  String get getAgama => agama;
  String get getAlamat => alamat;
  DateTime get getTglLahir => tglLahir;
  String get getSiswaPassword => siswaPassword;
}
