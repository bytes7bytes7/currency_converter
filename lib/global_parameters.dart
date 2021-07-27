import 'package:flutter/material.dart';

import 'models/exchange.dart';
import 'models/currency.dart';

abstract class GlobalParameters {
  static final PageController screenController = PageController(initialPage: 1);
  static final ValueNotifier<Exchange> exchangeNotifier = ValueNotifier(Exchange(
    leftCurrency: ValueNotifier(Currency()),
    rightCurrency: ValueNotifier(Currency()),
  ));
}
