import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:project_attendance_app/user/model/guru.dart';
import 'package:project_attendance_app/user/model/profil_item.dart';
import 'package:project_attendance_app/user/model/siswa.dart';
import 'package:project_attendance_app/user/userPreferences/current_user.dart';
import 'package:project_attendance_app/user/userPreferences/user_preferences.dart'; // Import the profile image prefs
import 'package:http/http.dart' as http;

class BuildImage extends StatefulWidget {
  const BuildImage({super.key});

  @override
  State<BuildImage> createState() {
    return _BuildImageState();
  }
}

class _BuildImageState extends State<BuildImage> {
  Uint8List? _image;
  final CurrentUser _currentUser = Get.put(CurrentUser());

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    Uint8List? savedImage = await RememberUserPrefs.loadProfileImage();
    if (savedImage != null) {
      setState(() {
        _image = savedImage;
      });
    }
  }

  Future<void> _uploadImage(Uint8List image) async {
    String base64Image = base64Encode(image);

    var url = Uri.parse(API.uploadImage);
    var response = await http.post(url, body: {
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
      'profile_image': base64Image,
    });
    print(response.body);
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        print('Profile image saved successfully.');
      } else {
        print('Failed to save profile image: ${responseBody['message']}');
      }
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void _saveImage(Uint8List image) async {
    await RememberUserPrefs.storeProfileImage(image);
  }

  void getImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
      _saveImage(img);
      await _uploadImage(img);
    } else {
      print("No image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _image != null ?
          CircleAvatar(
            radius: 70,
            backgroundImage: MemoryImage(_image!),
          ) :
          const CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage('images/art.png'),
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.blue),
            child: IconButton(
              onPressed: getImage,
              icon: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}

