import 'dart:async';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{

  static final DbHelper _instance= DbHelper.getInstance();
  DbHelper.getInstance();

  factory DbHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDb();

    return _db;
  }

  Future _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'carros.db');
    print("db $path");

    var db = await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    String s = await rootBundle.loadString("assets/sql/create.sql");

    List<String> sqls = s.split(";");

    try {
      for(String sql in sqls){
        if(sql.trim().isNotEmpty){
          print("sql: $sql");
          await db.execute(s);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<FutureOr<void>> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("_onUpgrade: oldVersion: $oldVersion > newVersion: $newVersion");

    if(newVersion == 2) {
      await db.execute("CREATE TABLE favorito(id INTEGER PRIMARY KEY, nome TEXT)");
    }
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

}