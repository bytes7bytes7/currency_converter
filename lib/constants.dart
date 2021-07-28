import 'package:flutter/material.dart';

import 'models/setting.dart';

abstract class ConstantColors {
  static const Color scaffoldBackgroundColor = Color(0xFFF4FBFF);
  static const Color focusColor = Color(0xFF000000);
  static const Color disabledColor = Color(0xFF878787);
}

abstract class ConstantData {
  static const Map<int, String> month = {
    1: 'Янв',
    2: 'Фев',
    3: 'Мар',
    4: 'Апр',
    5: 'Май',
    6: 'Июн',
    7: 'Июл',
    8: 'Авг',
    9: 'Сен',
    10: 'Окт',
    11: 'Ноя',
    12: 'Дек',
  };
  static const Map<String, String> cryptoFlagImages = {
    'BTC': 'BTC.png',
    'BTS': 'BTS.png',
    'DASH': 'DASH.png',
    'DOGE': 'DOGE.png',
    'EMC': 'EMC.png',
    'ETH': 'ETH.png',
    'FCT': 'FCT.png',
    'FTC': 'FTC.png',
    'LTC': 'LTC.png',
    'NMC': 'NMC.png',
    'NVC': 'NVC.png',
    'NXT': 'NXT.png',
    'PPC': 'PPC.png',
    'VTC': 'VTC.png',
    'XMR': 'XMR.png',
    'XRP': 'XRP.png',
  };
}

abstract class ConstantDBData {
  static const String databaseName = 'data.db';
  static const int databaseVersion = 1;

  static const String currencyTableName = 'currency';
  static const String infoTableName = 'info';
  static const String historyTableName = 'history';
  static const String settingsTableName = 'settings';

  static const String unknown = '???';

  // currencyTable
  static const String iso = 'iso';
  static const String name = 'name';
  static const String country = 'country';
  static const String rate = 'rate';
  static const String dayDelta = 'dayDelta';
  static const String weekDelta = 'weekDelta';
  static const String monthDelta = 'monthDelta';
  static const String yearDelta = 'yearDelta';

  //infoTable
  static const String key = 'key';
  static const String value = 'value';

  // Info keys
  static const String lastTimeUpdated = 'lastTimeUpdated';
  static const String lastState = 'lastState';

  // historyTable
  static const String time = 'time';
  static const String iso1 = 'iso1';
  static const String iso2 = 'iso2';
  static const String value1 = 'value1';
  static const String value2 = 'value2';

  // settingsTable
  static const String title = 'title';
  static const String subtitle = 'subtitle';
  static const String icon = 'icon';
  static const String description = 'description';
  static const String options = 'options';

  static final List<Setting> defaultSettings = [
    Setting(
      title: 'Ночной режим',
      subtitle: 'Темная тема',
      value: 'false',
      icon: 'dark_mode_outlined',
    ),
    Setting(
      title: 'Сохранение валют',
      subtitle: 'Сохранение выбранных валют при выходе',
      value: 'false',
      icon: 'save_alt_outlined',
    ),
    Setting(
      title: 'Автообновление',
      subtitle: 'Обновление курса валют при входе',
      value: 'false',
      icon: 'update_outlined',
    ),
    Setting(
      title: 'Сохранение состояния',
      subtitle: 'Сохранение последнего расчета при выходе',
      value: 'false',
      icon: 'save',
    ),
    Setting(
      title: 'Удаление истории',
      subtitle: 'Автоматическое удаление истории через время',
      value: 'Никогда',
      icon: 'auto_delete_outlined',
      description: 'Через какое время автоматически удалять историю?',
      options: [
        'Сразу',
        'День',
        'Неделя',
        'Месяц',
        'Год',
        'Никогда',
      ],
    ),
  ];
}
