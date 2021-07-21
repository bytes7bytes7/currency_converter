import 'dart:convert';
import 'package:currency_converter/constants.dart';
import 'package:currency_converter/database/database_helper.dart';
import 'package:currency_converter/services/win1251_decoder.dart';
import 'package:http/http.dart' as http;

import '../models/currency.dart';

abstract class ExchangeService {
  static Future<List<Currency>> updateExchanges() async {
    await DatabaseHelper.db.getAllCurrencies();
    var url = Uri.parse('https://babki.info/kurs/usd');
    var response = await http.get(url);
    String body = response.body;
    body = body
        .substring(body.indexOf('var Pairs = \'') + 'var Pairs = \''.length);
    body = body.substring(0, body.indexOf('\';'));
    var jsonData = json.decode(body);
    List<Currency> currencies = [
      Currency(
        name: 'Доллар США',
        iso: 'USD',
        rate: 1.0,
        country: 'США',
      ),
    ];
    for (var curr in jsonData) {
      String current = utf8
          .decode(Win1251Decoder.encode(curr['current']))
          .replaceAll(',', '.')
          .replaceAll(' ', '')
          .replaceAll('\n', '');
      currencies.add(
        Currency(
          name: curr['name'],
          iso: curr['code'],
          rate: double.parse(current),
          country: curr['country'],
        ),
      );
    }
    DateTime now = DateTime.now();
    String date = '${ConstantData.month[now.month]}, ${now.day}';
    await DatabaseHelper.db.updateInfo(ConstantDBData.lastTimeUpdated, date);
    await DatabaseHelper.db.updateAllCurrencies(currencies);
    return currencies;
  }
}
