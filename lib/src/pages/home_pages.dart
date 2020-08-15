import 'dart:convert';
import 'dart:io';

import 'package:cogniplus_mobile/src/model/adulto_model.dart';
import 'package:cogniplus_mobile/src/pages/form_adulto_pages.dart';
import 'package:cogniplus_mobile/src/providers/api.dart';
import 'package:cogniplus_mobile/src/providers/db_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:path/path.dart';

//import 'package:flutter/src/services/system_sound.dart';

//Text('headline', style: Theme.of(context).textTheme.headline,),

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<RefreshIndicatorState> _refreshKey;
  ConnectivityResult _connectivity;

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    _setConnectivity();
  }

  _setConnectivity() async {
    _connectivity = await Connectivity().checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SafeArea(
          child: (utils.user.name == 'admin')
              ? _showDialogSaveDatabase(context)
              : RefreshIndicator(
                  key: _refreshKey,
                  semanticsLabel: "semantic label",
                  onRefresh: () async {
                    _drawList(context);
                  },
                  child: _drawList(context))),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 50.0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          //Navigator.of(context).pushNamed('formadulto');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => FormAdultoPage()));
        },
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
              icon: Icon(
                FontAwesomeIcons.question,
                color: Colors.white,
              ),
              onPressed: () {}),
          Text(
            'Seleccione perfil',
            style: utils.estTitulo,
          ),
          IconButton(
              icon: Icon(
                FontAwesomeIcons.powerOff,
                color: Colors.white,
              ),
              onPressed: () {
                utils.logoff(context);
              }),
        ],
      ),
    );
  }

  FutureBuilder<List<AdultoModel>> _drawList(BuildContext context) {
    return FutureBuilder<List<AdultoModel>>(
      future: _getList(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: Text('Sin datos.'));
        final list = snapshot.data;
        if (list.isEmpty) return Text('No existen datos');

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Slidable(
              key: Key(list[index].id.toString()),
              closeOnScroll: true,
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 400.0,
                  height: 90.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                        color: const Color(0xff259587),
                        child: Text(
                            //'adult_id: ${list[index].id} | user_id:${utils.user.id} - nombres:${list[index].nombres} ${list[index].apellidos}',
                            '${list[index].nombres} ${list[index].apellidos}',
                            style: utils.estBodyWhite18),
                        onPressed: () {
                          //SystemSound.play(SystemSoundType.click);

                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (BuildContext context) =>
                          //         FormAdultoPage(adulto: list[index])));
                          Navigator.of(context)
                              .pushNamed('video', arguments: list[index].id);
                        }),
                  ),
                ),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Editar',
                  color: Colors.black45,
                  icon: Icons.mode_edit,
                  onTap: () async {
                    //Navigator.of(context)
                    //    .pushNamed('formadulto', arguments: list[index]);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            FormAdultoPage(adulto: list[index])));
                  },
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Borrar',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () async {
                    var id = list[index].id;
                    if (_connectivity == ConnectivityResult.none) {
                      DBProvider.db.deleteAdultoById(id);
                      utils.showToast(
                          context, '${list[index].nombres} borrado.');
                    } else {
                      var response = await Api()
                          .delDataFromApi(url: '/seniors/' + id.toString());
                      var body = await json.decode(response.body);
                      utils.showToast(context, body["message"]);
                      //utils.showToast(context, '$body["message"] borrado.');
                    }

                    setState(() {});
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<List<AdultoModel>> _getList(BuildContext context) async {
    if (_connectivity == ConnectivityResult.none) {
      return _fromDatabase(context);
    } else {
      return _fromNetwork(context);
    }
  }

  Future<List<AdultoModel>> _fromDatabase(BuildContext context) {
    return DBProvider.db.getAllAdultos(utils.user.id);
  }

  Future<List<AdultoModel>> _fromNetwork(BuildContext context) async {
    utils.showToast(context, "En linea");
    var id = utils.user.id;
    var response =
        await Api().getDataFromApi(url: '/user/' + id.toString() + '/seniors');

    var body = (json.decode(response.body) as List).map((json) {
      return AdultoModel(
          id: json['id'],
          nombres: json['names'],
          apellidos: json['last_names'],
          //sexo: json['gender'].toString(),
          escolaridad: json['course'],
          fechaNacimiento: json['birthday'],
          fono: json['phone'],
          //ingresos: json['revenue'].toString(),
          infoAdicional: json['info'],
          rut: json['rut']);
    }).toList();

    return body;
  }

  _showDialogSaveDatabase(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: size.width * 0.85,
              margin: EdgeInsets.symmetric(vertical: 30.0),
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Obtención de datos.',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 30.0),
                  Text(
                    'La datos se almacenaran en el directorio download.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 25.0),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey)),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 70.0, vertical: 15.0),
                          child: Text(
                            'DESCARGAR.',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        elevation: 0.0,
                        color: Colors.white,
                        textColor: Colors.grey,
                        onPressed: () async {
                          /*await SimplePermissions.requestPermission(
                              Permission.WriteExternalStorage);
                          bool checkPermission =
                              await SimplePermissions.checkPermission(
                                  Permission.WriteExternalStorage);*/
                          final permission = EasyPermissionValidator(
                              context: context, appName: 'Cogniplus_mobile');

                          final checkPermission = await permission.storage();

                          if (checkPermission) {
                            final Directory directory =
                                await getApplicationDocumentsDirectory();
                            final path = join(directory.path, 'cogniplus.db');
                            String newPath =
                                (await getExternalStorageDirectory())
                                        .absolute
                                        .path +
                                    "/download/cogniplus.db";

                            File file = new File(path);
                            file.copy(newPath);

                            (await file.exists())
                                ? utils.showToast(
                                    context, 'Base de datos en: $newPath')
                                : utils.showToast(context,
                                    'Error al copiar la base de datos.');
                          }
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
