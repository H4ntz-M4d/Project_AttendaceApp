// ignore_for_file: camel_case_types
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:login_ui/user/authentication/login_layout.dart';
import 'package:login_ui/Screen/onBoarding/pageIndicator.dart';

class onBoarding extends StatefulWidget {
  const onBoarding({super.key});

  @override
  State<onBoarding> createState() => _onBoardingState();
}

class _onBoardingState extends State<onBoarding> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> _images = [
    "images/Siswas.png",
    "images/AbsensiElement.png",
    "images/Siswa.png",
  ];

  final List<String> _titles = [
    "Kedisiplinan Kunci Kesuksesan",
    "Cek Absensi Anda",
    "Selamat Datang",
  ];

  final List<String> _descriptions = [
    "Dengan kedisiplinan, kita membentuk kebiasaan yang membawa kita menuju impian.",
    "Aplikasi ini berfungsi untuk memonitor absensi anda saat kegiatan belajar mengajar, Sehingga memotivasi anda untuk lebih disiplin.",
    "Semoga aplikasi ini dapat membantu anda dalam membentuk karakter diri yang disiplin.",
  ];

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xFF2196FF),
      body: Stack(
        children: [
          AnimatedPositioned(
            //first decoration
            top: _currentIndex == 0 ? 100 : (_currentIndex == 1 ? 100 : 100),
            left: 0,
            right: _currentIndex == 0 ? 0 : (_currentIndex == 1 ? 0 : 50),
            duration: const Duration(milliseconds: 500),
            child: Center(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Image.asset(
                      'images/Ellipse2.png',
                      height: 244,
                      width: 376,
                    ),
                  ),
                  ClipRect(
                    //secondary decoration
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
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
          AnimatedPositioned(
            top: _currentIndex == 0 ? 500 : (_currentIndex == 1 ? 400 : 400),
            left: _currentIndex == 0 ? 0 : (_currentIndex == 0 ? 0 : -300),
            right: _currentIndex == 0 ? 0 : (_currentIndex == 1 ? -600 : 0),
            duration: const Duration(milliseconds: 500),
            child: Center(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Image.asset(
                      'images/Ellipse2.png',
                      height: 400,
                      width: 376,
                    ),
                  ),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
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
          PageView.builder(
            controller: _pageController,
            itemCount: 3,
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      _images[i],
                      height: 300,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _titles[i],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _descriptions[i],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: PageIndicator(
              pageCount: 3,
              currentIndex: _currentIndex,
            ),
          ),
          Positioned(
            bottom: 23,
            left: 0,
            right: 0,
            child: _currentIndex < _images.length - 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _navigateToLogin();
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ),
          Positioned(
            bottom: 15,
            left: 0,
            right: -300,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (_currentIndex < _images.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _navigateToLogin();
                  }
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
                    ),
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
