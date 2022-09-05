// ignore_for_file: prefer_const_constructors, must_be_immutable
// @dart=2.9
import 'package:flutter/material.dart';

class Txt extends StatelessWidget {
  String text = '';
  String family;
  double size;
  Color color;
  TextAlign align = TextAlign.center;
  bool bold = false;
  Txt({
    Key key,
    @required this.text,
    this.bold,
    this.align,
    this.size,
    this.family,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontFamily: family,
        fontWeight: bold == true ? FontWeight.w800 : FontWeight.w200,
      ),
    );
  }
}

class HyperText extends StatelessWidget {
  String text = '';
  double size;
  TextAlign align = TextAlign.center;
  bool bold = false;
  Function onPressed;
  bool underLine;
  Color color;
  HyperText(
      {Key key,
      @required this.onPressed,
      @required this.text,
      this.bold,
      this.color,
      this.align,
      this.underLine = false,
      this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          decoration: underLine == true ? TextDecoration.underline : null,
          color: color,
          fontSize: size,
          fontWeight: bold == true ? FontWeight.w800 : FontWeight.w200,
        ),
      ),
    );
  }
}
