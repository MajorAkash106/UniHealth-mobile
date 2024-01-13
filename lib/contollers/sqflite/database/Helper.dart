
import 'package:medical_app/contollers/sqflite/model/User.dart';
import 'package:medical_app/contollers/sqflite/utils/Utils.dart';import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';

class Helper {
  static final Helper _instance = new Helper.internal();
  factory Helper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
          create table $tableUser ( 
          $columnId integer primary key autoincrement, 
          $columnName text not null,
          $columnPhone text not null,
          $columnEmail email not null)
          ''');
    });
    return theDb;
  }


  Helper.internal();

  Future<User> insert(User user) async {
    var dbClient = await db;
    user.id = await dbClient.insert(tableUser, user.toMap());
    return user;
  }

  Future<User> getUser(int id) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableUser,
        columns: [columnId, columnName, columnPhone, columnEmail],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableUser, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(User user) async {
    var dbClient = await db;
    return await dbClient.update(tableUser, user.toMap(),
        where: '$columnId = ?', whereArgs: [user.id]);
  }

 Future<List> getAllUsers() async {
    List<User> user = List();
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableUser,
        columns: [columnId, columnName, columnPhone, columnEmail]);
    if (maps.length > 0) {
      maps.forEach((f) {
        user.add(User.fromMap(f));
//          print("getAllUsers"+ User.fromMap(f).toString());
      });
    }
    return user;
  }


  Future<bool> chackDb() async {
    bool result =false;
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableUser,
        columns: [columnId, columnName, columnPhone, columnEmail]);
    if (maps.length > 0) {
      result = true;
    }else{
      result = false;
    }
    return result;
  }



  Future<List> searching(String text) async {
    List<User> user = List();
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableUser,
        columns: [columnId, columnName, columnPhone, columnEmail],);
    if (maps.length > 0) {

     // var a =  maps.singleWhere((element) => User.fromMap(element).name.toLowerCase().contains(text));
     // print(a);
     //  user.add(User.fromMap(a));

      maps.forEach((f) {
        print('helooo');
        print('$text');
        print(User.fromMap(f).name.replaceAll(' ', '').toLowerCase());
        print(User.fromMap(f).name.replaceAll(' ', '').toLowerCase().contains('b'));
        if(User.fromMap(f).name.replaceAll(' ', '').toLowerCase().contains(text.toLowerCase().trim())) {
          print('yess contain');
          user.add(User.fromMap(f));
        }
      });
    }
    return user;
  }



  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
