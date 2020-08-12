import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:cogniplus_mobile/src/model/send_mail_mixin.dart';

import 'package:cogniplus_mobile/src/providers/api.dart';
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
  final imgUrl = "https://unsplash.com/photos/iEJVyyevw-U/download?force=true";
  bool downloading = false;
  var progressString = "";

  BuildContext navigatorKey;
  @override
  void initState() {
    super.initState();
    downloadFile();
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();

      await dio.download(imgUrl, "${dir.path}/myImage.jpg",
          onReceiveProgress: (rec, total) {
        print("Rec:, $rec, total");

        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      downloading = false;
      progressString = "completed";
    });
    print("Download completed");
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

  bool _dialVisible = true;
  _getBody(BuildContext context) {
    return Center(
      child: downloading
          ? Container(
              height: 120.0,
              width: 200.0,
              child: Card(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Downloading File: $progressString",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
          : Text("No Data"),
    );
  }
}

class Videoplayer extends StatefulWidget {
  final String route;
  const Videoplayer({Key key, this.route}) : super(key: key);
  _Videoplayer createState() => _Videoplayer();
}

class _Videoplayer extends State<Videoplayer> {
  ChewieController _chewieController;
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new VideoPlayerController.asset(widget.route);
    _chewieController = ChewieController(
        videoPlayerController: _controller,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        looping: false,
        showControls: true,
        autoPlay: true,
        placeholder: Container(
          color: Colors.transparent,
        ),
        errorBuilder: (context, msg) {
          return Center(
            child: Text(
              msg,
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}
