import 'dart:io';

import 'package:demo_app/Message.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // if _database is null we instantiate it
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationCacheDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Message ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "time TEXT,"
          "content TEXT"
          ")");
    });
  }

  newMessage(Message newMessage) async {
    final db = await database;
    var res = await db.insert('Message', newMessage.toMap());
    return res;
  }

  Future<List<Message>> getAllMessage() async {
    final db = await database;
    var res = await db.query("Message");
    List<Message> list = res.isNotEmpty ? res.map((c) => Message.fromMap(c)).toList() : [];
    return list;
  }
}