// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_attendance_app/Screen/record/record_screen.dart';
import 'package:project_attendance_app/user/authentication/forgot_password.dart';
import 'package:project_attendance_app/user/model/guru.dart';
import 'package:project_attendance_app/user/model/record_absen.dart';
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:project_attendance_app/user/model/siswa.dart';
import 'package:project_attendance_app/user/model/user.dart';
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

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.body}");
      if (res.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(res.body);
        print("Response status: ${res.statusCode}");
        print("Response body: ${res.body}");

        if (resBodyOfLogin["success"] == true) {
          Fluttertoast.showToast(msg: "Selamat anda berhasil Login.");

          var userData = resBodyOfLogin["userData"];
          userData.forEach((key, value) {
            print("$key: $value");
          });

          if (resBodyOfLogin["userData"]["role"] == "guru") {
            User userInfo = Guru.fromJson(resBodyOfLogin["userData"]);
            await RememberUserPrefs.storeUserInfo(userInfo);
          } else if (resBodyOfLogin["userData"]["role"] == "siswa") {
            User userInfo = Siswa.fromJson(resBodyOfLogin["userData"]);
            await RememberUserPrefs.storeUserInfo(userInfo);

            // Menyimpan gambar profil
          String? base64Image = resBodyOfLogin["userData"]["profile_image"];
            if (base64Image != null && base64Image.isNotEmpty) {
              Uint8List imageBytes = base64Decode(base64Image);
              await RememberUserPrefs.storeProfileImage(imageBytes);
            }
          }

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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: Container(
                  color: Colors.blue, // Set background color to blue
                ),
              ),
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Image.asset(
                          'images/Ellipse2.png',
                          height: 244,
                          width: 376,
                        ),
                      ),
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                          child: Container(
                            width: 400,
                            height: 400,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 70,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    'images/LogoSplash.png',
                    width: 250,
                    height: 250,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.only(top: 300),
                height: MediaQuery.of(context).size.height / 1.53,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(5, 0),
                    )
                  ],
                ),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            'NIS/NIP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: usernameController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "NIS/NIP tidak boleh kosong";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            'Password',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                // errorText: _passwordError,
                                // errorStyle: const TextStyle(height: 0),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
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
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextButton(
                            onPressed: () {
                              Get.to(() => const ForgotPasswordPage());
                            },
                            child: const Text(
                              "Lupa Password ?",
                              style: TextStyle(
                                color: Color(0xFFFF9900),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                decorationThickness: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 90),
                      Center(
                        child: ElevatedButton(
                          onPressed: loginUserNow,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
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
      ),
    );
  }
}
