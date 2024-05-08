import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initDb() async {
    if (_db != null) {
      debugPrint('not null db');
      return;
    } else {
      try {
        String path = '${await getDatabasesPath()}task.db';
        _db = await openDatabase(path, version: _version,
            onCreate: (Database db, int version) async {
          debugPrint('creating a new one');
          await db.execute('CREATE TABLE $_tableName('
              'id INTEGER PRIMARY KEY AUTOINCREMENT,'
              'title STRING,note TEXT, date STRING,'
              'startTime STRING, endTime STRING,'
              'remind INTEGER, repeat STRING,'
              'color INTEGER,'
              'isCompleted INTEGER)');
        });
      } catch (e) {
        log(e.toString());
      }
    }
  }

  static Future<int> insert(Task? task) async {
    log('insert function called');
    try {
      return await _db!.insert(_tableName, task!.toJson());
    } catch (e) {
      log('we are here');
      return 90000;
    }
  }

  static Future<int> delete(Task task) async {
    log('delete function called');
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> deleteAll() async {
    log('delete All function called');
    return await _db!.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    log('query function called');
    return await _db!.query(_tableName);
  }

  static Future<int> update(int id) async {
    log('Update function called');
    return await _db!.rawUpdate('''
UPDATE tasks
SET isCompleted = ?
WHERE id = ?
''', [1, id]);
  }
}
