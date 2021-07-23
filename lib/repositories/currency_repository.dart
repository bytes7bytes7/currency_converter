import '../database/database_helper.dart';
import '../models/currency.dart';
import '../services/currency_service.dart';

abstract class CurrencyRepository {
  static Future<List<Currency>> updateCurrencies()async{
    return await CurrencyService.updateCurrencies();
  }

  static Future<List<Currency>> getAllCurrencies() async {
    return await DatabaseHelper.db.getAllCurrencies();
  }

  static Future deleteCurrency(String iso) async {
    await DatabaseHelper.db.deleteCurrency(iso);
  }

  static Future updateCurrency(Currency currency) async {
    await DatabaseHelper.db.updateCurrency(currency);
  }
}
