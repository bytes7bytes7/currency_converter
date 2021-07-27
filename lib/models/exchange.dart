import 'package:flutter/material.dart';

import 'currency.dart';

class Exchange {
  Exchange({
    this.time,
    this.leftCurrency,
    this.rightCurrency,
  });

  String? time;
  ValueNotifier<Currency>? leftCurrency;
  ValueNotifier<Currency>? rightCurrency;
  TextEditingController leftValue = TextEditingController();
  TextEditingController rightValue = TextEditingController();

  @override
  int get hashCode =>
      '$time&${leftCurrency?.value.iso ?? ''}&${rightCurrency?.value.iso ?? ''}&${leftValue.text}&${rightValue.text}'
          .hashCode;

  @override
  bool operator ==(other) {
    return hashCode == other.hashCode;
  }

  Exchange.from(Exchange other) {
    time = other.time;
    leftCurrency = ValueNotifier(Currency.from(other.leftCurrency!.value));
    rightCurrency = ValueNotifier(Currency.from(other.rightCurrency!.value));
    leftValue.text = other.leftValue.text;
    rightValue.text = other.rightValue.text;
  }

  Exchange.fromMap(Map<String, dynamic> map) {
    time = map['time'];
    leftCurrency = ValueNotifier(Currency(iso: map['iso1']));
    rightCurrency = ValueNotifier(Currency(iso: map['iso2']));
    leftValue.text = map['value1'].toString().replaceAll('.', ',');
    rightValue.text = map['value2'].toString().replaceAll('.', ',');
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'leftCurrency': leftCurrency,
      'rightCurrency': rightCurrency,
      'leftValue': leftValue,
      'rightValue': rightValue,
    };
  }
}
