import 'package:flutter/material.dart';

import '../constants.dart';

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: ConstantColors.lightScaffoldBackgroundColor,
  focusColor: ConstantColors.lightFocusColor,
  disabledColor: ConstantColors.lightDisabledColor,
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.normal,
      color: ConstantColors.lightFocusColor,
    ),
    subtitle1: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: ConstantColors.lightDisabledColor,
    ),
    subtitle2: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.normal,
      color: ConstantColors.lightDisabledColor,
    ),
    bodyText1: TextStyle(
      fontSize: 31.0,
      fontWeight: FontWeight.normal,
      color: ConstantColors.lightFocusColor,
    ),
    bodyText2: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: ConstantColors.lightFocusColor,
    ),
  ),
);
