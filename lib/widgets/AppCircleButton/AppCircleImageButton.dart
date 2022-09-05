// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

class CirculerIconBtn extends StatelessWidget {
  Color bgColor;
  Color iconColor;
  VoidCallback onPressed;
  String iconPath;
  double size;
  double iconSize;
  Color borderColor;
  CirculerIconBtn({
    Key? key,
    this.bgColor = Colors.grey,
    required this.onPressed,
    required this.iconPath,
    this.iconColor = Colors.black,
    this.size = 36,
    this.iconSize = 24,
    this.borderColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(size, size),
        primary: bgColor,
        elevation: 0,
        shape: CircleBorder(
          side: BorderSide(
            color: borderColor,
          ),
        ),
      ),
      onPressed: onPressed,
      child: Image(
        color: iconColor,
        width: iconSize,
        image: AssetImage(
          iconPath,
        ),
      ),
    );
  }
}
