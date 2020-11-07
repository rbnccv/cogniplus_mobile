import 'dart:convert';

import 'package:cogniplus_mobile/appConfig.dart';
import 'package:cogniplus_mobile/src/data/data.dart';
import 'package:cogniplus_mobile/src/model/response_api.dart';
import 'package:cogniplus_mobile/src/model/send_mail_mixin.dart';

import 'package:cogniplus_mobile/src/providers/api.dart';
import 'package:cogniplus_mobile/src/widgets/togglebar_widget.dart';
import 'package:cogniplus_mobile/src/widgets/togglebtn_widget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:cogniplus_mobile/src/model/adulto_model.dart';
import 'package:cogniplus_mobile/src/model/historial_model.dart';
import 'package:cogniplus_mobile/src/providers/db_provider.dart';
import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;
import 'package:path_provider/path_provider.dart';

import 'package:cogniplus_mobile/src/widgets/videp_player_widget.dart';
import 'package:cogniplus_mobile/src/model/response_api.dart';

//Text('headline', style: Theme.of(context).textTheme.headline,),

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  BuildContext navigatorKey;
  bool _dialVisible = true;
  String url = "";
  ConnectivityResult _connectivity;
  Future<Map<String, dynamic>> _response;
  List<dynamic> _modules;
  List<dynamic> _videos;
  int _idSelected = 0;
  bool _isSelected = false;

  int _selectedModule = 1;
  dynamic _selectedVideo;

  @override
  void initState() {
    _setInit();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _setInit() async {
    _response = _getResponse();
    _connectivity = await Connectivity().checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    navigatorKey = context;

    return Scaffold(
        drawer: _drawer(context),
        appBar: _appbar(context),
        body: SafeArea(
          child: SingleChildScrollView(child: _getBody(context)),
        ),
        floatingActionButton: Builder(builder: (BuildContext context) {
          return _floatingActionButton(context);
        }));
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.question, color: Colors.white),
              onPressed: () {}),
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
                    Text('nombre apellido', style: utils.estBodyAccent19),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
              icon: Icon(FontAwesomeIcons.powerOff, color: Colors.white),
              onPressed: () {}),
        ],
      ),
    );
  }

  Drawer _drawer(BuildContext context) {
    return Drawer();
  }

  SpeedDial _floatingActionButton(BuildContext context) {
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
        ),
        SpeedDialChild(
          child: Icon(FontAwesomeIcons.question),
          backgroundColor: utils.primary,
          label: 'video de introducción',
          labelStyle: TextStyle(fontSize: 12.0),
          onTap: () {},
        )
      ],
    );
  }

  _getBody(BuildContext context) {
    double parentWidth = double.infinity;
    return FutureBuilder(
        future: _response,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final Map<String, dynamic> response = snapshot.data;
              _modules = response['all_visited_modules'];
              _videos = response["all_viewed_videos"];

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    SizedBox(
                      height: 82,
                      width: parentWidth,
                      child: _toggleBar(
                          isModule: true,
                          list: _modules,
                          padding: 10,
                          diameter: 62,
                          fieldVisited: "visited"),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      width: 400,
                      child: (_selectedVideo == null)
                          ? Image.asset("assets/images/default_video.png")
                          : VideoPlayer(
                              AppConfig.host +
                                  "/stream/" +
                                  _selectedVideo["file_name"],
                              UniqueKey()),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 72,
                      width: parentWidth,
                      child: Center(
                        child: _toggleBar(
                            isModule: false,
                            list: _videos
                                .where((video) =>
                                    video["module_id"] == _selectedModule)
                                .toList(),
                            diameter: 52,
                            padding: 5,
                            background: Colors.grey[700],
                            selectedBackgroundColor: utils.primary,
                            fieldVisited: "showed"),
                      ),
                    ),
                  ],
                ),
              );
            }
          }

          return Center(child: CircularProgressIndicator());
        });
  }

  Future<Map<String, dynamic>> _getResponse() async {
    var response = await Api()
        .getDataFromApi(url: "/senior_videos/" + utils.user.id.toString());
    return json.decode(response.body);
  }

  Widget _toggleBar(
      {bool isModule,
      double padding,
      double diameter,
      Color iconColor,
      Color foreground,
      Color background,
      Color selectedforegroundColor,
      Color selectedBackgroundColor,
      Color selectedBackground,
      IconData defaultIcon,
      List list,
      String fieldVisited}) {
    return Column(
      children: [
        Expanded(
            child: Center(
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                _isSelected = (list[index]['id'] == _idSelected) ? true : false;
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: padding, vertical: padding),
                  child: ToggleBtn(
                      diameter: (isModule) ? 64 : 52,
                      digit: list[index]['id'].toString(),
                      visited: list[index][fieldVisited],
                      selectedBackgroundColor: Colors.red,
                      selectedForegroundColor: Colors.blue,
                      background:
                          (isModule) ? const Color(0xff67CABA) : Colors.black38,
                      foreground: (isModule) ? Colors.black87 : Colors.white,
                      iconColor: Colors.white,
                      selected: _isSelected,
                      onPressed: () {
                        setState(() {
                          if (isModule) {
                            _selectedModule = list[index]['id'];
                            _selectedVideo = null;
                          } else {
                            _selectedVideo = list[index];
                          }

                          _isSelected = true;
                          list[index][fieldVisited] = true;
                          _idSelected = list[index]['id'];
                        });
                        print(_idSelected);
                      }),
                );
              }),
        ))
      ],
    );
  }
}
