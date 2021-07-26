import '../database/database_helper.dart';
import '../models/setting.dart';

abstract class SettingRepository {
  static Future<List<Setting>> getSettings() async {
    return await DatabaseHelper.db.getSettings();
  }

  static Future<List<Setting>> addDefaultSettings() async {
    return await DatabaseHelper.db.addDefaultSettings();
  }

  static Future<void> updateSettings(List<Setting> settings)async{
    return await DatabaseHelper.db.updateSettings(settings);
  }
}


