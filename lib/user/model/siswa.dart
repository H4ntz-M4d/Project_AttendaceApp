import 'dart:convert';
import 'dart:ffi';
import 'package:project_attendance_app/user/model/user.dart';

class Siswa implements User {
  String nis;
  String siswaPassword;
  String nama;
  String email;
  String tmpt_lahir;
  String tgl_lahir;
  String alamat;
  String phone;
  String role;

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      nis: json['nis'] ?? '',
      siswaPassword: json['siswa_password'] ?? '',
      nama: json['nama'] ?? '',
      email: json['siswa_email'] ?? '',
      tmpt_lahir: json['tmpt_lahir'] ?? '', // Provide default value if null
      tgl_lahir: json['tgl_lahir'] ?? '',
      alamat: json['alamat'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Siswa(
      {required this.nis,
      required this.siswaPassword,
      required this.nama,
      required this.email,
      required this.tmpt_lahir,
      required this.tgl_lahir,
      required this.alamat,
      required this.phone,
      required this.role});

  Map<String, dynamic> toJson() => {
        'nis': nis,
        'siswa_password': siswaPassword,
        'nama': nama,
        'siswa_email': email,
        'tmpt_lahir': tmpt_lahir,
        'tgl_lahir': tgl_lahir,
        'alamat': alamat,
        'phone': phone,
        'role': role,
      };
}
