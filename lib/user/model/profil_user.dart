import 'dart:convert';
import 'dart:ffi';

class ProfileUser {
  String nis;
  String siswaPassword;
  String nama;
  String tmpt_lahir;
  String tgl_lahir;
  String alamat;
  String phone;

  ProfileUser(this.nis, this.siswaPassword, this.nama, this.tmpt_lahir,
      this.tgl_lahir, this.alamat, this.phone);

  factory ProfileUser.fromJson(Map<String, dynamic> json) => ProfileUser(
      json['nis'],
      json['siswa_password'],
      json['nama'],
      json['tmpt_lahir'],
      json['tgl_lahir'],
      json['alamat'],
      json['phone']);

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
