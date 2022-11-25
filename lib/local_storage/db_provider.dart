// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';

import 'package:core/encryption/encrypt.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

///```
/// Note
///  Use with await
///   Example
///     TestDB() async{
///       var db = DBProvider()
///
///       await db.open(path,sql);
///     }
///
///```

class DBProvider {
  late Database db;
  var msg = '';

  Future<String> getPath(String tableName) async {
    return join(await getDatabasesPath(), '$tableName.db');
  }

  ///```
  ///
  ///Example
  ///*** import 'package:path/path.dart'; ***
  /// await db.open(sql,getPath('tableName'));
  ///
  ///```

  Future<String> open(String sql, path) async {
    // await deleteDatabase(path);

    db = await openDatabase(
      path,
      version: 1,
      onCreate: ((db, version) async {
        try {
          await db.execute(sql);
          msg = 'create db success';
        } catch (e) {
          msg = e.toString();
        }
      }),
    );
    return msg;
  }

  ///```
  ///
  ///Example
  /// await db.insert(tableName,Model);
  ///
  ///```
  Future<String> insert(String tableName, Map<String, Object?> map) async {
    try {
      for (var count = 0; count < map.length; count++) {
        map.update(
          map.keys.elementAt(count),
          (value) =>
              Encrypt().encryptData(map.values.elementAt(count).toString()),
        );
      }
      await db.insert(tableName, map);
      msg = 'insert success';
    } catch (e) {
      msg = e.toString();
    }
    return msg;
  }

  /// ```
  /// Example
  /// await db.getData(tableName);
  ///
  /// ```

  Future<String?> getData(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    var condition = [];
    if (whereArgs != null) {
      for (var element in whereArgs) {
        element = Encrypt().encryptData(element.toString());
        log(element.toString());
        condition.add(element);
      }
    }
    List<Map<String, Object?>> maps = await db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: condition,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
    if (maps.isNotEmpty) {
      List<Map<String, dynamic>> resp = [];
      for (var count = 0; count < maps.length; count++) {
        var data = Map<String, dynamic>.from(maps.elementAt(count));
        for (var countData = 0; countData < data.length; countData++) {
          data.update(
              data.keys.elementAt(countData),
              (value) =>
                  Encrypt().decryptData(data.values.elementAt(countData)));
        }

        // log(data.toString());

        resp.add(data);
      }

      return jsonEncode(resp);
    } else {
      return null;
    }
  }

  /// ```
  ///
  /// Example
  /// await db.delete(table);
  ///
  /// ```
  Future<String> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    var condition = [];
    if (whereArgs != null) {
      for (var element in whereArgs) {
        element = Encrypt().encryptData(element.toString());
        condition.add(element);
      }
    }
    try {
      msg = 'delete success ${await db.delete(
        table,
        where: where,
        whereArgs: condition,
      )} items';
    } catch (e) {
      msg = e.toString();
    }

    return msg;
  }

  ///```
  ///
  ///Example
  ///await db.update(tableName,values: Model,where: '$columnId = ?', whereArgs: [Model.args]);
  ///
  /// ```
  Future<String> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    var condition = [];
    if (whereArgs != null) {
      for (var element in whereArgs) {
        element = Encrypt().encryptData(element.toString());
        condition.add(element);
      }
    }
    Map<String, Object?> resp;

    var data = Map<String, Object>.from(values);
    for (var countData = 0; countData < data.length; countData++) {
      data.update(
          data.keys.elementAt(countData),
          (value) => Encrypt()
              .encryptData(data.values.elementAt(countData).toString()));
    }

    // log(data.toString());

    resp = data;

    try {
      msg = 'update success ${await db.update(
        table,
        resp,
        where: where,
        whereArgs: condition,
        conflictAlgorithm: conflictAlgorithm,
      )} items';
    } catch (e) {
      msg = e.toString();
    }

    return msg;
  }

  Future close() async => db.close();
}
