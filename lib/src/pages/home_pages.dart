import 'dart:io';

import 'package:cogniplus_mobile/src/model/adulto_model.dart';
import 'package:cogniplus_mobile/src/model/user_model.dart';
import 'package:cogniplus_mobile/src/providers/db_provider.dart';
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
  UserModel user;

  @override
  Widget build(BuildContext context) {
    user = utils.user;

    return Scaffold(
      appBar: AppBar(
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
      ),
      body: SafeArea(
        child: (utils.user.nombres == 'admin')
            ? _showDialog(context)
            : FutureBuilder<List<AdultoModel>>(
                future: DBProvider.db.getAllAdultos(user.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: Text('Sin datos.'));
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

                                    Navigator.of(context).pushNamed('video',
                                        arguments: list[index]);
                                  }),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          IconSlideAction(
                            caption: 'Editar',
                            color: Colors.black45,
                            icon: Icons.mode_edit,
                            onTap: () {
                              Navigator.of(context).pushNamed('formadulto',
                                  arguments: list[index]);
                            },
                          ),
                        ],
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Borrar',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              setState(() {
                                DBProvider.db.deleteAdultoById(list[index].id);
                                utils.showToast(
                                    context, '${list[index].nombres} borrado.');
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 50.0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.of(context).pushNamed('formadulto'),
      ),
    );
  }

  _showDialog(BuildContext context) {
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
                            context: context,
                            appName: 'Cogniplus_mobile'
                          );

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
