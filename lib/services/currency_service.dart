import 'dart:convert';
import 'package:http/http.dart' as http;

import '../database/database_helper.dart';
import '../models/currency.dart';
import '../constants.dart';
import 'win1251_decoder.dart';

abstract class CurrencyService {
  static Future<List<Currency>> updateCurrencies() async {
    var url = Uri.parse('https://babki.info/kurs/usd');
    http.Response response;
    try {
      response = await http.get(url);
    } catch (error) {
      return <Currency>[];
    }
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
        dayDelta: '0',
        weekDelta: '0',
        monthDelta: '0',
        yearDelta: '0',
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
          dayDelta: ((curr['dayAgo'].isNotEmpty) ? curr['dayAgo'] : '0'),
          weekDelta: ((curr['weekAgo'].isNotEmpty) ? curr['weekAgo'] : '0'),
          monthDelta: ((curr['monthAgo'].isNotEmpty) ? curr['monthAgo'] : '0'),
          yearDelta: ((curr['yearAgo'].isNotEmpty) ? curr['yearAgo'] : '0'),
        ),
      );
    }
    DateTime now = DateTime.now();
    String date =
        '${now.hour}:${now.minute} ${now.day}.${now.month}.${now.year}';
    await DatabaseHelper.db.updateInfo(ConstantDBData.lastTimeUpdated, date);
    await DatabaseHelper.db.updateAllCurrencies(currencies);
    return currencies;
  }
}
