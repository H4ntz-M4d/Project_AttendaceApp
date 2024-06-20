import 'package:get/get.dart';
import 'package:project_attendance_app/user/model/profil_item.dart';
import 'package:flutter/material.dart';
import 'package:project_attendance_app/user/userPreferences/current_siswa.dart';

class EditAlamat extends StatefulWidget {
  const EditAlamat({super.key, required this.editProfile});

  final void Function(ProfilItem) editProfile;

  @override
  State<EditAlamat> createState() {
    return _EditAlamatState();
  }
}

class _EditAlamatState extends State<EditAlamat> {
  final _alamatController = TextEditingController();
  final CurrentSiswa _currentUser = Get.put(CurrentSiswa());

  @override
  void dispose() {
    _alamatController.dispose();
    super.dispose();
  }

  void _saveEditing() {
    final newAlamat = _alamatController.text;

    // Panggil callback untuk mengirim nilai nama dan nomor telepon
    widget.editProfile(
        ProfilItem(alamat: newAlamat, noHp: _currentUser.user.phone));
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
