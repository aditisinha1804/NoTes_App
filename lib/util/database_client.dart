import 'package:notodo_app/model/nodo_item.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  final String tableUser = "userTable";
  final String columnId = "id";
  final String columnUsername = "itemName";
  final String columnPassword = "dateCreated";
final String nyaColumn="data";
  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
 DatabaseHelper.internal();
  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "maindb.88882db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }
  void _onCreate(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $tableUser($columnId INTEGER PRIMARY KEY,$nyaColumn TEXT, $columnUsername TEXT, $columnPassword TEXT)");
  }
  Future<int> saveItem(NoDoItem item) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableUser", item.toMap());
    return res;
  }
  Future<List> getItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * From $tableUser");
    return result.toList();
  }
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*)FROM $tableUser"));
  }
  Future<NoDoItem> getItem(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableUser WHERE $columnId= $id");
    if (result.length == 0) return null;
    return new NoDoItem.fromMap(result.first);
   }
  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
        tableUser, where: "$columnId= ?",whereArgs: [id]);
  }
  Future<int> updateItem(NoDoItem) async {
    var dbClient = await db;
    return await dbClient.update(tableUser, NoDoItem.toMap(),
        where: "$columnId= ?",whereArgs: [NoDoItem.id]);
  }
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
