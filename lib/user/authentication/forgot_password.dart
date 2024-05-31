import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xFFF5F5F5),
                      ),
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
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    height: 50,
                    width: 370,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(width: 0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: OutlinedButton(
                      onPressed: () {},
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
