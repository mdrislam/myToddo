import 'package:my_todo/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tablename = 'tasks';

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        print('Create A New One');

        return db.execute(
          "CREATE TABLE $_tablename("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "title STRING, note TEXT, date STRING, "
          "startTime STRING, endTime STRING, "
          "remind INTEGER, repeat STRING, "
          "color INTEGER, "
          "isCompleted INTEGER)",
        );
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    print('Insert function Called');
    return await _db?.insert(_tablename, task!.tojson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> queryTasks() {
    return _db!.query(_tablename);
  }
  static delete(Task task)async{
    await _db!.delete(_tablename,where: 'id=?',whereArgs: [task.id]);
  }
}
