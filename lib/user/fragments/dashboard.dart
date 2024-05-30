import 'package:flutter/material.dart';
import 'package:project_attendance_app/user/model/absensi_siswa.dart';
import 'package:project_attendance_app/user/userPreferences/present_preference.dart';

class DashboardSiswa extends StatelessWidget {
  Future<List<AbsensiSiswa>> getUser() async {
    return await RememberPresentPrefs.getRememberAbsensi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Siswa'),
      ),
      body: FutureBuilder<List<AbsensiSiswa>>(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            List<AbsensiSiswa> absensi = snapshot.data!;
            return ListView.builder(
              itemCount: absensi.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title:
                      Text('Kode Keterangan: ${absensi[index].kodeKeterangan}'),
                  subtitle: Text('NIS: ${absensi[index].nis}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
