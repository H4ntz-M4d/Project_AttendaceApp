import 'package:project_attendance_app/user/model/profil_item.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget{
  const EditScreen({super.key, required this.editProfile});
  
  final void Function(ProfilItem) editProfile;

  @override
  State<EditScreen> createState() {
    return _EditScreenState();
  }
}


class _EditScreenState extends State<EditScreen>{

  final _alamatController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _alamatController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveEditing(){
    final newAlamat = _alamatController.text;
    final newPhone = _phoneController.text;

  // Panggil callback untuk mengirim nilai nama dan nomor telepon
    widget.editProfile(ProfilItem(alamat: newAlamat, noHp: newPhone));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50, right: 40, left: 40),
      child: Column(children: [
        TextField(
          controller: _alamatController,
          maxLength: 50,
          decoration: const InputDecoration(
            label: Text('Alamat')
          ),
        ),
      
        TextField(
          controller: _phoneController,
          maxLength: 15,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            label: Text('No. Handphone')
          ),
        ),

        ElevatedButton(
          onPressed: () {
            _saveEditing();
            Navigator.pop(context);
          }, 
          child: const Text('Save')
          )
        ],
      ),
    );
  }
}