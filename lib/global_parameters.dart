import 'package:flutter/material.dart';

import 'models/exchange.dart';
import 'models/currency.dart';

abstract class GlobalParameters {
  static final ValueNotifier<bool> openAdvanced = ValueNotifier(false);
  static final PageController screenController = PageController(initialPage: 1)..addListener(() {
    if(screenController.page == 2){
      openAdvanced.value = false;
    }
  });

  static final ValueNotifier<Exchange> exchangeNotifier = ValueNotifier(
    Exchange(
      leftCurrency: ValueNotifier(Currency()),
      rightCurrency: ValueNotifier(Currency()),
    ),
  );
}
