import 'dart:convert';
import 'dart:io';
import 'package:cogniplus_mobile/src/model/historial_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cogniplus_mobile/src/model/adulto_model.dart';
import 'package:cogniplus_mobile/src/model/user_model.dart';
import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;

class DBProvider {
  static Database _dataBase;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_dataBase != null) return _dataBase;

    _dataBase = await initDB();
    return _dataBase;
  }

  Future<Database> initDB() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'cogniplus.db');

    return openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (db, version) async {
      await db.execute('CREATE TABLE USERS ('
          ' id INTEGER PRIMARY KEY AUTOINCREMENT, '
          ' name TEXT, '
          ' email TEXT,'
          ' password TEXT)');

      await db.execute('CREATE TABLE USERS_ADULTOS ('
          ' id INTEGER PRIMARY KEY AUTOINCREMENT, '
          ' id_user INTEGER, '
          ' id_adulto INTEGER)');

      await db.execute('CREATE TABLE ADULTOS ('
          ' id INTEGER PRIMARY KEY AUTOINCREMENT, '
          ' rut TEXT, '
          ' nombres TEXT, '
          ' apellidos TEXT, '
          ' sexo TEXT, '
          ' escolaridad TEXT, '
          ' fechaNacimiento TEXT, '
          ' ingresos TEXT, '
          ' fono TEXT, '
          ' m1 INTEGER, '
          ' m2 INTEGER, '
          ' m3 INTEGER, '
          ' m4 INTEGER, '
          ' m1v TEXT, '
          ' m2v TEXT, '
          ' m3v TEXT, '
          ' m4v TEXT, '
          ' infoAdicional TEXT)');

      await db.execute('CREATE TABLE HISTORIAL ('
          ' id INTEGER PRIMARY KEY AUTOINCREMENT, '
          ' id_video INTEGER,'
          ' id_modulo INTEGER,'
          ' id_adulto INTEGER,'
          ' titulo TEXT, '
          ' fecha TEXT, '
          ' resp1 TEXT, '
          ' resp2 TEXT, '
          ' evaluacion TEXT, '
          ' visualizaciones INTEGER, '
          ' enviado INTEGER DEFAULT 0)');
/*
      await db.insert(
          'USERS',
          UserModel(id: 1, rut: '111111111', nombres: 'admin', pass: 'admin')
              .toJson());
      await db.insert(
          'USERS',
          UserModel(id: 2, rut: '222222222', nombres: 'casa1', pass: 'casa1')
              .toJson());
      await db.insert(
          'USERS',
          UserModel(id: 3, rut: '333333333', nombres: 'casa2', pass: 'casa2')
              .toJson());
      await db.insert(
          'USERS',
          UserModel(id: 4, rut: '444444444', nombres: 'casa3', pass: 'casa3')
              .toJson());*/
/*
      await db.insert('USERS_ADULTOS', {'id': 1, 'id_user': 2, 'id_adulto': 1});
      await db.insert('USERS_ADULTOS', {'id': 2, 'id_user': 2, 'id_adulto': 2});
      await db.insert('USERS_ADULTOS', {'id': 3, 'id_user': 2, 'id_adulto': 3});
      await db.insert('USERS_ADULTOS', {'id': 4, 'id_user': 2, 'id_adulto': 4});
      await db.insert('USERS_ADULTOS', {'id': 5, 'id_user': 2, 'id_adulto': 5});

      await db.insert(
          'ADULTOS',
          AdultoModel(
                  id: 1,
                  rut: '11111111-1',
                  nombres: 'Maria',
                  apellidos: 'Dolores Quezada',
                  sexo: 'F',
                  escolaridad: 'Enseñanza superior completa',
                  fechaNacimiento: '10-10-1950',
                  ingresos: '400000',
                  fono: '(56) 961016653',
                  m1: 1,
                  m2: 0,
                  m3: 0,
                  m4: 0,
                  m1v: '[1,0,0,0,0,0,0]',
                  m2v: '[0,0,0,0,0,0]',
                  m3v: '[0,0,0,0,0,0]',
                  m4v: '[0,0,0,0,0,0]',
                  infoAdicional: 'Información Adicional del adulto mayor.')
              .toJson());
      await db.insert(
          'ADULTOS',
          AdultoModel(
                  id: 2,
                  rut: '22222222-2',
                  nombres: 'Rodolfo',
                  apellidos: 'Gonzáles Baéz',
                  sexo: 'M',
                  escolaridad: 'Enseñanza media incompleta',
                  fechaNacimiento: '11-11-1960',
                  ingresos: '380000',
                  fono: '(56) 931016653',
                  m1: 1,
                  m2: 0,
                  m3: 0,
                  m4: 0,
                  m1v: '[1,0,0,0,0,0,0]',
                  m2v: '[0,0,0,0,0,0]',
                  m3v: '[0,0,0,0,0,0]',
                  m4v: '[0,0,0,0,0,0]',
                  infoAdicional: 'Información Adicional del adulto mayor.')
              .toJson());
      await db.insert(
          'ADULTOS',
          AdultoModel(
                  id: 3,
                  rut: '33333333-3',
                  nombres: 'Juan',
                  apellidos: 'Castillo Flores',
                  sexo: 'M',
                  escolaridad: 'Enseñanza básica incompleta',
                  fechaNacimiento: '1-10-1940',
                  ingresos: '200000',
                  fono: '(56) 921076653',
                  m1: 1,
                  m2: 0,
                  m3: 0,
                  m4: 0,
                  m1v: '[1,0,0,0,0,0,0]',
                  m2v: '[0,0,0,0,0,0]',
                  m3v: '[0,0,0,0,0,0]',
                  m4v: '[0,0,0,0,0,0]',
                  infoAdicional: 'Información Adicional del adulto mayor.')
              .toJson());
      await db.insert(
          'ADULTOS',
          AdultoModel(
                  id: 4,
                  rut: '44444444-4',
                  nombres: 'Paola',
                  apellidos: 'Contardo Béliz',
                  sexo: 'F',
                  escolaridad: 'Enseñanza superior incompleta',
                  fechaNacimiento: '10-10-1960',
                  ingresos: '800000',
                  fono: '(56) 936016653',
                  m1: 1,
                  m2: 0,
                  m3: 0,
                  m4: 0,
                  m1v: '[1,0,0,0,0,0,0]',
                  m2v: '[0,0,0,0,0,0]',
                  m3v: '[0,0,0,0,0,0]',
                  m4v: '[0,0,0,0,0,0]',
                  infoAdicional: 'Información Adicional del adulto mayor.')
              .toJson());
      await db.insert(
          'ADULTOS',
          AdultoModel(
                  id: 5,
                  rut: '55555555-5',
                  nombres: 'Flor',
                  apellidos: 'Cáceres Márquez',
                  sexo: 'F',
                  escolaridad: 'Enseñanza media incompleta',
                  fechaNacimiento: '12-5-1945',
                  ingresos: '350000',
                  fono: '(56) 956016653',
                  m1: 1,
                  m2: 0,
                  m3: 0,
                  m4: 0,
                  m1v: '[1,0,0,0,0,0,0]',
                  m2v: '[0,0,0,0,0,0]',
                  m3v: '[0,0,0,0,0,0]',
                  m4v: '[0,0,0,0,0,0]',
                  infoAdicional: 'Información Adicional del adulto mayor.')
              .toJson());
              */
    });
  }

  //SELECT * FROM paises p, paises_estados pe WHERE (p.id = pe.id_pais) AND (p.id = 2)

