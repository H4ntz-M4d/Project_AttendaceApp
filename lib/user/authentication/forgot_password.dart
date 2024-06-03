import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:project_attendance_app/user/authentication/new_password_screen.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final userIdController = TextEditingController();
  final tglLahirController = TextEditingController();
  final emailController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      _showLoadingDialog(context);
      try {
        final tglLahir = DateFormat('yyyy-MM-dd').format(selectedDate);
        final response = await http.post(
          Uri.parse(API.forgotPassword),
          body: {
            'nis': userIdController.text.trim(),
            'tgl_lahir': tglLahir,
            'siswa_email': emailController.text.trim(),
          },
        );

        final responseData = json.decode(response.body);
        _hideLoadingDialog(context);

        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                responseData['message'],
                style: TextStyle(color: Colors.blue),
              ),
              backgroundColor: Color(0xFFF5F5F5),
            ),
          );
          _inputVerifikasiKode(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                responseData['message'],
                style: TextStyle(color: Colors.red),
              ),
              backgroundColor: Color(0xFFF5F5F5),
            ),
          );
        }
      } catch (error) {
        _hideLoadingDialog(context);
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan. Silakan coba lagi.')),
        );
      }
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        tglLahirController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _inputVerifikasiKode(BuildContext context) {
    final TextEditingController code1 = TextEditingController();
    final TextEditingController code2 = TextEditingController();
    final TextEditingController code3 = TextEditingController();
    final TextEditingController code4 = TextEditingController();

    void _submitCode() async {
      String code = code1.text + code2.text + code3.text + code4.text;
      bool isValid = await submitVerificationCode(code);
      if (isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Kode Verifikasi Benar',
              style: TextStyle(color: Colors.blue),
            ),
            backgroundColor: Colors.white,
          ),
        );
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ResetPasswordScreen(nis: userIdController.text.trim()),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Kode Verifikasi Salah',
              style: TextStyle(color: Colors.red),
            ),
            backgroundColor: Colors.white,
          ),
        );
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Masukkan Kode Verifikasi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Masukkan 4 digit kode yang telah kami kirimkan ke email anda',
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _inputCodeField(code1, context),
                  _inputCodeField(code2, context),
                  _inputCodeField(code3, context),
                  _inputCodeField(code4, context),
                ],
              ),
              const SizedBox(height: 30)
            ],
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: _submitCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _inputCodeField(
      TextEditingController controller, BuildContext context) {
    return Container(
      width: 40,
      child: TextFormField(
        controller: controller,
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  Future<bool> submitVerificationCode(String code) async {
    try {
      final response = await http.post(
        Uri.parse(API.verifyCode),
        body: {'nis': userIdController.text.trim(), 'code': code},
      );
      final responseData = json.decode(response.body);

      return responseData['status'] == 'success';
    } catch (error) {
      print('Error:  $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Container(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Masukkan NIS, Tanggal Lahir, dan Email anda untuk proses verifikasi, kami akan mengirimkan kode ke email anda',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'NIS/NIP',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    //nis and nip field
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.3,
                      ),
                      color: Color(0xFFF5F5F5),
                    ),
                    height: 50,
                    width: 370,
                    child: TextFormField(
                      controller: userIdController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xFFF5F5F5),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Masukkan NIS/NIP';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Tanggal Lahir',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    //tgl_lahir field
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.3,
                      ),
                      color: Color(0xFFF5F5F5),
                    ),
                    height: 50,
                    width: 370,
                    child: TextFormField(
                      controller: tglLahirController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectDate(context);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Isi Tanggal Lahir";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    //nis and nip field
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.3,
                      ),
                      color: Color(0xFFF5F5F5),
                    ),
                    height: 50,
                    width: 370,
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xFFF5F5F5),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Masukkan Email';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    height: 50,
                    width: 370,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(width: 0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: OutlinedButton(
                      onPressed: _submitForm,
                      child: const Center(
                        child: Text(
                          'Continue',
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
        ),
      ),
    );
  }
}
