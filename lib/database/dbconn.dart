import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/trans.dart';

class DbConn {

  Database database;

  Future initDB() async {
    if (database != null) {
      return database;
    }

    String databasesPath = await getDatabasesPath();

    database = await openDatabase(
      join(databasesPath, 'income.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE trans(id INTEGER PRIMARY KEY, date TEXT, name TEXT, type TEXT, amount INTEGER)",
        );
      },
      version: 1,
    );

    return database;
  }

  Future<Trans> insertTrans(Trans trans) async {
    final Database db = await database;

    await db.insert(
      'trans',
      trans.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Trans>> trans() async {
    final Database db = await database;

    //final List<Map<String, dynamic>> maps = await db.query('trans');
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM trans ORDER BY cast([date] as datetime) DESC");

    return List.generate(maps.length, (i) {
      return Trans(
        id: maps[i]['id'],
        transDate: maps[i]['date'],
        transName: maps[i]['name'],
        transType: maps[i]['type'],
        amount: maps[i]['amount'],
      );
    });
  }

  Future<int> countTotal() async {
    final Database db = await database;
    final int sumEarning = Sqflite
        .firstIntValue(await db.rawQuery('SELECT SUM(amount) FROM trans WHERE type = "earning"'));
    final int sumExpense = Sqflite
        .firstIntValue(await db.rawQuery('SELECT SUM(amount) FROM trans WHERE type = "expense"'));
    return ((sumEarning  == null? 0: sumEarning) - (sumExpense == null? 0: sumExpense));
  }

  Future<int> exTotal() async {
    final Database db = await database;
    final int sumExpense = Sqflite
        .firstIntValue(await db.rawQuery('SELECT SUM(amount) FROM trans WHERE type = "expense"'));
    return sumExpense == null? 0: sumExpense;
  }

  Future<int> earnTotal() async {
    final Database db = await database;
    final int sumEarning = Sqflite
        .firstIntValue(await db.rawQuery('SELECT SUM(amount) FROM trans WHERE type = "earning"'));
    return sumEarning == null? 0: sumEarning;
  }

  Future<void> updateTrans(Trans trans) async {
    final db = await database;

    await db.update(
      'trans',
      trans.toMap(),
      where: "id = ?",
      whereArgs: [trans.id],
    );
  }

  Future<void> deleteTrans(int id) async {
    final db = await database;

    await db.delete(
      'trans',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}