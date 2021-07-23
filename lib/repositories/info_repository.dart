import '../database/database_helper.dart';
import '../constants.dart';

abstract class InfoRepository {
  static Future<String> getLastDate() async {
    return await DatabaseHelper.db.getInfo(ConstantDBData.lastTimeUpdated);
  }
}
