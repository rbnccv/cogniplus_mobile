import 'dart:convert';

import 'package:cogniplus_mobile/src/model/adulto_model.dart';
import 'package:cogniplus_mobile/src/pages/register_senior_page.dart';
import 'package:cogniplus_mobile/src/pages/video_pages.dart';
import 'package:cogniplus_mobile/src/providers/api.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SeniorListPage extends StatefulWidget {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  _SeniorListPageState createState() => _SeniorListPageState();
}

class _SeniorListPageState extends State<SeniorListPage> {
  ConnectivityResult _connectivity;

  @override
  void initState() {
    super.initState();
    _setConnectivity();
    WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => widget._refreshKey.currentState.show());
  }

  _setConnectivity() async {
    _connectivity = await Connectivity().checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: _appBar(context),
        body: SafeArea(
            child: RefreshIndicator(
                key: widget._refreshKey,
                semanticsLabel: "Loading list of Seniors",
                onRefresh: () async {
                  setState(() {
                    _drawList(context);
                  });
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
                builder: (BuildContext context) => RegisterSeniorPage()));
          },
        ),
      ),
      onWillPop: () => showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Advertencia"),
                content: Text("¿Desea salir de la Aplicación?"),
                actions: [
                  FlatButton(
                      onPressed: () => SystemChannels.platform
                          .invokeMethod("SystemNavigator.pop"),
                      child: Text("SI")),
                  FlatButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text("NO"))
                ],
              )),
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
              onPressed: () {
                utils.showIntroVideo(context);
              }),
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

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  VideoPage(adulto: list[index])));

                          // Navigator.of(context)
                          //     .pushNamed('video', arguments: list[index].id);
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
                            RegisterSeniorPage(adulto: list[index])));
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
                    if (_connectivity != ConnectivityResult.none) {
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
    return _fromNetwork(context);
  }

  Future<List<AdultoModel>> _fromNetwork(BuildContext context) async {
    utils.showToast(context, "En linea");
    var id = utils.user.id;
    var response =
        await Api().getDataFromApi(url: '/user/' + id.toString() + '/seniors');

    print(json.decode(response.body));

    var body = (json.decode(response.body) as List).map((json) {
      return AdultoModel(
          id: json['id'],
          nombres: json['names'],
          apellidos: json['last_names'],
          sexo: json['gender'].toString(),
          escolaridad: json['course'],
          fechaNacimiento: json['birthday'],
          fono: json['phone'],
          ingresos: json['revenue'].toString(),
          infoAdicional: json['info'],
          rut: json['rut']);
    }).toList();

    return body;
  }
}