/* TABLA HISTORIAL */

  Future<List<HistorialModel>> getAllHistorial() async {
    final db = await database;
    final res = await db.query('HISTORIAL');

    return (res.isNotEmpty)
        ? res.map((historial) => HistorialModel.fromJson(historial)).toList()
        : [].toList();
  }

  updateHistorial(HistorialModel historial) async {
    final db = await database;

    final res = db.update('HISTORIAL', historial.toJson(),
        where: 'id = ?', whereArgs: [historial.id]);
    print(res.toString());
    return res;
  }

  updateEnviadoHistorial(int id) async {
    final db = await database;

    final sql = 'UPDATE HISTORIAL SET enviado = 1 WHERE (id = $id)';
    await db.rawQuery(sql);
  }

  insertHistorial(HistorialModel historial) async {
    final db = await database;
    final res = await db.insert('HISTORIAL', historial.toJson());
    return res;
  }

  dynamic getVisualizaciones(int idAdulto, int idModulo, int idVideo) async {
    final db = await database;
    final sql =
        'SELECT count(visualizaciones) as total FROM HISTORIAL WHERE (id_adulto = $idAdulto) AND (id_modulo = $idModulo) AND (id_video = $idVideo)';
    final res = await db.rawQuery(sql);
    int total = res.toList()[0]['total'];
    return (total == null) ? 0 : total;
  }

  Future<HistorialModel> getHistorialId(int id) async {
    final db = await database;
    final res = await db.query('HISTORIAL', where: 'id = ?', whereArgs: [id]);
    return (res.isNotEmpty) ? HistorialModel.fromJson(res.first) : null;
  }

  Future<List<HistorialModel>> getHistorial(
      int idAdulto, int idModulo, int idVideo) async {
    final db = await database;
    if (idAdulto == null || idModulo == null || idVideo == null)
      return [].toList();

    final res = await db.query('HISTORIAL',
        where: '(id_adulto = ?) AND (id_modulo = ?) AND (id_video = ?)',
        whereArgs: [idAdulto, idModulo, idVideo],
        orderBy: 'fecha');

    return (res.isNotEmpty)
        ? res.map((linea) => HistorialModel.fromJson(linea)).toList()
        : null;
  }

