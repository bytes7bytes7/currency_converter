import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../models/exchange.dart';
import '../models/currency.dart';
import '../constants.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper db = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, ConstantDBData.databaseName);
    return await openDatabase(path,
        version: ConstantDBData.databaseVersion, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${ConstantDBData.currencyTableName} (
        ${ConstantDBData.iso} TEXT PRIMARY KEY,
        ${ConstantDBData.name} TEXT,
        ${ConstantDBData.country} TEXT,
        ${ConstantDBData.rate} REAL,
        ${ConstantDBData.dayDelta} TEXT,
        ${ConstantDBData.weekDelta} TEXT,
        ${ConstantDBData.monthDelta} TEXT,
        ${ConstantDBData.yearDelta} TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${ConstantDBData.infoTableName} (
        ${ConstantDBData.key} TEXT PRIMARY KEY,
        ${ConstantDBData.value} TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${ConstantDBData.historyTableName} (
        ${ConstantDBData.time} TEXT PRIMARY KEY,
        ${ConstantDBData.iso1} TEXT,
        ${ConstantDBData.iso2} TEXT,
        ${ConstantDBData.value1} REAL,
        ${ConstantDBData.value2} REAL
      )
    ''');
  }

  Future dropDB(String dbName) async {
    final db = await database;
    switch (dbName) {
      case ConstantDBData.currencyTableName:
        await db.execute('DELETE FROM ${ConstantDBData.currencyTableName};');
        await db.execute('REINDEX ${ConstantDBData.currencyTableName};');
        await db.execute('VACUUM;');
        break;
      case ConstantDBData.infoTableName:
        await db.execute('DELETE FROM ${ConstantDBData.infoTableName};');
        await db.execute('REINDEX ${ConstantDBData.infoTableName};');
        await db.execute('VACUUM;');
        break;
      default:
        await db.execute(
            'DROP TABLE IF EXISTS ${ConstantDBData.currencyTableName};');
        await db
            .execute('DROP TABLE IF EXISTS ${ConstantDBData.infoTableName};');
        await _createDB(db, ConstantDBData.databaseVersion);
    }
  }

  // Currency methods
  Future _addAllCurrencies(List<Currency> currencies) async {
    final db = await database;
    for (var currency in currencies) {
      await db.rawInsert(
        "INSERT INTO ${ConstantDBData.currencyTableName} (${ConstantDBData.iso}, ${ConstantDBData.name}, ${ConstantDBData.country}, ${ConstantDBData.rate}, ${ConstantDBData.dayDelta}, ${ConstantDBData.weekDelta}, ${ConstantDBData.monthDelta}, ${ConstantDBData.yearDelta}) VALUES (?,?,?,?,?,?,?,?)",
        [
          currency.iso,
          currency.name,
          currency.country,
          currency.rate,
          currency.dayDelta,
          currency.weekDelta,
          currency.monthDelta,
          currency.yearDelta,
        ],
      );
    }
  }

  Future updateCurrency(Currency currency) async {
    final db = await database;
    var map = currency.toMap();
    await db.update(ConstantDBData.currencyTableName, map,
        where: "${ConstantDBData.iso} = ?", whereArgs: [currency.iso]);
  }

  Future updateAllCurrencies(List<Currency> currencies) async {
    await dropDB(ConstantDBData.currencyTableName);
    await _addAllCurrencies(currencies);
  }

  Future<Currency?> getCurrency(String iso) async {
    final db = await database;
    List<Map<String, dynamic>> data = await db.query(
        ConstantDBData.currencyTableName,
        where: "${ConstantDBData.iso} = ?",
        whereArgs: [iso]);
    if (data.isNotEmpty) {
      return Currency.fromMap(Map<String, dynamic>.from(data.first));
    }
  }

  Future<List<Currency>> getAllCurrencies() async {
    final db = await database;
    List<Map<String, dynamic>> data =
        await db.query(ConstantDBData.currencyTableName);
    if (data.isNotEmpty) {
      return data.map((e) => Currency.fromMap(e)).toList();
    } else {
      return <Currency>[];
    }
  }

  Future deleteCurrency(String iso) async {
    final db = await database;
    db.delete(ConstantDBData.currencyTableName,
        where: "${ConstantDBData.iso} = ?", whereArgs: [iso]);
  }

  Future deleteAllCurrencies() async {
    final db = await database;
    // TODO: this code does not delete a row
    db.rawDelete("DELETE FROM ${ConstantDBData.currencyTableName}");
  }

  // Info methods
  Future _addInfo(String key, String value) async {
    final db = await database;
    await db.rawInsert(
      "INSERT INTO ${ConstantDBData.infoTableName} (${ConstantDBData.key}, ${ConstantDBData.value}) VALUES (?,?)",
      [
        key,
        value,
      ],
    );
  }

  Future updateInfo(String key, String value) async {
    final db = await database;
    dynamic oldValue = await getInfo(key);
    if (oldValue == ConstantDBData.unknown) {
      _addInfo(key, value);
    } else {
      await db.update(
          ConstantDBData.infoTableName,
          {
            ConstantDBData.key: key,
            ConstantDBData.value: value,
          },
          where: "${ConstantDBData.key} = ?",
          whereArgs: [key]);
    }
  }

  Future<String> getInfo(String key) async {
    final db = await database;
    List<Map<String, dynamic>> data = await db.query(
        ConstantDBData.infoTableName,
        where: "${ConstantDBData.key} = ?",
        whereArgs: [key]);
    if (data.isNotEmpty) {
      return Map<String, dynamic>.from(data.first)['value'];
    } else {
      return ConstantDBData.unknown;
    }
  }

  // Exchange methods
  Future addExchange(Exchange exchange) async {
    final db = await database;
    await db.rawInsert(
      "INSERT INTO ${ConstantDBData.historyTableName} (${ConstantDBData.time}, ${ConstantDBData.iso1}, ${ConstantDBData.iso2}, ${ConstantDBData.value1}, ${ConstantDBData.value2}) VALUES (?,?,?,?,?)",
      [
        exchange.time,
        exchange.leftCurrency!.iso,
        exchange.rightCurrency!.iso,
        exchange.leftValue,
        exchange.rightValue,
      ],
    );
  }

  Future<Exchange> getLastExchange() async {
    final db = await database;
    List<Map<String, dynamic>> data = await db.rawQuery(
        'SELECT * FROM ${ConstantDBData.historyTableName} ORDER BY ${ConstantDBData.time} DESC LIMIT 1;');
    if (data.isNotEmpty) {
      return Exchange.fromMap(data.first);
    } else {
      return Exchange();
    }
  }

  Future<Exchange> getFirstTwoCurrencies() async {
    final db = await database;
    List<Map<String, dynamic>> data = await db.rawQuery(
        'SELECT * FROM ${ConstantDBData.currencyTableName} ORDER BY ${ConstantDBData.iso} LIMIT 2;');
    DateTime now = DateTime.now();
    if (data.isNotEmpty) {
      Exchange exchange = Exchange();
      exchange.time = '${now.hour}:${now.minute} ${now.day}.${now.month}.${now.year}';
      exchange.leftValue = null;
      exchange.rightValue = null;
      exchange.leftCurrency = Currency.fromMap(data[0]);
      exchange.rightCurrency = Currency.fromMap(data[1]);
      return exchange;
    } else {
      return Exchange();
    }
  }

  Future<Exchange> getTwoCurrencies(Exchange exchange) async {
    Currency? left = await getCurrency(exchange.leftCurrency!.iso!);
    Currency? right = await getCurrency(exchange.rightCurrency!.iso!);
    return exchange..leftCurrency=left ?? Currency()..rightCurrency=right ?? Currency();
  }

  Future<List<Exchange>> getAllExchanges()async{
    final db = await database;
    List<Map<String, dynamic>> data = await db.query(ConstantDBData.historyTableName);
    if (data.isNotEmpty) {
      return data.map((e) => Exchange.fromMap(e)).toList();
    } else {
      return <Exchange>[];
    }
  }
}
