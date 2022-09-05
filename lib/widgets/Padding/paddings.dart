// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

// class Paddings {
//   static const EdgeInsets defaultPadding = EdgeInsets.all(16);
//   static const EdgeInsets topOnly = EdgeInsets.only(top: 16);
//   static const EdgeInsets bottomOnly = EdgeInsets.only(bottom: 16);
//   static const EdgeInsets leftOnly = EdgeInsets.only(left: 16);
//   static const EdgeInsets rightOnly = EdgeInsets.only(right: 16);
//   static const EdgeInsets vertical = EdgeInsets.symmetric(vertical: 16);
//   static const EdgeInsets horizontal = EdgeInsets.symmetric(horizontal: 16);
// }

class Paddings extends StatelessWidget {
  double left, top, right, bottom;
  Widget child;
  Paddings(
      {Key? key,
      required this.child,
      this.bottom = 0,
      this.left = 0,
      this.right = 0,
      this.top = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: child,
    );
  }
}

class VerticalPaddings extends StatelessWidget {
  double padding;
  Widget child;
  VerticalPaddings({Key? key, this.padding = 0, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: child,
    );
  }
}

class HorizontalPaddings extends StatelessWidget {
  double padding;
  Widget child;
  HorizontalPaddings({Key? key, this.padding = 0, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
    );
  }
}
