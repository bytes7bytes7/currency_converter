import 'currency.dart';

class Exchange {
  Exchange({
    this.time,
    this.leftCurrency,
    this.rightCurrency,
    this.leftValue,
    this.rightValue,
  });

  DateTime? time;
  Currency? leftCurrency;
  Currency? rightCurrency;
  double? leftValue;
  double? rightValue;

  Map<String, dynamic> toMap(){
    return {
      'time' : time,
      'leftCurrency' : leftCurrency,
      'rightCurrency' : rightCurrency,
      'leftValue' : leftValue,
      'rightValue' : rightValue,
    };
  }

  Exchange.fromMap(Map<String, dynamic> map) {
    time = DateTime.parse(map['time']);
    leftCurrency = Currency(iso: map['leftCurrency']);
    rightCurrency = Currency(iso: map['rightCurrency']);
    leftValue = map['leftValue'];
    rightValue = map['rightValue'];
  }
}
