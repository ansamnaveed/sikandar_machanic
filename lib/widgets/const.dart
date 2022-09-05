// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';

String fcmToken = "";

Map<int, Color> appThemeMap = {
  50: Color.fromRGBO(42, 125, 225, .1),
  100: Color.fromRGBO(42, 125, 225, .2),
  200: Color.fromRGBO(42, 125, 225, .3),
  300: Color.fromRGBO(42, 125, 225, .4),
  400: Color.fromRGBO(42, 125, 225, .5),
  500: Color.fromRGBO(42, 125, 225, .6),
  600: Color.fromRGBO(42, 125, 225, .7),
  700: Color.fromRGBO(42, 125, 225, .8),
  800: Color.fromRGBO(42, 125, 225, .9),
  900: Color.fromRGBO(42, 125, 225, 1),
};
MaterialColor appThemeColor = MaterialColor(0xFF2A7DE1, appThemeMap);

const Color appColorDark = Color.fromRGBO(81, 80, 70, 1);

const Color appColorLight = Color.fromRGBO(42, 125, 225, 1);

const Color pagesBackgroundColor = Color.fromRGBO(249, 249, 249, 1);

bool? edit;

push(BuildContext context, Widget widget) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

pushReplacement(BuildContext context, Widget widget) {
  return Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

class AppBg extends StatelessWidget {
  double opacity;
  AppBg({Key? key, this.opacity = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Image(
        image: AssetImage(
          'assets/icons/white_circle.png',
        ),
      ),
      // Stack(
      //   children: [
      //     Positioned(
      //       top: -275,
      //       left: 260,
      //       child: Image(
      //         image: AssetImage('assets/images/bg.png'),
      //       ),
      //     ),
      //     Positioned(
      //       bottom: -275,
      //       right: 260,
      //       child: Image(
      //         image: AssetImage('assets/images/bg.png'),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

String? token;
// String webUrl = 'https://busy-burnell.161-97-115-110.plesk.page';
String webUrl = 'https://mjaz.art';
String baseUrl = '$webUrl/beta/public';
String apiUrl = '$baseUrl/api';
String storageURL = '$baseUrl/uploads/image/';
String imagesLink = '$baseUrl/uploads/image/';
String imagesProfile = '$baseUrl/uploads/user_image/';
String videoLink = '$baseUrl/uploads/video/';
String registerUrl = '$apiUrl/Register';
String logInUrl = '$apiUrl/login';
String forgetPassword = '$apiUrl/forgot_password';
String logoutUrl = '$apiUrl/logout';
String homeUrl = '$apiUrl/vendor/index';
String contactUsUrl = '$apiUrl/contactus/store';
String updateUser = '$apiUrl/vendor/update';
var user;
String paisy = '2';

int ordersCount = 0;

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }
}

extension PhoneValidator on String {
  bool isValidPhone() {
    return RegExp(
      r'(^([+0][0-9])[0-9]{10,12}$)',
    ).hasMatch(this);
  }
}
