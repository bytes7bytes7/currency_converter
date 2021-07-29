import 'package:flutter/material.dart';

import '../constants.dart';

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: ConstantColors.darkScaffoldBackgroundColor,
  focusColor: ConstantColors.darkFocusColor,
  disabledColor: ConstantColors.darkDisabledColor,
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.normal,
      color: ConstantColors.darkFocusColor,
    ),
    subtitle1: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: ConstantColors.darkDisabledColor,
    ),
    subtitle2: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.normal,
      color: ConstantColors.darkDisabledColor,
    ),
    bodyText1: TextStyle(
      fontSize: 31.0,
      fontWeight: FontWeight.normal,
      color: ConstantColors.darkFocusColor,
    ),
    bodyText2: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: ConstantColors.darkFocusColor,
    ),
  ),
);
