import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper{
  static Database? _db;


// open database
  static Future<Database> get database async
  {
if(_db != null) return _db! ;
String path = join( await
             getDatabasesPath(),
  "expense.db",
);
_db = await openDatabase(path , version: 1,

  onCreate: (db,version) async {
  await db.execute('''
  CREATE TABLE expenses(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT,
  amount REAL
  )
  ''');
  },
);




return _db!;

  }

  //insert value
  static Future<int> insertExpense(
      String title, double amount) async {

    final db = await database;

    return await db.insert(
      'expenses',
      {
        'title': title,
        'amount': amount,
     //   'date': DateTime.now().toIso8601String(),
      },
    );
  }

  static Future<List<Map<String,dynamic>>> getExpense() async
  {
final db = await database;

return await db.query('expenses');
  }

  static Future<int> deleteExpense( int id ) async
  {
        final db = await database;
        return  await db.delete('expenses',
        where: 'id = ?',
        whereArgs: [id],);
  }


}
