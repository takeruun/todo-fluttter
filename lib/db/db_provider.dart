import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/todo_list.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'todo_list.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("""
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        sub_title TEXT,
        is_done INTEGER
      )
        """);
    });
  }

  getTodoList(int id) async {
    final db = await database;
    var res = await db.query('todos', where: 'id = ?', whereArgs: [id]);
    return TodoList.fromMap(res.first);
  }

  insertTodoList(TodoList newTodo) async {
    final db = await database;
    //await db.insert('todos', {'title': title, 'sub_title': subTitle, 'is_done': 0});
    await db.insert('todos', newTodo.toMap());
  }

  updateTodoList(TodoList newtodolist) async {
    final db = await database;
    var res = await db.update('todos', newtodolist.toMap(),
        where: 'id = ?', whereArgs: [newtodolist.id]);
    return res;
  }

  deleteTodoList(int id) async {
    final db = await database;
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  uncompletedTodo(int id, int status) async {
    final db = await database;
    await db.update('todos', {'is_done': status},
        where: 'id = ?', whereArgs: [id]);
  }

  w completeTodo(int id, int status) async {
    final db = await database;
    await db.update('todos', {'is_done': status},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<List<TodoList>> getAllTodoLists() async {
    final db = await database;
    var res = await db.query('todos', where: 'is_done = ?', whereArgs: [0]);
    return res.isNotEmpty ? res.map((n) => TodoList.fromMap(n)).toList() : [];
  }

  Future<List<TodoList>> getAllCompleteTodoList() async {
    final db = await database;
    var res = await db.query('todos', where: 'is_done = ?', whereArgs: [1]);
    return res.isNotEmpty ? res.map((n) => TodoList.fromMap(n)).toList() : [];
  }
}
