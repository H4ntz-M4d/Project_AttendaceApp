// ignore_for_file: library_private_types_in_public_api, camel_case_types

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../user/authentication/login_layout.dart';

class onBoarding3 extends StatefulWidget {
  const onBoarding3({super.key});

  @override
  _onBoarding3State createState() => _onBoarding3State();
}

class _onBoarding3State extends State<onBoarding3> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF2196FF),
          ),
          Positioned(
            top: 100,
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
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
                        width: screenWidth,
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
            top: 700,
            left: 0,
            right: -150,
            child: Center(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(50),
                    child: Image.asset(
                      'images/Ellipse2.png',
                      height: 244,
                      width: 376,
                    ),
                  ),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                      child: Container(
                        width: 500,
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
            top: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Transform.scale(
                scale: 1.1,
                child: Image.asset('images/Siswa.png'),
              ),
            ),
          ),
          const Positioned(
            top: 580,
            right: 0,
            left: 0,
            child: Center(
              child: Text(
                'Selamat Datang',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Positioned(
            top: 650,
            right: 40,
            left: 40,
            child: Center(
              child: Text(
                'Semoga aplikasi ini dapat membantu anda dalam membentuk karakter diri yang disiplin..',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 818,
            right: -43,
            left: 0,
            child: Center(
              child: Container(
                width: 28,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          Positioned(
            top: 818,
            right: 0,
            left: -43,
            child: Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            top: 818,
            right: 0,
            left: -10,
            child: Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            top: 800,
            right: -310,
            left: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const LoginPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;
                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          }));
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 41,
                      height: 41,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 30,
                      color: Color(0xFF2196FF),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
