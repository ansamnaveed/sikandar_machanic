// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:mechanic/login_screen.dart';
import 'package:mechanic/mechanic/profile_screens_m/change_password_m.dart';
import 'package:mechanic/mechanic/profile_screens_m/edit_profile_m.dart';
import 'package:mechanic/widgets/AppButton/AppButton.dart';
import 'package:mechanic/widgets/AppDialog/app_dialog.dart';
import 'package:mechanic/widgets/AppText/AppText.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as p;

class MechanicsProfileScreen extends StatefulWidget {
  ScrollController scrollcontroller = ScrollController();
  MechanicsProfileScreen({Key? key, required this.scrollcontroller})
      : super(key: key);

  @override
  State<MechanicsProfileScreen> createState() => _MechanicsProfileScreenState();
}

class _MechanicsProfileScreenState extends State<MechanicsProfileScreen> {
  String? fullname;
  String fileUrl = "null";
  String? phone;

  final FirebaseAuth auth = FirebaseAuth.instance;

  void getData() async {
    final User? user = auth.currentUser;
    setState(() {
      showSpinner = true;
    });
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection("Mechanics")
        .doc(user!.email)
        .get();
    setState(() {
      fullname = variable['firstname'];
      phone = variable['phone'];
      fileUrl = variable['imageUrl'];
    });
    setState(() {
      showSpinner = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  bool showSpinner = false;

  File? profileImage;

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null) {
      setState(() {
        profileImage = File(result.files.first.path!);
      });
      uploadImage(profileImage);
    } else {
      return;
    }
  }

  uploadImage(File? profile) async {
    setState(() {
      showSpinner = true;
    });
    final User? user = auth.currentUser;
    final ref = storage.FirebaseStorage.instance.ref().child('images').child(
        '${DateTime.now().toIso8601String() + p.basename(profile!.path)}');

    final result = await ref.putFile(File(profile.path));
    fileUrl = await result.ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection("Mechanics")
        .doc(user!.email)
        .update(
      {
        "imageUrl": await result.ref.getDownloadURL(),
      },
    );
    getData();
    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  pickFile();
                },
                child: Container(
                  padding: fileUrl == "null"
                      ? EdgeInsets.all(10)
                      : EdgeInsets.all(0),
                  height: Get.width / 4,
                  width: Get.width / 4,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: fileUrl == "null"
                      ? Image(
                          image: AssetImage('assets/images/user.png'),
                          color: Colors.white,
                        )
                      : Image(
                          image: NetworkImage(fileUrl),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Txt(
                text: '$fullname',
                size: 30,
                bold: true,
              ),
              Txt(
                text: phone.toString(),
                size: 20,
              ),
              SizedBox(height: 20),
              Card(
                elevation: 5,
                child: ListTile(
                  onTap: () {
                    Get.to(
                      ChangePasswordM(),
                    );
                  },
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  leading: Icon(Icons.lock_rounded),
                  title: Txt(text: 'Change Password'),
                ),
              ),
              Card(
                elevation: 5,
                child: ListTile(
                  onTap: (() => Get.to(
                        () => EditProfileM(),
                      )),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  leading: Icon(Icons.edit_rounded),
                  title: Txt(text: 'Edit Profile'),
                ),
              ),
              Card(
                elevation: 5,
                child: ListTile(
                  leading: Icon(Icons.settings_rounded),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  title: Txt(text: 'Change Service'),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              AppBtn(
                child: Txt(
                  text: 'Logout',
                ),
                onPressed: () {
                  Get.dialog(
                    AppDialog(
                      onTapOk: () async {
                        await FirebaseAuth.instance.signOut().then(
                              (value) => Get.offAll(
                                LoginScreen(),
                              ),
                            );
                      },
                      title: 'Logout?',
                      subtitle: 'Are you sure to logout the app.',
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
