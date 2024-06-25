import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:project_attendance_app/user/authentication/login_layout.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String nis;
  const ResetPasswordScreen({super.key, required this.nis});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formkey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> _submitNewPassword() async {
    if (formkey.currentState!.validate()) {
      if (newPasswordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Password tidak sama",
              style: TextStyle(color: Colors.red),
            ),
            backgroundColor: Colors.white,
          ),
        );
        return;
      }

      try {
        final response = await http.post(
          Uri.parse(API.resetPassword),
          body: {
            'nis': widget.nis,
            'password': newPasswordController.text.trim(),
          },
        );
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Kata Sandi Berhasil Diubah',
                style: TextStyle(color: Colors.blue),
              ),
              backgroundColor: Colors.white,
            ),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                responseData['message'],
                style: const TextStyle(color: Colors.red),
              ),
              backgroundColor: Colors.white,
            ),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi Kesalahan Silahkan Coba Lagi')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New Password',
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password Baru',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukkan Password Baru Anda';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Confirm Password',
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Konfirmasi Password Baru Anda';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 70),
              Container(
                height: 50,
                width: 370,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(width: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: OutlinedButton(
                  onPressed: _submitNewPassword,
                  child: const Center(
                    child: Text(
                      'Submit',
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
