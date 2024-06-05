import 'dart:convert';
import 'dart:ffi';

class Siswa {
  String nis;
  String siswaPassword;
  String nama;
  String tmpt_lahir;
  String tgl_lahir;
  String alamat;
  String phone;

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      nis: json['nis'] ?? '',
      siswaPassword: json['siswa_password'] ?? '',
      nama: json['nama'] ?? '',
      tmpt_lahir: json['tmpt_lahir'] ?? '', // Provide default value if null
      tgl_lahir: json['tgl_lahir'] ?? '',
      alamat: json['alamat'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Siswa(
      {required this.nis,
      required this.siswaPassword,
      required this.nama,
      required this.tmpt_lahir,
      required this.tgl_lahir,
      required this.alamat,
      required this.phone});

  Map<String, dynamic> toJson() => {
        'nis': nis,
        'siswa_password': siswaPassword,
        'nama': nama,
        'tmpt_lahir': tmpt_lahir,
        'tgl_lahir': tgl_lahir,
        'alamat': alamat,
        'phone': phone
      };
}
