import 'package:flutter/material.dart';

class AppSizes {
  static bool isSmall(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide < 600;

  static double fontSize(BuildContext context) =>
      isSmall(context) ? 16.0 : 22.0;

  static double iconSize(BuildContext context) =>
      isSmall(context) ? 20.0 : 32.0;
}
