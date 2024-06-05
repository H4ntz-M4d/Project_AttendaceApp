import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_attendance_app/user/authentication/forgot_password.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          'Akun',
          style: GoogleFonts.plusJakartaSans(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 12, right: 8, left: 8),
          child: Column( 
            children: <Widget> [
            Text(
              'Detail Akun',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              title: Text(
                'Nama Pengguna',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.black,
                  fontSize: 15
                ),
              ),
              subtitle: Text(
                'Ahmad muhadi',
                style: GoogleFonts.plusJakartaSans(
                  color: Color.fromARGB(255, 105, 105, 105),
                  fontSize: 13
                ),
              ),
            ),

            InkWell(
              onTap: (){},
              splashColor: Colors.white30,
              child: ListTile(
                title: Text(
                  'Email',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.black,
                    fontSize: 15
                  ),
                ),
                subtitle: Text(
                  'muhadiahmad@gmail.com',
                  style: GoogleFonts.plusJakartaSans(
                    color: Color.fromARGB(255, 105, 105, 105),
                    fontSize: 13
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (ctx) => ForgotPasswordPage()
                ));
              },
              splashColor: Colors.white30,
              child: ListTile(
                title: Text(
                  'Password',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.black,
                    fontSize: 15
                  ),
                ),
                subtitle: Text(
                  'Klik untuk mengganti password',
                  style: GoogleFonts.plusJakartaSans(
                    color: Color.fromARGB(255, 105, 105, 105),
                    fontSize: 13
                  ),
                ),
              ),
            ),
            
          ],),
        ),
      ),
    );
  }
}