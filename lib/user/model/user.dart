import 'dart:convert';
import 'dart:ffi';

class Siswa {
  String nis;
  String siswaPassword;
  String nama;
  String ttl;
  String alamat;
  String phone;

  Siswa(this.nis, this.siswaPassword, this.nama, this.ttl, this.alamat, this.phone);

  factory Siswa.fromJson(Map<String, dynamic> json) => Siswa(json['nis'],
      json['siswa_password'], json['nama'], json['tgl_lahir'], json['alamat'], json['phone']);

  Map<String, dynamic> toJson() => {
        'nis': nis,
        'siswa_password': siswaPassword,
        'nama': nama,
        'tgl_lahir': ttl,
        'alamat': alamat,
        'phone': phone
      };
}
