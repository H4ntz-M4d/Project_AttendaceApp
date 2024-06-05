// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_attendance_app/user/authentication/forgot_password.dart';
import 'package:project_attendance_app/user/fragments/dashboard.dart';
import 'package:project_attendance_app/user/model/user.dart';
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
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

          Siswa userInfo = Siswa.fromJson(resBodyOfLogin["userData"]);

          await RememberUserPrefs.storeUserInfo(userInfo);

          Future.delayed(const Duration(milliseconds: 2000), () {
            Get.offAll(() => DashboardSiswa());
          });
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
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
    );
  }
}

// @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Stack(
  //       children: [
  //         Container(
  //           color: const Color(0xFF2196FF),
  //         ),
  //         Positioned(
  //           top: 40,
  //           left: 0,
  //           right: 0,
  //           child: Center(
  //             child: Stack(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 40),
  //                   child: Image.asset(
  //                     'images/Ellipse2.png',
  //                     height: 244,
  //                     width: 376,
  //                   ),
  //                 ),
  //                 ClipRect(
  //                   child: BackdropFilter(
  //                     filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
  //                     child: Container(
  //                       width: 400,
  //                       height: 400,
  //                       color: Colors.transparent,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           top: 630,
  //           left: -150,
  //           right: 0,
  //           child: Center(
  //             child: Stack(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 50),
  //                   child: Image.asset(
  //                     'images/Ellipse2.png',
  //                     height: 244,
  //                     width: 376,
  //                   ),
  //                 ),
  //                 ClipRect(
  //                   child: BackdropFilter(
  //                     filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
  //                     child: Container(
  //                       width: 400,
  //                       height: 400,
  //                       color: Colors.transparent,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           top: 70,
  //           left: 0,
  //           right: 0,
  //           child: Center(
  //             child: Image.asset(
  //               'images/LogoSplash.png',
  //               width: 250,
  //               height: 250,
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           top: 300,
  //           left: 5,
  //           right: 5,
  //           child: Container(
  //             height: MediaQuery.of(context).size.height / 1.53,
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(20),
  //               boxShadow: const [
  //                 BoxShadow(
  //                   color: Colors.black26,
  //                   blurRadius: 10,
  //                   offset: Offset(5, 0),
  //                 )
  //               ],
  //             ),
  //             child: Form(
  //               key: formKey,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   const Padding(
  //                     padding: EdgeInsets.only(top: 20),
  //                     child: Text(
  //                       'Sign In',
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 20,
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 40),
  //                   const Align(
  //                     alignment: Alignment.centerLeft,
  //                     child: Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 15),
  //                       child: Text(
  //                         'NIS/NIP',
  //                         style: TextStyle(
  //                             fontSize: 16, fontWeight: FontWeight.bold),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 10, right: 25),
  //                     child: SizedBox(
  //                       height: 45,
  //                       child: TextFormField(
  //                         controller: usernameController,
  //                         decoration: const InputDecoration(
  //                           border: OutlineInputBorder(
  //                             borderRadius:
  //                                 BorderRadius.all(Radius.circular(20)),
  //                           ),
  //                         ),
  //                         validator: (value) {
  //                           if (value == null || value.isEmpty) {
  //                             return "NIS/NIP tidak boleh kosong";
  //                           }
  //                           return null;
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 35),
  //                   const Align(
  //                     alignment: Alignment.centerLeft,
  //                     child: Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 15),
  //                       child: Text(
  //                         'Password',
  //                         style: TextStyle(
  //                             fontSize: 16, fontWeight: FontWeight.bold),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 10, right: 25),
  //                     child: SizedBox(
  //                       height: 45,
  //                       child: TextFormField(
  //                         controller: passwordController,
  //                         obscureText: !_isPasswordVisible,
  //                         decoration: InputDecoration(
  //                           border: const OutlineInputBorder(
  //                             borderRadius:
  //                                 BorderRadius.all(Radius.circular(20)),
  //                           ),
  //                           suffixIcon: IconButton(
  //                             icon: Icon(
  //                               _isPasswordVisible
  //                                   ? Icons.visibility
  //                                   : Icons.visibility_off,
  //                             ),
  //                             onPressed: () {
  //                               setState(() {
  //                                 _isPasswordVisible = !_isPasswordVisible;
  //                               });
  //                             },
  //                           ),
  //                         ),
  //                         validator: (value) {
  //                           if (value == null || value.isEmpty) {
  //                             return 'Password tidak boleh kosong';
  //                           }
  //                           return null;
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                   Align(
  //                     alignment: Alignment.centerLeft,
  //                     child: Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 10),
  //                       child: TextButton(
  //                         onPressed: () {
  //                           Get.to(() => ForgotPasswordPage());
  //                         },
  //                         child: const Text(
  //                           "Lupa Password ?",
  //                           style: TextStyle(
  //                             color: Color(0xFFFF9900),
  //                             fontSize: 15,
  //                             fontWeight: FontWeight.bold,
  //                             decorationThickness: 1.5,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 90),
  //                   Center(
  //                     child: ElevatedButton(
  //                       onPressed: loginUserNow,
  //                       style: ElevatedButton.styleFrom(
  //                         minimumSize: const Size(150, 50),
  //                         backgroundColor: Colors.blue,
  //                       ),
  //                       child: const Text(
  //                         'Sign In',
  //                         style: TextStyle(
  //                             fontSize: 18,
  //                             color: Colors.white,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
            // Positioned(
            //   left: -30,
            //   top: -29,
            //   child: Container(
            //     width: 120,
            //     height: 140,
            //     decoration: const BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: Colors.blue,
            //     ),
            //   ),
            // ),
            // Positioned(
            //   left: -52,
            //   top: -32,
            //   child: Container(
            //     width: 120,
            //     height: 140,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: Colors.blue,
            //       border: Border.all(color: Colors.white, width: 10),
            //     ),
            //   ),
            // ),
            // Column(
            //   children: [
            //     Center(
            //       child: Container(
            //         height: 350,
            //         width: 200,
            //         decoration: const BoxDecoration(
            //           image: DecorationImage(
            //             scale: 3.3,
            //             image: AssetImage("images/polinema.png"),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 50),
//               margin: const EdgeInsets.only(top: 300),
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Sign In",
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     SizedBox(
//                       height: 53,
//                       child: TextFormField(
//                         controller: usernameController,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'NIS/NIP',
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "NIS/NIP tidak boleh kosong";
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     SizedBox(
//                       height: 53,
//                       child: TextFormField(
//                         controller: passwordController,
//                         obscureText: !_isPasswordVisible,
//                         decoration: InputDecoration(
//                           border: const OutlineInputBorder(),
//                           labelText: 'Password',
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _isPasswordVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _isPasswordVisible = !_isPasswordVisible;
//                               });
//                             },
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Password tidak boleh kosong';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Center(
//                       child: TextButton(
//                         onPressed: () {
//                           Get.to(() => ForgotPasswordPage());
//                         },
//                         child: const Text(
//                           "Lupa Password",
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                             decoration: TextDecoration.underline,
//                             decorationThickness: 1.5,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Center(
//                       child: ElevatedButton(
//                         onPressed: loginUserNow,
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: const Size(150, 50),
//                         ),
//                         child: const Text(
//                           'Login',
//                           style: TextStyle(
//                               fontSize: 18,
//                               color: Colors.blue,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
