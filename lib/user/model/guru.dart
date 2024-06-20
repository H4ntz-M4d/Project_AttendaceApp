import 'package:project_attendance_app/user/model/user.dart';

class Guru implements User {
  String nip;
  String nik;
  String nuptk;
  String nama;
  String jkel;
  String alamat;
  String tmpt_lahir;
  String tgl_lahir;
  String guru_status;
  String phone;
  String agama;
  String guru_password;
  String guru_email;
  String verifikasi_kode;
  String role;

  Guru({
    required this.nip,
    required this.nik,
    required this.nuptk,
    required this.nama,
    required this.jkel,
    required this.alamat,
    required this.tmpt_lahir,
    required this.tgl_lahir,
    required this.guru_status,
    required this.phone,
    required this.agama,
    required this.guru_password,
    required this.guru_email,
    required this.verifikasi_kode,
    required this.role,
  });

  // Factory constructor untuk membuat instance dari JSON
  factory Guru.fromJson(Map<String, dynamic> json) {
    return Guru(
      nip: json['nip'] ?? '',
      nik: json['nik'] ?? '',
      nuptk: json['nuptk'] ?? '',
      nama: json['nama'] ?? '',
      jkel: json['jkel'] ?? '',
      alamat: json['alamat'] ?? '',
      tmpt_lahir: json['tmpt_lahir'] ?? '',
      tgl_lahir: json['tgl_lahir'] ?? '',
      guru_status: json['guru_status'] ?? '',
      phone: json['phone'] ?? '',
      agama: json['agama'] ?? '',
      guru_password: json['guru_password'] ?? '',
      guru_email: json['guru_email'] ?? '',
      verifikasi_kode: json['verifikasi_kode'] ?? '',
      role: json['role'] ?? '',
    );
  }

  // Method untuk mengonversi instance ke JSON
  Map<String, dynamic> toJson() {
    return {
      'nip': nip,
      'nik': nik,
      'nuptk': nuptk,
      'nama': nama,
      'jkel': jkel,
      'alamat': alamat,
      'tmpt_lahir': tmpt_lahir,
      'tgl_lahir': tgl_lahir,
      'guru_status': guru_status,
      'phone': phone,
      'agama': agama,
      'guru_password': guru_password,
      'guru_email': guru_email,
      'verifikasi_kode': verifikasi_kode,
      'role': role,
    };
  }
}
