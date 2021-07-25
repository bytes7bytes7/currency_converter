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
}
