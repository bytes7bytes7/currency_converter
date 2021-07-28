import '../database/database_helper.dart';
import '../constants.dart';

abstract class InfoRepository {
  static Future<String> getLastDate()async{
    return await DatabaseHelper.db.getInfo(ConstantDBData.lastTimeUpdated);
  }

  static Future<String> getLastState()async{
    return await DatabaseHelper.db.getInfo(ConstantDBData.lastState);
  }

  static Future<void> updateInfo(String key, String value)async{
    return await DatabaseHelper.db.updateInfo(key, value);
  }
}