/* TABLA ADULTO */
  getAdultoByid(int id) async {
    final db = await database;
    final res = await db.query('ADULTOS', where: 'id = ?', whereArgs: [id]);

    return (res.isNotEmpty) ? AdultoModel.fromJson(res.first) : AdultoModel();
  }

  insertAdultoBtnBottom(AdultoModel adulto, idModulo, digito) async {
    //print('$idAdulto : $idModulo ----> $digito');
    final db = await database;

    adulto = await getAdultoByid(adulto.id);
    var vector;
    switch (idModulo) {
      case 1:
        vector = jsonDecode(adulto.m1v);
        break;
      case 2:
        vector = jsonDecode(adulto.m2v);
        break;
      case 3:
        vector = jsonDecode(adulto.m3v);
        break;
      case 4:
        vector = jsonDecode(adulto.m4v);
        break;
    }
    vector[digito - 1] = 1;

    final sql =
        'UPDATE ADULTOS SET m${idModulo}v = "$vector"  WHERE (id = ${adulto.id})';
    //print(sql);
    await db.rawUpdate(sql);

    return vector;
  }

  Future<int> updateModuloAdulto(AdultoModel adulto) async {
    final db = await database;
    final res = db.update('ADULTOS', adulto.toJson(),
        where: 'id = ?', whereArgs: [adulto.id]);

    return res;
  }

  insertAdulto(AdultoModel adulto) async {
    final db = await database;
    final res = await db.insert('ADULTOS', adulto.toJson());
    final re = await db
        .insert('USERS_ADULTOS', {'id_user': utils.user.id, 'id_adulto': res});
    print(re.toString());
    return res;
  }

  Future<int> updateAdulto(AdultoModel adulto) async {
    final db = await database;
    final res = db.update('ADULTOS', adulto.toJson(),
        where: 'id = ?', whereArgs: [adulto.id]);

    return res;
  }

  Future<int> deleteAdultoById(int id) async {
    final db = await database;
    final res = await db.delete('ADULTOS', where: 'id = ?', whereArgs: [id]);
    final re = await db
        .delete('USERS_ADULTOS', where: 'id_adulto = ?', whereArgs: [id]);
    print(re.toString());
    return res;
  }

  Future<List<AdultoModel>> getAllAdultos(int userId) async {
    final db = await database;
    final sql =
        'SELECT a.* FROM ADULTOS a, USERS_ADULTOS ua WHERE (a.id = ua.id_adulto) AND (ua.id_user = $userId)';

    //final sql = "SELECT * FROM ADULTOS";
    final res = await db.rawQuery(sql);

    List<AdultoModel> list =
        res.map((adulto) => AdultoModel.fromJson(adulto)).toList();

    return (res.isNotEmpty) ? list : <AdultoModel>[].toList();
  }

/* TABLA USUARIO */

  insertUser(UserModel user) async {
    final db = await database;
    final res = await db.insert('USERS', user.toJson());

    return res;
  }

  Future<bool> verifyUserPass({String email, String password}) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM USERS WHERE (email = "$email") AND (password="$password") LIMIT 1');

    return res.isEmpty ? false : true;
  }

  dynamic getUserByName(String name) async {
    final db = await database;
    final res = await db.query('USERS', where: 'name = ?', whereArgs: [name]);

    return (res.isNotEmpty) ? UserModel.fromJson(res.first) : null;
  }

  dynamic getUserBy({String field, String value}) async {
    final db = await database;
    final res =
        await db.query('USERS', where: '$field = ?', whereArgs: [value]);

    return (res.isNotEmpty) ? UserModel.fromJson(res.first) : null;
  }

  Future<UserModel> getUserById(int id) async {
    final db = await database;
    final res = await db.query('USERS', where: 'id = ?', whereArgs: [id]);

    return (res.isNotEmpty) ? UserModel.fromJson(res.first) : null;
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final res = await db.query('USERS');

    return (res.isNotEmpty)
        ? res.map((user) => UserModel.fromJson(user)).toList()
        : [].toList();
  }

  Future<int> updateUser(UserModel user) async {
    final db = await database;
    final res = db
        .update('USERS', user.toJson(), where: 'id = ?', whereArgs: [user.id]);

    return res;
  }

  Future<int> deleteUserById(int id) async {
    final db = await database;
    final res = await db.delete('USERS', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllUsers() async {
    final db = await database;
    final res = await db.delete('USERS');
    return res;
  }
}
