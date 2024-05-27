class Siswa {
  final String nis;
  final String siswaPassword;

  Siswa({
    required this.nis,
    required this.siswaPassword,
  });

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      nis: json['nis'],
      siswaPassword: json['siswa_password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'nis': nis, 'siswa_password': siswaPassword};
  }
}
