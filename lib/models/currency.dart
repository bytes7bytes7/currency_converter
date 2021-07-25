import 'package:currency_converter/constants.dart';

class Currency {
  Currency({
    this.iso,
    this.name,
    this.country,
    this.rate,
    this.dayDelta,
    this.weekDelta,
    this.monthDelta,
    this.yearDelta,
  });

  String? iso;
  String? name;
  String? country;
  double? rate; // USA dollar rate
  String? dayDelta;
  String? weekDelta;
  String? monthDelta;
  String? yearDelta;

  String getFlag() {
    if (country!.isEmpty){
      if (ConstantData.cryptoFlagImages[iso] != null){
        return ConstantData.cryptoFlagImages[iso]!;
      }
      final int firstLetter = 'DA'.codeUnitAt(0) - 0x41 + 0x1F1E6;
      final int secondLetter = 'DA'.codeUnitAt(1) - 0x41 + 0x1F1E6;
      return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
    }
    int firstLetter;
    int secondLetter;
    if (iso == 'ANG'){
      firstLetter = '🇨🇼'.codeUnitAt(0) - 0x41 + 0x1F1E6;
      secondLetter = '🇨🇼'.codeUnitAt(1) - 0x41 + 0x1F1E6;
    }else {
      firstLetter = iso!.codeUnitAt(0) - 0x41 + 0x1F1E6;
      secondLetter = iso!.codeUnitAt(1) - 0x41 + 0x1F1E6;
    }
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  Map<String, dynamic> toMap() {
    return {
      'iso': iso,
      'name': name,
      'country': country,
      'rate': rate,
      'dayDelta': dayDelta,
      'weekDelta': weekDelta,
      'monthDelta': monthDelta,
      'yearDelta': yearDelta,
    };
  }

  Currency.fromMap(Map<String, dynamic> map) {
    iso = map['iso'];
    name = map['name'];
    country = map['country'];
    rate = map['rate'];
    dayDelta = map['dayDelta'];
    weekDelta = map['weekDelta'];
    monthDelta = map['monthDelta'];
    yearDelta = map['yearDelta'];
  }
}
