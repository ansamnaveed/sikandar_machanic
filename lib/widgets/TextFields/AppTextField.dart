// ignore_for_file: prefer_const_constructors, must_be_immutable
// @dart=2.9
import 'package:flutter/material.dart';
import 'package:mechanic/widgets/const.dart';

class AppTextField extends StatelessWidget {
  TextEditingController controller;
  TextInputType textType;
  int lines;
  Color textColor;
  double radius;
  String hint;
  String errorValue;
  bool password;
  bool cursor;
  TextAlign textAlign;
  Color hintColor;
  bool email;
  bool phone;
  Function enterFunc;
  Function(String) changed;

  AppTextField({
    Key key,
    this.hintColor = Colors.grey,
    this.cursor = true,
    this.enterFunc,
    this.textType = TextInputType.text,
    this.password = false,
    this.radius = 50,
    this.changed,
    this.lines = 1,
    this.errorValue = 'Please enter the correct value.',
    @required this.controller,
    this.textAlign = TextAlign.start,
    this.textColor,
    this.email = false,
    this.phone = false,
    this.hint = 'Enter Text',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: changed,
      maxLines: lines,
      textAlign: textAlign,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: password,
      controller: controller,
      validator: email == true
          ? (input) => input.isValidEmail() ? null : "Email is incorrect."
          : phone == true
              ? (input) => input.isValidPhone() ? null : "Phone is incorrect."
              : (value) {
                  return null;
                },
      style: TextStyle(color: appColorLight, height: 1),
      keyboardType: textType,
      onFieldSubmitted: (value) {
        FocusScope.of(context).unfocus();
      },
      onEditingComplete: enterFunc,
      onSaved: (value) {
        FocusScope.of(context).unfocus();
      },
      showCursor: cursor,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColorLight, width: 4),
          borderRadius: BorderRadius.circular(radius),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 4),
          borderRadius: BorderRadius.circular(radius),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 4),
          borderRadius: BorderRadius.circular(radius),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 4),
          borderRadius: BorderRadius.circular(radius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: controller.text == ''
                  ? Color.fromRGBO(204, 213, 221, 1)
                  : appColorLight,
              width: 4),
          borderRadius: BorderRadius.circular(radius),
        ),
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(204, 213, 221, 1), width: 4),
          borderRadius: BorderRadius.circular(radius),
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: hintColor.withOpacity(0.5),
        ),
      ),
    );
  }
}
