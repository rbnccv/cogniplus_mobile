import 'dart:convert';

import 'package:cogniplus_mobile/src/model/adulto_model.dart';
import 'package:cogniplus_mobile/src/pages/register_senior_page.dart';
import 'package:cogniplus_mobile/src/pages/video_pages.dart';
import 'package:cogniplus_mobile/src/providers/api.dart';
import 'package:cogniplus_mobile/src/providers/userSharedPreferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

extension on AnimationController {
  void repeatEx({@required int times}) {
    var count = 0;

    addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (++count < times) {
          reverse();
        }
      } else if (status == AnimationStatus.dismissed) {
        forward();
      }
    });
  }
}

class SeniorListPage extends StatefulWidget {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  _SeniorListPageState createState() => _SeniorListPageState();
}

class _SeniorListPageState extends State<SeniorListPage>
    with SingleTickerProviderStateMixin {
  ConnectivityResult  _connectivity;
  AnimationController _controller;
  Animation<double>   _animation;
  Animation           _opacity;
  Size                _size;
  Orientation         _isPortrait;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    final _curve = CurvedAnimation(parent: _controller, curve: Curves.ease);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_curve);
    _opacity = Tween(begin: 1.0, end: 0.0).animate(_controller);

    _setConnectivity();
    WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => widget._refreshKey.currentState.show());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _setConnectivity() async {
    _connectivity = await Connectivity().checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    _isPortrait = MediaQuery.of(context).orientation;
    _size = MediaQuery.of(context).size;

    _controller
      ..repeatEx(times: 2)
      ..forward();

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
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: (_isPortrait == Orientation.portrait)
                            ? _size.width * 0.1
                            : _size.width * 0.15,
                        vertical: 10),
                    child: _drawList(context)))),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _animation,
                  child: Opacity(
                    opacity: _opacity.value,
                    child: Chip(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                      shadowColor: Colors.black,
                      backgroundColor: Colors.grey[600],
                      label: Text(
                        "Nuevo adulto mayor",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: 6),
            FloatingActionButton(
              child: Icon(Icons.add, size: 50.0),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                //Navigator.of(context).pushNamed('formadulto');
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => RegisterSeniorPage()));
              },
            ),
          ],
        ),
      ),
      onWillPop: () => showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Advertencia"),
                content: Text("¿Desea salir de la Aplicación?"),
                actions: [
                  MaterialButton(
                      onPressed: () => SystemChannels.platform
                          .invokeMethod("SystemNavigator.pop"),
                      child: Text("SI")),
                  MaterialButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text("NO"))
                ],
              )),
    );
  }

  Widget _appBar(BuildContext context) {
    final _preferences = UserSharedPreferences();
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
            'Selecciona un perfil:\n- ${_preferences.userName} -',
            textAlign: TextAlign.center,
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
    final messageStyle = TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      shadows: [
        Shadow(
          blurRadius: 2,
          color: Colors.grey[200],
          offset: Offset(1, 1),
        ),
        Shadow(
          blurRadius: 5,
          color: Colors.grey[700],
          offset: Offset(2, 2),
        )
      ],
    );

    return FutureBuilder<List<AdultoModel>>(
      future: _getList(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(utils.primary)));
        }

        final list = snapshot.data;
        if (list.isEmpty) {
          return Center(
              child: Text('No existe ningun adulto mayor inscrito.',
                  style: messageStyle));
        }

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 6)
              ]),
              margin: EdgeInsets.only(top: 10),
              child: Slidable(
                key: Key(list[index].id.toString()),
                actionPane: SlidableStrechActionPane(),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: _size.width,
                    height: 90,
                    child: MaterialButton(
                        color: Color(0xff259587),
                        //color: const Color(0xff259587),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xff158577),
                            ),
                            Text(
                                //'adult_id: ${list[index].id} | user_id:${utils.user.id} - nombres:${list[index].nombres} ${list[index].apellidos}',
                                '${list[index].nombres} ${list[index].apellidos}',
                                style: utils.estBodyWhite18),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xff158577),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  VideoPage(adulto: list[index])));
                        }),
                  ),
                ),
                actions: <Widget>[
                  IconSlideAction(
                    caption: 'Editar',
                    foregroundColor: Color(0xffE6E6E6),
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
                    foregroundColor: Color(0xffE6E6E6),
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
              ),
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

    //print(json.decode(response.body));

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
