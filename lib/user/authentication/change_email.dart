import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:project_attendance_app/user/fragments/account_screen.dart';
import 'package:project_attendance_app/user/model/guru.dart';
import 'package:project_attendance_app/user/model/siswa.dart';
import 'package:http/http.dart' as http;
import 'package:project_attendance_app/user/userPreferences/current_user.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  _ChangeEmail createState() => _ChangeEmail();
}

class _ChangeEmail extends State<ChangeEmail> {
  final CurrentUser _currentUser = Get.put(CurrentUser());
  final List<TextEditingController> _kode =
      List.generate(4, (index) => TextEditingController());
  final TextEditingController oldEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  bool _isButtonDisabled = false;
  bool _isLoading = false;
  String _buttonText = 'Dapatkan Kode';

  Future<void> getVerificationCode() async {
    setState(() {
      _isButtonDisabled = true;
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse(API.sendEmailCode),
      body: {
        "nis": (_currentUser.user is Guru)
              ? (_currentUser.user as Guru).nip
              : (_currentUser.user is Siswa)
                  ? (_currentUser.user as Siswa).nis
                  : '',
        "role": (_currentUser.user is Guru)
              ? (_currentUser.user as Guru).role
              : (_currentUser.user is Siswa)
                  ? (_currentUser.user as Siswa).role
                  : '',
        'email_lama': oldEmailController.text.trim(),
      },
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        setState(() {
          _buttonText = 'Terkirim';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        setState(() {
          _buttonText = 'Tunggu';
        });

        Future.delayed(Duration(seconds: 5), () {
          setState(() {
            _isButtonDisabled = false;
            _buttonText = 'Dapatkan Kode';
          });
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim kode verifikasi.')),
      );

      setState(() {
        _buttonText = 'Tunggu';
      });

      // Disable button for 5 seconds
      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          _isButtonDisabled = false;
          _buttonText = 'Dapatkan Kode';
        });
      });
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> changeEmail() async {
    _showLoadingDialog(context);

    final verificationcode =
        _kode.map((controller) => controller.text).join('');
    final response = await http.post(
      Uri.parse(API.changeEmail),
      body: {
        "nis": (_currentUser.user is Guru)
              ? (_currentUser.user as Guru).nip
              : (_currentUser.user is Siswa)
                  ? (_currentUser.user as Siswa).nis
                  : '',
        "role": (_currentUser.user is Guru)
              ? (_currentUser.user as Guru).role
              : (_currentUser.user is Siswa)
                  ? (_currentUser.user as Siswa).role
                  : '',
        'verifikasi_kode': verificationcode,
        'email_baru': newEmailController.text
      },
    );

    _hideLoadingDialog(context);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
      Get.to(() => const AccountScreen());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengubah email.')),
      );
    }
  }

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
          'Ubah Email',
          style: GoogleFonts.plusJakartaSans(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Masukkan Email Lama',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: oldEmailController,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    width: 120,
                    decoration: BoxDecoration(
                      color: _isButtonDisabled ? Colors.grey : Colors.blue,
                      border: Border.all(width: 0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: OutlinedButton(
                      onPressed: _isButtonDisabled ? null : getVerificationCode,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isLoading)
                            Container(
                              height: 15,
                              width: 15,
                              margin: EdgeInsets.only(right: 10),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          if (!_isLoading)
                            Text(
                              _buttonText,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                      style: OutlinedButton.styleFrom(
                        side:
                            BorderSide.none, // Hapus border pada OutlinedButton
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  for (int i = 0; i < 4; i++)
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 40,
                            child: TextFormField(
                              controller: _kode[i],
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              keyboardType: TextInputType.number,
                              textInputAction: i < 3
                                  ? TextInputAction.next
                                  : TextInputAction.done,
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                } else {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              decoration: const InputDecoration(
                                counterText: "",
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10),
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Color(0xFFF5F5F5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Masukkan Email Baru',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: newEmailController,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 60),
              Container(
                height: 50,
                width: 370,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(width: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: OutlinedButton(
                  onPressed: changeEmail,
                  child: const Center(
                    child: Text(
                      'Ubah',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
