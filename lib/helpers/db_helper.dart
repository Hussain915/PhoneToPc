import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database(String table) async {
    final dbPath = await sql.getDatabasesPath();
    if (table == "user_places") {
      return sql.openDatabase(path.join(dbPath, 'places.db'),
          onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE $table(id TEXT PRIMARY KEY, title TEXT, image TEXT)");
      }, version: 1);
    } else {
      return sql.openDatabase(path.join(dbPath, 'folders.db'),
          onCreate: (db, version) {
        return db
            .execute("CREATE TABLE $table(id TEXT PRIMARY KEY, name TEXT)");
      }, version: 1);
    }
  }

  static Future<bool> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database(table);
    if (table == 'user_places') {
      db.insert(
        table,
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
      return true;
    } else {
      String name = data['name'];
      List<Map> list =
          await db.rawQuery("SELECT * FROM folders WHERE name = ?", [name]);
      if (list.isEmpty) {
        db.insert(table, data);
        return true;
      }
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database(table);
    return db.query(table);
  }

  static Future<List<Map>> getRelatedImages(String table, String fName) async {
    final db = await DBHelper.database(table);
    if (table == "user_places") {
      List<Map> list = await db
          .rawQuery("SELECT * FROM user_places WHERE title = ?", [fName]);
      return list;
    }
  }

  static Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
      print("error ${e.toString()}");
    }
  }

  static Future<void> eraseData(String folder) async {
    final db = await DBHelper.database("folders");
    final db2 = await DBHelper.database("user_places");

    List<Map> list = await getRelatedImages("user_places", folder);
    print(list);

    Future.wait(list.map((e) => deleteFile(File(e['image']))));

    db.rawQuery("DELETE FROM folders WHERE name = ?", [folder]);
    db2.rawQuery("DELETE FROM user_places WHERE title = ?", [folder]);
  }
}
