import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:cogniplus_mobile/src/data/data.dart';
import 'package:cogniplus_mobile/src/model/send_mail_mixin.dart';

import 'package:cogniplus_mobile/src/providers/api.dart';
import 'package:cogniplus_mobile/src/widgets/togglebar_widget.dart';
import 'package:cogniplus_mobile/src/widgets/togglebtn_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:cogniplus_mobile/src/model/adulto_model.dart';
import 'package:cogniplus_mobile/src/model/historial_model.dart';
import 'package:cogniplus_mobile/src/providers/db_provider.dart';
import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;
import 'package:cogniplus_mobile/src/widgets/video_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

//Text('headline', style: Theme.of(context).textTheme.headline,),

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  BuildContext navigatorKey;
  bool _dialVisible = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    var modules = [m7, m6, m1, m2, m3, m4, m5, m6];
    var videos = [m3, m5, m1, m2, m3, m4, m5, m6, m7];
    return Center(
      child: Column(
        children: [
          SizedBox(height: 20,),
          SizedBox(
            height: 72,
            child: ToggleBar(
                list: modules,
                fieldVisited: "visited",
                onSelected: (value) {
                  print(value.toString());
                }),
          ),
          SizedBox(height: 200),
          SizedBox(
            height: 72,
            child: ToggleBar(
                list: videos,
                fieldVisited: "visited",
                onSelected: (value) {
                  print(value.toString());
                }),
          ),
        ],
      ),
    );
  }
}
