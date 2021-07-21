import 'package:currency_converter/constants.dart';
import 'package:currency_converter/services/exchange_service.dart';

import '../database/database_helper.dart';
import '../models/currency.dart';

class ExchangeRepository {
  Future<List<Currency>> updateExchanges()async{
    return await ExchangeService.updateExchanges();
  }

  Future<List<Currency>> getAllCurrencies() async {
    return await DatabaseHelper.db.getAllCurrencies();
  }

  Future<String> getLastDate()async{
    return await DatabaseHelper.db.getInfo(ConstantDBData.lastTimeUpdated);
  }

  Future deleteCurrency(String iso) async {
    await DatabaseHelper.db.deleteCurrency(iso);
  }

  Future updateCurrency(Currency currency) async {
    await DatabaseHelper.db.updateCurrency(currency);
  }
}
