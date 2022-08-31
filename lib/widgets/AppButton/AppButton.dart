// ignore_for_file: prefer_const_constructors, must_be_immutable
// @dart=2.9

import 'package:flutter/material.dart';

class AppBtn extends StatelessWidget {
  Color bgColor;
  double btnWidth;
  double btnHeight;
  bool whiteBordered;
  Color borderColor;
  Widget child;
  double radius;
  Function onPressed;
  AppBtn({
    Key key,
    this.borderColor,
    this.bgColor,
    this.btnWidth = 130,
    this.radius = 100,
    this.btnHeight = 50,
    this.whiteBordered = false,
    @required this.child,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(0),
        primary: bgColor,
        elevation: 0,
        fixedSize: Size(btnWidth, btnHeight == 0 ? 40 : btnHeight),
        shape: whiteBordered == true
            ? RoundedRectangleBorder(
                side: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(radius),
              )
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  radius,
                ),
              ),
      ),
      child: child,
      onPressed: onPressed,
    );
  }
}
