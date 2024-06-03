// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_attendance_app/Screen/record/record_screen.dart';
import 'package:project_attendance_app/user/authentication/forgot_password.dart';
import 'package:project_attendance_app/user/fragments/dashboard.dart';
import 'package:project_attendance_app/user/model/record_absen.dart';
import 'package:project_attendance_app/user/model/user.dart';
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:project_attendance_app/user/userPreferences/record_preferences.dart';
import 'package:project_attendance_app/user/userPreferences/user_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> loginUserNow() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      var res = await http.post(
        Uri.parse(API.login),
        body: {
          "nis": usernameController.text.trim(),
          "siswa_password": passwordController.text.trim(),
        },
      );

      if (res.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(res.body);
        print("Response status: ${res.statusCode}");
        print("Response body: ${res.body}");

        if (resBodyOfLogin["success"] == true) {
          Fluttertoast.showToast(msg: "Selamat anda berhasil Login.");

          var userData = resBodyOfLogin["userData"][0];
          userData.forEach((key, value) {
            print("$key: $value");
          });

          Siswa userInfo = Siswa.fromJson(resBodyOfLogin["userData"][0]);
          List<RecordAbsen> historyAbsensi = [];

          for (var history in resBodyOfLogin["userHistory"]) {
            historyAbsensi.add(RecordAbsen.fromJson(history));
          }

          await RememberUserPrefs.storeUserInfo(userInfo);
          await RememberRecordPrefs.saveRememberAbsensi(historyAbsensi);

          Get.offAll(() => const RecordPage());
        } else {
          Fluttertoast.showToast(msg: "Maaf tidak dapat Login, Coba Lagi.");
        }
      } else {
        Fluttertoast.showToast(msg: "Server error, Coba Lagi.");
      }
    } catch (error) {
      // Handle any errors that occurred during the http request
      print("Error: $error");
      Fluttertoast.showToast(msg: "Terjadi kesalahan, silakan coba lagi.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              left: -30,
              top: -29,
              child: Container(
                width: 120,
                height: 140,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
            ),
            Positioned(
              left: -52,
              top: -32,
              child: Container(
                width: 120,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  border: Border.all(color: Colors.white, width: 10),
                ),
              ),
            ),
            Column(
              children: [
                Center(
                  child: Container(
                    height: 350,
                    width: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        scale: 3.3,
                        image: AssetImage("images/polinema.png"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 50),
              margin: const EdgeInsets.only(top: 300),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 53,
                      child: TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'NIS/NIP',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "NIS/NIP tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 53,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => ForgotPasswordPage());
                        },
                        child: const Text(
                          "Lupa Password",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationThickness: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: loginUserNow,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
