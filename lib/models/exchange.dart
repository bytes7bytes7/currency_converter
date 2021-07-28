import 'package:currency_converter/constants.dart';
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
  int get hashCode => toString().hashCode;

  @override
  bool operator ==(other) {
    return hashCode == other.hashCode;
  }

  @override
  String toString() {
    return '$time&${leftCurrency?.value.iso ?? ''}&${rightCurrency?.value.iso ?? ''}&${leftValue.text}&${rightValue.text}';
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
    leftCurrency = ValueNotifier(Currency(iso: map[ConstantDBData.iso1]));
    rightCurrency = ValueNotifier(Currency(iso: map[ConstantDBData.iso2]));
    leftValue.text = map[ConstantDBData.value1].toString().replaceAll('.', ',');
    rightValue.text =
        map[ConstantDBData.value2].toString().replaceAll('.', ',');
  }

  Exchange.fromString(String str) {
    if (str != ConstantDBData.unknown) {
      List<String> data = str.split('&');
      time = data[0];
      leftCurrency = ValueNotifier(Currency(iso: data[1]));
      rightCurrency = ValueNotifier(Currency(iso: data[2]));
      leftValue = TextEditingController(text: data[3]);
      rightValue = TextEditingController(text: data[4]);
    }
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
