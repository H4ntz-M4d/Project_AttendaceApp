import 'package:get/get.dart';
import 'package:project_attendance_app/user/model/profil_item.dart';
import 'package:flutter/material.dart';
import 'package:project_attendance_app/user/userPreferences/current_user.dart';

class EditPhone extends StatefulWidget{
  const EditPhone({super.key, required this.editProfile});
  
  final void Function(ProfilItem) editProfile;

  @override
  State<EditPhone> createState() {
    return _EditPhoneState();
  }
}

class _EditPhoneState extends State<EditPhone>{

  final _phoneController = TextEditingController();
  final CurrentUser _currentUser = Get.put(CurrentUser());


  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _saveEditing(){
    final newPhone = _phoneController.text;

  // Panggil callback untuk mengirim nilai nama dan nomor telepon
    widget.editProfile(ProfilItem(alamat: _currentUser.user.alamat, noHp: newPhone));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50, right: 40, left: 40),
      child: Column(children: [
        TextField(
          controller: _phoneController,
          maxLength: 50,
          decoration: const InputDecoration(
            label: Text('Phone')
          ),
        ),

        Row(children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            child: const Text('Cancel')
          ),

          const SizedBox(width: 20,),

          ElevatedButton(
            onPressed: () {
              _saveEditing();
              Navigator.pop(context);
            }, 
            child: const Text('Save')
          ),
        ],
        ),

        ],
      ),
    );
  }
}