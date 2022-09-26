// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mechanic/user_dashboard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:mechanic/login_screen.dart';
import 'package:mechanic/mechanic_details.dart';
import 'package:mechanic/widgets/AppButton/AppButton.dart';
import 'package:mechanic/widgets/AppText/AppText.dart';
import 'package:mechanic/widgets/TextFields/AppTextField.dart';
import 'package:mechanic/widgets/app_logo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppLogo(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Register',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AppTextField(
                    controller: nameController,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AppTextField(
                    controller: emailController,
                    email: true,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Phone',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AppTextField(
                    controller: phoneController,
                    phone: true,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Password',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AppTextField(
                    controller: passwordController,
                    password: true,
                  ),
                  CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.all(0),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text('Register as a Mechanic'),
                    value: mechanic,
                    onChanged: (bool? value) {
                      setState(() {
                        mechanic = value!;
                      });
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  AppBtn(
                    child: Text(mechanic == true ? 'Next' : 'Register'),
                    onPressed: () async {
                      if (mechanic == true) {
                        Get.to(
                          MechanicDetails(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            password: passwordController.text,
                          ),
                        );
                      } else {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          User? user = _auth.currentUser;
                          await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(emailController.text)
                              .set(
                            {
                              'uid': user!.uid,
                              'email': emailController.text,
                              'password': passwordController.text,
                              'imageUrl': 'null',
                              'firstname': nameController.text,
                              'role': 'user',
                            },
                          );
                          // .whenComplete(
                          //   () {
                          //     GetStorage().write('UserUID', user);
                          //     GetStorage().write('UserName', user);
                          //     GetStorage().write('UserEmail', user);
                          //     GetStorage().write('UserName', user);
                          //   },
                          // );
                          if (newUser != null) {
                            Get.offAll(
                              UserDashboard(),
                            );
                          }
                        } catch (e) {
                          print(e);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Txt(text: 'Already have an account? '),
                      HyperText(
                        text: 'Login Here',
                        onPressed: () {
                          Get.to(
                            LoginScreen(),
                          );
                        },
                        underLine: true,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool mechanic = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
}
