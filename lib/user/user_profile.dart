// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mechanic/widgets/AppButton/AppButton.dart';
import 'package:mechanic/widgets/AppDialog/app_dialog.dart';
import 'package:mechanic/widgets/AppText/AppText.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class UserProfileScreen extends StatefulWidget {
  ScrollController scrollcontroller = ScrollController();
  UserProfileScreen({Key? key, required this.scrollcontroller})
      : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String? fullname;
  String? fileUrl;

  final FirebaseAuth auth = FirebaseAuth.instance;

  void getData() async {
    setState(() {
      showSpinner = true;
    });
    final User? user = auth.currentUser;
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.email)
        .get();
    setState(() {
      fullname = variable['firstname'];
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
              Container(
                padding: EdgeInsets.all(10),
                height: Get.width / 4,
                width: Get.width / 4,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image(
                  image: AssetImage('assets/images/user.png'),
                  color: Colors.white,
                ),
              ),
              Txt(
                text: '$fullname',
                size: 30,
                bold: true,
              ),
              Txt(
                text: '+92 1234 567890',
                size: 20,
              ),
              SizedBox(height: 20),
              Card(
                elevation: 5,
                child: ListTile(
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  leading: Icon(Icons.lock_rounded),
                  title: Txt(text: 'Change Password'),
                ),
              ),
              Card(
                elevation: 5,
                child: ListTile(
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
                      onTapOk: () {
                        final _auth = FirebaseAuth.instance;
                        _auth.signOut();
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
