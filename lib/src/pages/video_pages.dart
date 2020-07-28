import 'dart:convert';

import 'package:cogniplus_mobile/src/model/send_mail_mixin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:cogniplus_mobile/src/model/adulto_model.dart';
import 'package:cogniplus_mobile/src/model/historial_model.dart';
import 'package:cogniplus_mobile/src/providers/db_provider.dart';
import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;
import 'package:cogniplus_mobile/src/widgets/video_widget.dart';

//Text('headline', style: Theme.of(context).textTheme.headline,),

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  String _rutaVideo;
  List _selectedListVideos;
  int _idModulo;
  int _idVideo;
  int _idHistorial;
  AdultoModel _adulto;
  List _lstBtnBottom = [];
  BuildContext navigatorKey;
  @override
  void initState() {
    //_rutaVideo = utils.listFilesModulo1[0];

    _idModulo = 1;
    _idVideo = 1;
    _adulto = null;
    _selectedListVideos = lstModulo1;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _adulto = ModalRoute.of(context).settings.arguments;
    navigatorKey = context;

    return Scaffold(
        drawer: Drawer(
          elevation: 10.0,
          child: Material(
            child: SafeArea(
                child: FutureBuilder(
                    future: DBProvider.db
                        .getHistorial(_adulto.id, _idModulo, _idVideo),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<HistorialModel>> snapshot) {
                      if (!snapshot.hasData)
                        return ListTile(title: Text('Sin datos.'));

                      List<HistorialModel> historial = snapshot.data;

                      return ListView.builder(
                          itemCount:
                              historial == null ? 1 : historial.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                                color: utils.primary,
                                child: Column(
                                  children: <Widget>[
                                    Text(utils.modulos[_idModulo - 1]['nombre'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: utils.accent)),
                                    SizedBox(height: 5),
                                    Text(utils.modulos[_idModulo - 1][_idVideo],
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: utils.accent))
                                  ],
                                ),
                              );
                            }
                            index -= 1;
                            DateTime fecha = DateFormat('yyyy-MM-dd hh:mm:ss')
                                .parse(historial[index].fecha);
                            String f = DateFormat('dd-MM-yyyy').format(fecha);
                            String h = DateFormat('kk:mm:ss').format(fecha);
                            final bool enviado = historial[index].enviado == 1;
                            return Column(children: <Widget>[
                              ListTile(
                                  leading: (enviado)
                                      ? Column(children: <Widget>[
                                          Icon(FontAwesomeIcons.checkCircle,
                                              color: utils.primary, size: 32.0),
                                          Text('Enviado',
                                              style: TextStyle(
                                                  fontSize: 10.0,
                                                  color: utils.primary,
                                                  fontWeight: FontWeight.bold))
                                        ])
                                      : Column(children: <Widget>[
                                          ClipOval(
                                              child: Material(
                                                  child: InkWell(
                                                      splashColor:
                                                          utils.primary,
                                                      child: SizedBox(
                                                          width: 34.0,
                                                          height: 34.0,
                                                          child: Icon(
                                                            FontAwesomeIcons
                                                                .telegramPlane,
                                                            size: 32.0,
                                                          )),
                                                      onTap: () async {
                                                        EmailManager manager =
                                                            new EmailManager();
                                                        utils.showToast(context,
                                                            'Enviando...');
                                                        Navigator.of(context)
                                                            .pop();
                                                        await manager.sendEmail(
                                                            _adulto,
                                                            historial[index],
                                                            navigatorKey);

                                                        setState(() {});
                                                      }))),
                                          Text('Enviar?',
                                              style: TextStyle(
                                                  fontSize: 10.0,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold))
                                        ]),
                                  title: Text('${f.toString()}'),
                                  subtitle: (historial[index].resp1 != null)
                                      ? Row(children: <Widget>[
                                          Icon(Icons.star,
                                              size: 18, color: utils.primary),
                                          Text(historial[index]
                                              .resp1
                                              .toString()),
                                          SizedBox(width: 10),
                                          Icon(Icons.star,
                                              size: 18, color: utils.primary),
                                          Text(historial[index]
                                              .resp2
                                              .toString()),
                                          Expanded(child: SizedBox())
                                        ])
                                      : Text('Sin calificación.'),
                                  trailing: Text('${h.toString()}')),
                              Divider()
                            ]);
                          });
                    })),
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                  icon: Icon(FontAwesomeIcons.question, color: Colors.white),
                  onPressed: () {
                    _idVideo = 0;
                    openDialog(utils.intro, context);
                  }),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('home');
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.solidUserCircle,
                        color: Colors.white, size: 42),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('AdultoMayor', style: utils.estBodyAccent16),
                        Text('${_adulto.nombres} ${_adulto.apellidos}',
                            style: utils.estBodyAccent19),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                  icon: Icon(FontAwesomeIcons.powerOff, color: Colors.white),
                  onPressed: () {
                    utils.logoff(context);
                  }),
            ],
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: _getBody(context),
        )),
        floatingActionButton: Builder(builder: (BuildContext context) {
          return SpeedDial(
            // both default to 16
            marginRight: 18,
            marginBottom: 20,
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            visible: _dialVisible,
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () {},
            onClose: () {},
            tooltip: 'Menu',
            heroTag: 'Menu de Cogniplus',
            backgroundColor: utils.primary,
            foregroundColor: Colors.white,
            elevation: 8.0,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                  child: Icon(Icons.history),
                  backgroundColor: utils.accent,
                  label: 'Historial del video',
                  labelStyle: TextStyle(fontSize: 12.0),
                  onTap: () => Scaffold.of(context).openDrawer()),
              SpeedDialChild(
                child: Icon(FontAwesomeIcons.calendarCheck),
                backgroundColor: Colors.blueGrey,
                label: 'Objetivos del video',
                labelStyle: TextStyle(fontSize: 12.0),
                onTap: () => _mostrarAlert(context),
              ),
              SpeedDialChild(
                child: Icon(FontAwesomeIcons.question),
                backgroundColor: utils.primary,
                label: 'video de introducción',
                labelStyle: TextStyle(fontSize: 12.0),
                onTap: () {
                  _idVideo = 0;
                  openDialog(utils.intro, context);
                },
              )
            ],
          );
        }));
  }

  bool _dialVisible = true;
  _getBody(BuildContext context) {
    DBProvider.db.getAdultoByid(_adulto.id).then((a) {
      _adulto = a;
    });
    return FutureBuilder(
      future: DBProvider.db.getAdultoByid(_adulto.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Text('Error');
        _adulto = snapshot.data;
        return Container(
            padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 30.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  _makeIconsTop(),
                  SizedBox(height: 10.0),
                  _makeVideoPlayer(_rutaVideo, context),
                  SizedBox(height: 10.0),
                  (_selectedListVideos.length <= 0)
                      ? SizedBox(height: 48.0)
                      : _makeIconsBottom(context),
                  SizedBox(height: 20.0),
                  _makeButton(context),
                ],
              ),
            ));
      },
    );
  }

  Widget _makeVideoPlayer(String rutaVideo, BuildContext context) {
    return Container(
      width: 440.0,
      height: 240.0,
      color: Color(0xff333333),
      child: FlatButton(
          onPressed: () async {
            if (_idVideo == null || _idModulo == null) return null;

            int vistas = (await DBProvider.db
                    .getVisualizaciones(_adulto.id, _idModulo, _idVideo)) +
                1;

            _idHistorial = await DBProvider.db.insertHistorial(HistorialModel(
                idVideo: _idVideo,
                idAdulto: _adulto.id,
                idModulo: _idModulo,
                titulo: rutaVideo,
                fecha: DateTime.now().toString(),
                visualizaciones: vistas));
            /*
                print('***************************************');
                print(_rutaVideo);
                print(_idModulo);
                print(_idVideo);
                print('***************************************');
                */

            openDialog(_rutaVideo, context);

            setState(() {});
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*Text(
                  (_idModulo == null)
                      ? ''
                      : utils.modulos[_idModulo - 1]['nombre'],
                  style: TextStyle(color: Colors.white)),
              Text(
                  (_idModulo == null || _idVideo == null)
                      ? ''
                      : utils.modulos[_idModulo - 1][_idVideo],
                  style: TextStyle(color: Colors.white)),*/
              Icon(Icons.play_circle_filled,
                  color: Color(0xff67CABA), size: 92),
            ],
          )),
    );
  }

  Widget _makeIconsTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _makeBtn(1, _adulto.m1),
        SizedBox(width: 10),
        _makeBtn(2, _adulto.m2),
        SizedBox(width: 10),
        _makeBtn(3, _adulto.m3),
        SizedBox(width: 10),
        _makeBtn(4, _adulto.m4),
      ],
    );
  }

  List<bool> _mSelected = [true, false, false, false];

  _makeBtn(int digito, int estado) {
    Color color;
    Widget icon;
    TextStyle textstyle = TextStyle(
        color: (_mSelected[digito - 1]) ? utils.accent : Colors.white,
        fontSize: (40),
        fontWeight: FontWeight.bold);

    switch (estado) {
      case 0:
        color = utils.primary;
        icon = Icon(Icons.lock, size: 40, color: Colors.white);
        break;
      case 1:
        color = utils.primary;
        icon = Text(digito.toString(), style: textstyle);
        break;
    }
    return SizedBox(
      height: 62,
      width: 62,
      child: RaisedButton(
        padding: EdgeInsets.zero,
        elevation: 6,
        color: color,
        shape: CircleBorder(),
        child: icon,
        onPressed: () async {
          switch (digito) {
            case 1:
              _lstBtnBottom = jsonDecode(_adulto.m1v);
              _adulto.m1 = (estado == 0) ? 1 : estado;
              _mSelected[0] = true;
              _mSelected[1] = false;
              _mSelected[2] = false;
              _mSelected[3] = false;
              _selectedListVideos = lstModulo1;
              break;
            case 2:
              _lstBtnBottom = jsonDecode(_adulto.m2v);
              _adulto.m2 = (estado == 0) ? 1 : estado;
              _mSelected[0] = false;
              _mSelected[1] = true;
              _mSelected[2] = false;
              _mSelected[3] = false;
              _selectedListVideos = lstmodulo2;
              break;
            case 3:
              _lstBtnBottom = jsonDecode(_adulto.m3v);
              _adulto.m3 = (estado == 0) ? 1 : estado;
              _mSelected[0] = false;
              _mSelected[1] = false;
              _mSelected[2] = true;
              _mSelected[3] = false;
              _selectedListVideos = lstmodulo3;
              break;
            case 4:
              _lstBtnBottom = jsonDecode(_adulto.m4v);
              _adulto.m4 = (estado == 0) ? 1 : estado;
              _mSelected[0] = false;
              _mSelected[1] = false;
              _mSelected[2] = false;
              _mSelected[3] = true;
              _selectedListVideos = lstmodulo4;
              break;
          }
          _idModulo = digito;
          //_adulto.m1 = 2; _adulto.m2 = 0;_adulto.m3 = 0; _adulto.m4 = 0;
          await DBProvider.db.updateModuloAdulto(_adulto);

          setState(() {});
        },
      ),
    );
  }

  Widget _makeIconsBottom(BuildContext context) {
    if (_lstBtnBottom.length == 0) _lstBtnBottom = jsonDecode(_adulto.m1v);
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: _getVideos(context));
  }

  List<Widget> _getVideos(BuildContext context) {
    List<Widget> list = new List<Widget>();
    int i = 1;
    _selectedListVideos.forEach((video) {
      list.add(_getBtnIcon(i, video, context));
      list.add(SizedBox(width: 5));
      i++;
    });
    return list;
  }

  static final List<String> lstModulo1 = utils.listFilesModulo1;
  static final List<String> lstmodulo2 = utils.listFilesModulo2;
  static final List<String> lstmodulo3 = utils.listFilesModulo3;
  static final List<String> lstmodulo4 = utils.listFilesModulo4;

  List _vSelectedList = [true, false, false, false, false, false, false];

  Widget _getBtnIcon(int digito, video, BuildContext context) {
    Color color =
        (_vSelectedList[digito - 1]) ? utils.primary : Color(0xff6F6F6E);
    TextStyle textstyle = TextStyle(
        color: (_vSelectedList[digito - 1]) ? Color(0xff6F6F6E) : Colors.white,
        fontSize: (34),
        fontWeight: FontWeight.bold);

    return SizedBox(
      height: 42,
      width: 42,
      child: RaisedButton(
          padding: EdgeInsets.zero,
          elevation: 6,
          color: color,
          shape: CircleBorder(),
          child: (digito == _selectedListVideos.length)
              ? Icon(
                  Icons.star,
                  size: 32,
                  color: Colors.yellow,
                )
              : (_lstBtnBottom[digito - 1] == 1)
                  ? Text(digito.toString(), style: textstyle)
                  : Icon(Icons.lock, size: 32, color: Colors.white),
          onPressed: () async {
            switch (digito) {
              case 1:
                _vSelectedList[0] = true;
                _vSelectedList[1] = false;
                _vSelectedList[2] = false;
                _vSelectedList[3] = false;
                _vSelectedList[4] = false;
                _vSelectedList[5] = false;
                _vSelectedList[6] = false;
                break;
              case 2:
                _vSelectedList[0] = false;
                _vSelectedList[1] = true;
                _vSelectedList[2] = false;
                _vSelectedList[3] = false;
                _vSelectedList[4] = false;
                _vSelectedList[5] = false;
                _vSelectedList[6] = false;

                break;
              case 3:
                _vSelectedList[0] = false;
                _vSelectedList[1] = false;
                _vSelectedList[2] = true;
                _vSelectedList[3] = false;
                _vSelectedList[4] = false;
                _vSelectedList[5] = false;
                _vSelectedList[6] = false;
                break;
              case 4:
                _vSelectedList[0] = false;
                _vSelectedList[1] = false;
                _vSelectedList[2] = false;
                _vSelectedList[3] = true;
                _vSelectedList[4] = false;
                _vSelectedList[5] = false;
                _vSelectedList[6] = false;
                break;
              case 5:
                _vSelectedList[0] = false;
                _vSelectedList[1] = false;
                _vSelectedList[2] = false;
                _vSelectedList[3] = false;
                _vSelectedList[4] = true;
                _vSelectedList[5] = false;
                _vSelectedList[6] = false;
                break;
              case 6:
                _vSelectedList[0] = false;
                _vSelectedList[1] = false;
                _vSelectedList[2] = false;
                _vSelectedList[3] = false;
                _vSelectedList[4] = false;
                _vSelectedList[5] = true;
                _vSelectedList[6] = false;
                break;
              case 7:
                _vSelectedList[0] = false;
                _vSelectedList[1] = false;
                _vSelectedList[2] = false;
                _vSelectedList[3] = false;
                _vSelectedList[4] = false;
                _vSelectedList[5] = false;
                _vSelectedList[6] = true;
                break;
            }
            var vector = await DBProvider.db
                .insertAdultoBtnBottom(_adulto, _idModulo, digito);
            _lstBtnBottom = vector;

            _rutaVideo = video;
            _idVideo = digito;
            setState(() {});
          }),
    );
  }

  Widget _makeButton(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      color: Theme.of(context).primaryColor,
      child: Text('IR A CUESTIONARIO',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold)),
      onPressed: () {
        if (_rutaVideo == null ||
            _idVideo == null ||
            _idModulo == null ||
            _idHistorial == null) return null;
        Navigator.of(context).pushReplacementNamed('cuestionario',
            arguments: [_adulto, _idModulo, _idVideo, _idHistorial]);
      },
    );
  }

  void _mostrarAlert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset('assets/images/m${_idModulo}v$_idVideo.png'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Aceptar'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  void openDialog(String rutaVideo, BuildContext context) {
    if (rutaVideo == null) return null;
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.6), // background color
      barrierDismissible: false,
      barrierLabel: "Dialog",
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Center(
                    child: Container(
                        width: MediaQuery.of(context).size.width - 100.0,
                        child: VideoWidget(ruta: rutaVideo))),
                Align(
                    alignment: Alignment.topRight,
                    child: FlatButton(
                        child: Icon(Icons.close, size: 48, color: Colors.white),
                        onPressed: () {
                          /*Navigator.of(context).pushNamedAndRemoveUntil(
                              '/cuestionario', (Route<dynamic> route) => false,
                              arguments: [
                                _adulto,
                                _idModulo,
                                _idVideo,
                                _idHistorial
                              ]);*/

                          if (_idVideo == 0) {
                            _idVideo = 1;
                            Navigator.of(context).pop();
                            return;
                          }

                          Navigator.of(context)
                              .pushReplacementNamed('cuestionario', arguments: [
                            _adulto,
                            _idModulo,
                            _idVideo,
                            _idHistorial
                          ]);

                          //Navigator.of(context).pushReplacementNamed('/');
                        })),
                /*Align(
                    alignment: Alignment.topCenter,
                    child: Text('titulo del video',
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 16))),*/
                Divider()
              ],
            ),
          ),
        );
      },
    );
  }
}
