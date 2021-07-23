import '../models/exchange.dart';
import '../database/database_helper.dart';

abstract class ExchangeRepository {
  static Future<Exchange> _getCurrenciesInfo(Exchange exchange) async {
    exchange.leftCurrency =
        await DatabaseHelper.db.getCurrency(exchange.leftCurrency!.iso!);
    exchange.rightCurrency =
        await DatabaseHelper.db.getCurrency(exchange.rightCurrency!.iso!);
    return exchange;
  }

  static Future<Exchange> getLastExchange() async {
    Exchange exchange = await DatabaseHelper.db.getLastExchange();
    return await _getCurrenciesInfo(exchange);
  }

  static Future<Exchange> getLastTwoCurrencies() async {
    Exchange exchange = await DatabaseHelper.db.getLastExchange();
    exchange.leftValue = null;
    exchange.rightValue = null;
    return await _getCurrenciesInfo(exchange);
  }

  static Future<Exchange> getFirstTwoCurrencies() async {
    return await DatabaseHelper.db.getFirstTwoCurrencies();
  }
}
