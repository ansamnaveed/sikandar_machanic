// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mechanic/login_screen.dart';
import 'package:mechanic/widgets/AppButton/AppButton.dart';
import 'package:mechanic/widgets/AppText/AppText.dart';
import 'package:mechanic/widgets/TextFields/AppTextField.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditProfileUser extends StatefulWidget {
  const EditProfileUser({super.key});

  @override
  State<EditProfileUser> createState() => _EditProfileUserState();
}

class _EditProfileUserState extends State<EditProfileUser> {
  bool showSpinner = false;
  Function? profileFunction;

  @override
  void initState() {
    getData();
    super.initState();
  }

  TextEditingController fnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
          ),
        ),
        elevation: 0,
        leadingWidth: 30,
        title: Txt(
          text: 'Edit Profile',
          bold: true,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Container(
            height: Get.height - 70,
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Txt(
                  text: 'Full Name',
                  bold: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: AppTextField(
                    controller: fnameController,
                    // changed: (value) {
                    //   if (value.length > 5) {
                    //     setState(
                    //       () {
                    //         profileFunction =
                    //             value == '' || phoneController.text == ''
                    //                 ? null
                    //                 : () {
                    //                     if (RegExp(
                    //                       r'(^([+0]9)[0-9]{10,12}$)',
                    //                     ).hasMatch(phoneController.text)) {
                    //                       changeProfile(fnameController.text,
                    //                           phoneController.text);
                    //                     } else {
                    //                       Get.snackbar(
                    //                         'Error',
                    //                         'Phone format: [+][country code][phone number]',
                    //                         snackPosition: SnackPosition.BOTTOM,
                    //                       );
                    //                     }
                    //                   };
                    //       },
                    //     );
                    //   } else {
                    //     setState(
                    //       () {
                    //         profileFunction = null;
                    //       },
                    //     );
                    //   }
                    // },
                    enterFunc: () {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                Txt(
                  text: 'Phone Number',
                  bold: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: AppTextField(
                    controller: phoneController,
                    // changed: (value) {
                    //   if (value.length > 7) {
                    //     setState(
                    //       () {
                    //         profileFunction =
                    //             value == '' || fnameController.text == ''
                    //                 ? null
                    //                 : () {
                    //                     if (RegExp(
                    //                       r'(^([+0]9)[0-9]{10,12}$)',
                    //                     ).hasMatch(value)) {
                    //                       changeProfile(
                    //                           value, fnameController.text);
                    //                     } else {
                    //                       Get.snackbar(
                    //                         'Error',
                    //                         'Phone format: [+][country code][phone number]',
                    //                         snackPosition: SnackPosition.BOTTOM,
                    //                       );
                    //                     }
                    //                   };
                    //       },
                    //     );
                    //   } else {
                    //     setState(
                    //       () {
                    //         profileFunction = null;
                    //       },
                    //     );
                    //   }
                    // },
                    enterFunc: () {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                    ),
                    title: Txt(
                      text: "Switch to ${role == "user" ? "Mechanic" : "User"}",
                      color: Colors.black,
                      size: 14,
                      bold: true,
                    ),
                    dense: true,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: AppBtn(
                    child: Txt(
                      text: 'Change',
                      bold: true,
                    ),
                    onPressed: () {
                      changeProfile(fnameController.text, phoneController.text);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> changeProfile(String fname, String phone) async {
    setState(() {
      showSpinner = true;
    });
    final User? user = auth.currentUser;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.email)
        .update(
      {
        'phone': fname,
        'firstname': phone,
      },
    ).whenComplete(
      () {
        getData();
        setState(() {
          showSpinner = false;
          fnameController.clear();
          phoneController.clear();
        });
        Get.snackbar(
          'Success',
          'Profile updated successfully!!',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    ).whenComplete(
      () {
        getData();
      },
    ).catchError(
      (error) {
        setState(() {
          showSpinner = false;
        });
        Get.snackbar(
          'Error',
          error.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  String? role;

  void getData() async {
    setState(() {
      showSpinner = true;
    });
    final User? user = auth.currentUser;
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.email)
        .get();
    setState(
      () {
        fnameController.text = variable['firstname'];
        phoneController.text = variable['phone'];
        role = variable['role'];
      },
    );
    setState(
      () {
        showSpinner = false;
      },
    );
  }
}
