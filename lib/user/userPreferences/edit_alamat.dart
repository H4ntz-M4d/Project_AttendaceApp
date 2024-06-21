import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:project_attendance_app/user/model/guru.dart';
import 'package:project_attendance_app/user/model/profil_item.dart';
import 'package:project_attendance_app/user/model/siswa.dart';
import 'package:project_attendance_app/user/userPreferences/current_user.dart';

class EditAlamat extends StatefulWidget {
  const EditAlamat({super.key, required this.editProfile});

  final void Function(ProfilItem) editProfile;

  @override
  State<EditAlamat> createState() {
    return _EditAlamatState();
  }
}

class _EditAlamatState extends State<EditAlamat> {
  late TextEditingController _alamatController;
  final CurrentUser _currentUser = Get.put(CurrentUser());

  @override
  void initState() {
    super.initState();
    String initialAlamat = '';
    if (_currentUser.user is Guru) {
      initialAlamat = (_currentUser.user as Guru).alamat;
    } else if (_currentUser.user is Siswa) {
      initialAlamat = (_currentUser.user as Siswa).alamat;
    }
    _alamatController = TextEditingController(text: initialAlamat);
  }

  @override
  void dispose() {
    _alamatController.dispose();
    super.dispose();
  }

  void _saveEditing() {
    final newAlamat = _alamatController.text;

    // Panggil callback untuk mengirim nilai alamat dan nomor telepon
    if (_currentUser.user is Guru) {
      widget.editProfile(ProfilItem(
          alamat: newAlamat, noHp: (_currentUser.user as Guru).phone));
    } else if (_currentUser.user is Siswa) {
      widget.editProfile(ProfilItem(
          alamat: newAlamat, noHp: (_currentUser.user as Siswa).phone));
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50, right: 40, left: 40),
      child: Column(
        children: [
          TextField(
            controller: _alamatController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text('Alamat')),
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    _saveEditing();
                    Navigator.pop(context);
                  },
                  child: const Text('Save')),
            ],
          ),
        ],
      ),
    );
  }
}
