import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/read.dart';

final String tableName = 'read';

class DBHelper {
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'blueChristmas.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          ''' CREATE TABLE $tableName (bookId INTEGER PRIMARY KEY, complete BIT) ''');
    });
  }

  // CREATE
  createData(Read read) async {
    final db = await database;
    var res = await db.insert(tableName, read.toJson());
    return res;
  }

  // READ
  getRead(int bookId) async {
    final db = await database;
    var res =
        await db.query(tableName, where: 'bookId = ?', whereArgs: [bookId]);
    return res.isNotEmpty ? Read.fromJson(res.first) : Null;
  }

  // READ ALL DATA
  getAllReads() async {
    final db = await database;
    var res = await db.query(tableName);
    List<Read> list =
        res.isNotEmpty ? res.map((c) => Read.fromJson(c)).toList() : [];
    return list;
  }

  // Update Read
  updateRead(Read read) async {
    final db = await database;
    var res = await db.update(tableName, read.toJson(),
        where: 'bookId = ?', whereArgs: [read.bookId]);
    return res;
  }

  // Delete Read
  deleteRead(int bookId) async {
    final db = await database;
    db.delete(tableName, where: 'bookId = ?', whereArgs: [bookId]);
  }

  // Delete All Reads
  deleteAllReads() async {
    final db = await database;
    db.rawDelete('DELETE FROM $tableName');
  }
}
