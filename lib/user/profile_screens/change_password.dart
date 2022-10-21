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
                    changed: (value) {
                      if (value.length > 5) {
                        setState(
                          () {
                            passwordFunction = value == '' ||
                                    newController.text == '' ||
                                    confirmController.text == ''
                                ? null
                                : () {
                                    if (RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                                    ).hasMatch(newController.text)) {
                                      if (newController.text ==
                                          confirmController.text) {
                                        changePassword(newController.text);
                                      } else {
                                        Get.snackbar(
                                          'Error',
                                          'New password and confirm password not match.',
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      }
                                    } else {
                                      Get.snackbar(
                                        'Error',
                                        'Password must contain at least:\n8 characters.\n1 uppercase\n1 lowercase\n1 digit\n1 special character',
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  };
                          },
                        );
                      } else {
                        setState(
                          () {
                            passwordFunction = null;
                          },
                        );
                      }
                    },
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
                    changed: (value) {
                      if (value.length > 7) {
                        setState(
                          () {
                            passwordFunction = confirmController.text == '' ||
                                    value == '' ||
                                    confirmController.text == ''
                                ? null
                                : () {
                                    if (RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                                    ).hasMatch(value)) {
                                      if (value == confirmController.text) {
                                        changePassword(value);
                                      } else {
                                        Get.snackbar(
                                          'Error',
                                          'New password and confirm password not match.',
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      }
                                    } else {
                                      Get.snackbar(
                                        'Error',
                                        'Password must contain at least:\n8 characters.\n1 uppercase\n1 lowercase\n1 digit\n1 special character',
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  };
                          },
                        );
                      } else {
                        setState(
                          () {
                            passwordFunction = null;
                          },
                        );
                      }
                    },
                    enterFunc: () {
                      FocusScope.of(context).unfocus();
                    },
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
                    changed: (value) {
                      if (value.length > 7) {
                        setState(
                          () {
                            passwordFunction = currentController.text == '' ||
                                    newController.text == '' ||
                                    value == ''
                                ? null
                                : () {
                                    if (RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                                    ).hasMatch(newController.text)) {
                                      if (newController.text == value) {
                                        changePassword(newController.text);
                                      } else {
                                        Get.snackbar(
                                          'Error',
                                          'New password and confirm password not match.',
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      }
                                    } else {
                                      Get.snackbar(
                                        'Error',
                                        'Password must contain at least:\n8 characters.\n1 uppercase\n1 lowercase\n1 digit\n1 special character',
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  };
                          },
                        );
                      } else {
                        setState(
                          () {
                            passwordFunction = null;
                          },
                        );
                      }
                    },
                    enterFunc: () {
                      FocusScope.of(context).unfocus();
                    },
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
                    onPressed: passwordFunction,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Function? passwordFunction;

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
  void changePassword(String newPassword) {
    if (currentController.text == password) {
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
          ).whenComplete(
            () {
              getData();
              setState(() {
                showSpinner = false;
                currentController.clear();
                newController.clear();
                confirmController.clear();
              });
              Get.snackbar(
                'Success',
                'Password changed successfully!!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ).whenComplete(
            () async {
              await FirebaseAuth.instance.signOut().then(
                    (value) => Get.offAll(
                      LoginScreen(),
                    ),
                  );
            },
          );
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
    } else {
      Get.snackbar(
        'Error',
        "Old and new password dosen't match",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  TextEditingController currentController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
}
