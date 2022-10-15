// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mechanic/widgets/AppButton/AppButton.dart';
import 'package:mechanic/widgets/AppText/AppText.dart';
import 'package:mechanic/widgets/TextFields/AppTextField.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  void initState() {
    getData();
    super.initState();
  }

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
          text: 'Change Password',
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
                  text: 'Current Password',
                  bold: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: AppTextField(
                    password: true,
                    controller: currentController,
                    // changed: (value) {
                    //   if (value.length > 5) {
                    //     setState(() {
                    //       loginFunction = emailController.text == '' ||
                    //               passwordController.text == ''
                    //           ? null
                    //           : () {
                    //               if (RegExp(
                    //                 r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                    //               ).hasMatch(emailController.text)) {
                    //                 login(emailController.text,
                    //                     passwordController.text);
                    //               } else {
                    //                 Get.snackbar(
                    //                   'Error',
                    //                   'Password must be at least 6 characters.',
                    //                 );
                    //               }
                    //             };
                    //     });
                    //   } else {
                    //     setState(() {
                    //       loginFunction = null;
                    //     });
                    //   }
                    // },
                    enterFunc: () {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                Txt(
                  text: 'New Password',
                  bold: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: AppTextField(
                    password: true,
                    controller: newController,
                  ),
                ),
                Txt(
                  text: 'Confirm Password',
                  bold: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: AppTextField(
                    password: true,
                    controller: confirmController,
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
                    onPressed: currentController.text == '' ||
                            newController.text == '' ||
                            confirmController.text == ''
                        ? null
                        : () {
                            if (currentController.text == password) {
                              if (newController.text ==
                                  confirmController.text) {
                                changePassword(newController.text);
                              } else {
                                Get.snackbar(
                                  'Error',
                                  "New password and Confirm password not match.",
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            } else {
                              Get.snackbar(
                                'Error',
                                "Please enter the correct password.",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
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

  bool showSpinner = false;
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
      password = variable['password'];
    });
    setState(() {
      showSpinner = false;
    });
  }

  String? password;

  final FirebaseAuth auth = FirebaseAuth.instance;
  void changePassword(String newPassword) async {
    setState(() {
      showSpinner = true;
    });
    final User? user = auth.currentUser;
    auth.currentUser!.updatePassword(newPassword).then(
      (_) async {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user!.email)
            .update(
          {
            'password': newPassword,
          },
        ).whenComplete(() {
          getData();
          setState(() {
            showSpinner = false;
          });
          Get.snackbar(
            'Success',
            'Password changed successfully!!',
            snackPosition: SnackPosition.BOTTOM,
          );
        });
      },
    ).catchError(
      (error) {
        Get.snackbar(
          'Error',
          error.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  TextEditingController currentController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
}
