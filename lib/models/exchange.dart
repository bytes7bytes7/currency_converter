import 'currency.dart';

class Exchange {
  Exchange({
    this.time,
    this.leftCurrency,
    this.rightCurrency,
    this.leftValue,
    this.rightValue,
  });

  String? time;
  Currency? leftCurrency;
  Currency? rightCurrency;
  double? leftValue;
  double? rightValue;

  Exchange.from(Exchange other) {
    time = other.time;
    leftCurrency = Currency.from(other.leftCurrency!);
    rightCurrency = Currency.from(other.rightCurrency!);
    leftValue = other.leftValue;
    rightValue = other.rightValue;
  }

  Exchange.fromMap(Map<String, dynamic> map) {
    time = map['time'];
    leftCurrency = Currency(iso: map['iso1']);
    rightCurrency = Currency(iso: map['iso2']);
    leftValue = map['value1'];
    rightValue = map['value2'];
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
