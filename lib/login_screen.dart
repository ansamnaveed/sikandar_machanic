// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mechanic/dashboard.dart';
import 'package:mechanic/register_screen.dart';
import 'package:mechanic/user_dashboard.dart';
import 'package:mechanic/widgets/AppButton/AppButton.dart';
import 'package:mechanic/widgets/AppText/AppText.dart';
import 'package:mechanic/widgets/TextFields/AppTextField.dart';
import 'package:mechanic/widgets/app_logo.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                      'Login as Mechanic',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
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
                  SizedBox(
                    height: 20,
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
                  SizedBox(
                    height: 50,
                  ),
                  AppBtn(
                    child: Text('Login'),
                    onPressed: () async {
                      setState(
                        () {
                          showSpinner = true;
                        },
                      );
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                        if (user != null) {
                          checkExist(emailController.text);
                        }
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Txt(text: 'Do not have an account?'),
                      HyperText(
                        text: 'Register Here',
                        onPressed: () {
                          Get.to(
                            RegisterScreen(),
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

  bool showSpinner = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  checkExist(String email) async {
    setState(() {
      showSpinner = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(email)
          .get()
          .then(
        (doc) async {
          if (doc.exists == true) {
            Get.offAll(
              UserDashboard(),
            );
          } else if (doc.exists == false) {
            await FirebaseFirestore.instance
                .collection('Mechanics')
                .doc(email)
                .get()
                .then(
              (value) {
                Get.offAll(
                  Dashboard(),
                );
              },
            );
          }
        },
      );
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      showSpinner = false;
    });
  }
}
