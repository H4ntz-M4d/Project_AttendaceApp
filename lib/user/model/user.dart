class Siswa {
  String nis;
  String siswaPassword;

  Siswa(
    this.nis,
    this.siswaPassword,
  );

  factory Siswa.fromJson(Map<String, dynamic> json) => Siswa(
        json['nis'],
        json['siswa_password'],
      );

  Map<String, dynamic> toJson() =>
      {'nis': nis, 'siswa_password': siswaPassword};
}
