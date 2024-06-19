import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});

  final webPolinemaPamekasan = Uri.parse('https://pamekasan.polinema.ac.id/');
  final igPolinemaPamekasan = Uri.parse('https://www.instagram.com/polinema.psdku_pamekasan?igsh=cjhnMzQzNGdwM2t0');
  final noHp = Uri.parse('https://wa.me/+6281233560787');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Tentang Kami',
          style: GoogleFonts.plusJakartaSans(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 16), // Adjust vertical padding
            child: Container(
              width: 300,
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Center(
                    child: Text(
                      'Selamat Datang di Aplikasi Absensi Sekolah!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      '''Kami adalah mahasiswa Politeknik Negeri Malang, PSDKU Pamekasan, berkomitmen menghadirkan solusi teknologi untuk pendidikan. Kami menciptakan Aplikasi Absensi Sekolah untuk mempermudah pencatatan dan pemantauan kehadiran siswa secara digital. Fitur utama meliputi pencatatan kehadiran, laporan harian, mingguan, dan bulanan, serta keamanan data dengan enkripsi canggih. Aplikasi ini diharapkan dapat meningkatkan efisiensi administrasi sekolah. Terima kasih atas kepercayaannya, mari bersama menuju pendidikan yang lebih baik dan modern!''',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Contact Us',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(
                      height: 16), // Add spacing between text and icons
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Link(
                          uri: webPolinemaPamekasan,
                          target: LinkTarget.defaultTarget,
                          builder: (context, openLink) => TextButton(
                            onPressed: openLink,
                            child: const Icon(Icons.language),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Link(
                          uri: igPolinemaPamekasan,
                          target: LinkTarget.defaultTarget,
                          builder: (context, openLink) => TextButton(
                            onPressed: openLink,
                            child: const Icon(Icons.social_distance),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Link(
                          uri: noHp,
                          target: LinkTarget.defaultTarget,
                          builder: (context, openLink) => TextButton(
                            onPressed: openLink,
                            child: const Icon(Icons.phone),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
