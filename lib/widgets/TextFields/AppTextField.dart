// ignore_for_file: prefer_const_constructors, must_be_immutable
// @dart=2.9

import 'package:flutter/material.dart';
import 'package:mechanic/widgets/const.dart';

class AppTextField extends StatelessWidget {
  TextEditingController controller;
  TextInputType textType;
  int lines;
  Widget suffix;
  TextDirection direction;
  Color textColor;
  double radius;
  String hint;
  String errorValue;
  bool password;
  bool cursor;
  bool readOnly;
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
    this.changed,
    this.suffix,
    this.direction = TextDirection.rtl,
    this.textType = TextInputType.text,
    this.password = false,
    this.readOnly = false,
    this.radius = 50,
    this.lines = 1,
    this.errorValue = 'الرجاء إدخال قيمة صالحة.',
    @required this.controller,
    this.textAlign = TextAlign.start,
    this.textColor,
    this.email = false,
    this.phone = false,
    this.hint = 'أدخل النص...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: lines,
      textAlign: textAlign,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: password,
      controller: controller,
      validator: email == true
          ? (input) => input.isValidEmail() ? null : "البریدالاکترونی غير صحيح"
          : phone == true
              ? (input) => input.isValidPhone() ? null : "رقم الجوال غير صحيح"
              : (value) {
                  return null;
                },
      style: TextStyle(color: appColorLight, height: 1),
      keyboardType: textType,
      readOnly: readOnly,
      onFieldSubmitted: (value) {
        FocusScope.of(context).unfocus();
      },
      onEditingComplete: enterFunc,
      onSaved: (value) {
        FocusScope.of(context).unfocus();
      },
      onChanged: changed,
      showCursor: cursor,
      textDirection: direction,
      decoration: InputDecoration(
        suffixIcon: suffix,
        hintTextDirection: direction,
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
