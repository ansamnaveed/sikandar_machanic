import 'package:flutter/material.dart';

Widget buildErrors(List errors) {
  List<Widget> string = [];
  errors.forEach(
    (element) {
      string.add(
        Text(
          element,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontFamily: 'HelveticaNeueLT Arabic 55 Roman',
          ),
        ),
      );
    },
  );
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: string,
    ),
  );
}
