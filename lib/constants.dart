import 'package:flutter/material.dart';

abstract class ConstantColors {
  static const Color scaffoldBackgroundColor = Color(0xFFF4FBFF);
  static const Color focusColor = Color(0xFF000000);
  static const Color disabledColor = Color(0xFF878787);
}

abstract class ConstantData {
  static const Map<int, String> month = {
    1: 'Январь',
    2: 'Февраль',
    3: 'Март',
    4: 'Апрель',
    5: 'Май',
    6: 'Июнь',
    7: 'Июль',
    8: 'Август',
    9: 'Сентябрь',
    10: 'Октябрь',
    11: 'Ноябрь',
    12: 'Декабрь',
  };
}

abstract class ConstantDBData {
  static const String databaseName = 'data.db';
  static const int databaseVersion = 1;
  static const String currencyTableName = 'currency';
  static const String infoTableName = 'info';

  static const String unknown = '???';

  // currencyTable
  static const String iso = 'iso';
  static const String name = 'name';
  static const String country = 'country';
  static const String rate = 'rate';

  //infoTable
  static const String key = 'key';
  static const String value = 'value';

  // Info keys
  static const String lastTimeUpdated = 'lastTimeUpdated';
}
