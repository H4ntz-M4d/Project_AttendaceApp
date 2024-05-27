// ignore_for_file: camel_case_types, use_super_parameters, library_private_types_in_public_api

import 'dart:ui';
import 'package:flutter/material.dart';

class onBoarding2 extends StatefulWidget {
  const onBoarding2({Key? key}) : super(key: key);

  @override
  _onBoarding3State createState() => _onBoarding3State();
}

class _onBoarding3State extends State<onBoarding2> {
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
            top: 400,
            left: 0,
            right: -350,
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
            top: 180,
            left: 0,
            right: 0,
            child: Center(
              child: Transform.scale(
                scale: 1,
                child: Image.asset('images/AbsensiElement.png'),
              ),
            ),
          ),
          const Positioned(
            top: 550,
            right: 100,
            left: 100,
            child: Center(
              child: Text(
                'Cek Absensi Anda',
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
                'Aplikasi ini berfungsi untuk memonitor absensi anda saat kegiatan belajar mengajar, Sehingga memotivasi anda untuk lebih disiplin..',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Positioned(
            top: 807,
            right: 0,
            left: -320,
            child: Center(
              child: Text(
                'Skip',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 818,
            right: 0,
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
            right: -43,
            left: 0,
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
        ],
      ),
    );
  }
}
