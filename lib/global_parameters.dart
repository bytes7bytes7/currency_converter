import 'package:flutter/material.dart';

import 'models/exchange.dart';
import 'models/currency.dart';
import 'models/setting.dart';

abstract class GlobalParameters {
  static final ValueNotifier<bool> openAdvanced = ValueNotifier(false);
  static final PageController screenController = PageController(initialPage: 1)
    ..addListener(() {
      if (screenController.page == 0 ||
          screenController.page == 1 ||
          screenController.page == 2) {
        openAdvanced.value = false;
      }
    });

  static final ValueNotifier<Exchange> exchangeNotifier = ValueNotifier(
    Exchange(
      leftCurrency: ValueNotifier(Currency()),
      rightCurrency: ValueNotifier(Currency()),
    ),
  );
  static final ValueNotifier<Exchange> lastExchange = ValueNotifier(
    Exchange(
      leftCurrency: ValueNotifier(Currency()),
      rightCurrency: ValueNotifier(Currency()),
    ),
  );

  static final ValueNotifier<Setting> advancedSetting =
      ValueNotifier(Setting());

  static final List<Setting> allSettings = <Setting>[];
}
