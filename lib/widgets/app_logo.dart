// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  double width;
  double? height;
  AppLogo({Key? key, this.width = 130, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      width: width,
      height: height,
      image: AssetImage('assets/images/logo.png'),
    );
  }
}
