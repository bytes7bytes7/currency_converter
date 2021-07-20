import 'package:flutter/material.dart';

import '../constants.dart';

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: ConstantColors.scaffoldBackgroundColor,
  focusColor: ConstantColors.focusColor,
  disabledColor: ConstantColors.disabledColor,
  splashColor: ConstantColors.splashColor,
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.normal,
      color: ConstantColors.focusColor,
    ),
    subtitle1: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: ConstantColors.disabledColor,
    ),
    subtitle2: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.normal,
      color: ConstantColors.disabledColor,
    ),
    bodyText1: TextStyle(
      fontSize: 31.0,
      fontWeight: FontWeight.normal,
      color: ConstantColors.focusColor,
    ),
  ),
);
