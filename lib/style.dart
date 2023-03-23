import 'package:flutter/material.dart';

TextStyle kTextStyleTitle(double size) {
  return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      height: 1.5);
}

Widget kVerticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

Widget kHorizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}
