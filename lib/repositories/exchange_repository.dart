import '../models/exchange.dart';
import '../database/database_helper.dart';

abstract class ExchangeRepository {
  static Future<Exchange> _getCurrenciesInfo(Exchange exchange) async {
    exchange.leftCurrency!.value =
        await DatabaseHelper.db.getCurrency(exchange.leftCurrency!.value.iso!);
    exchange.rightCurrency!.value =
        await DatabaseHelper.db.getCurrency(exchange.rightCurrency!.value.iso!);
    return exchange;
  }

  static Future<Exchange> getLastExchange() async {
    Exchange exchange = await DatabaseHelper.db.getLastExchange();
    return await _getCurrenciesInfo(exchange);
  }

  static Future<Exchange> getLastTwoCurrencies() async {
    Exchange exchange = await DatabaseHelper.db.getLastExchange();
    exchange.leftValue.text = '';
    exchange.rightValue.text = '';
    return await _getCurrenciesInfo(exchange);
  }

  static Future<Exchange> getFirstTwoCurrencies() async {
    return await DatabaseHelper.db.getFirstTwoCurrencies();
  }

  static Future<Exchange> getTwoCurrencies(Exchange exchange) async {
    return await DatabaseHelper.db.getTwoCurrencies(exchange);
  }

  static Future<List<Exchange>> getAllExchanges() async {
    return await DatabaseHelper.db.getAllExchanges();
  }

  static Future<void> addExchange(Exchange exchange) async {
    return await DatabaseHelper.db.addExchange(exchange);
  }

  static Future<void> deleteAllExchanges() async {
    return await DatabaseHelper.db.deleteAllExchanges();
  }
}
