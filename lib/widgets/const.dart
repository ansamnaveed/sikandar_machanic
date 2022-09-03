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
