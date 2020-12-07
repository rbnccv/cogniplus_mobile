import 'dart:convert';

import 'package:cogniplus_mobile/appConfig.dart';
import 'package:cogniplus_mobile/src/pages/question_pages.dart';
import 'package:cogniplus_mobile/src/pages/seniors_list_page.dart';
import 'package:cogniplus_mobile/src/providers/api.dart';
import 'package:cogniplus_mobile/src/widgets/togglebtn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cogniplus_mobile/src/model/adulto_model.dart';
import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;
import 'package:cogniplus_mobile/src/widgets/videp_player_widget.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final AdultoModel adulto;

  const VideoPage({Key key, this.adulto}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  BuildContext navigatorKey;

  VideoPlayerController _videoPlayerController;

  bool _dialVisible = true;
  String url = "";

  Future<Map<String, dynamic>> _response;

  List<dynamic> _modules;
  List<dynamic> _videos;

  int _idSelectedModule = 1;
  bool _isSelectedModule = false;

  int _idSelectedVideo = 0;
  bool _isSelectedVideo = false;

  int _selectedModule = 1;
  dynamic _selectedVideo;

  @override
  void initState() {
    _setInit();
    super.initState();
  }

  @override
  void dispose() {
    this._videoPlayerController?.dispose();
    super.dispose();
  }

  _setInit() async {
    _response = _getRequest();
  }

  @override
  Widget build(BuildContext context) {
    navigatorKey = context;

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
          drawer: _drawer(context),
          appBar: _appbar(context),
          body: SafeArea(
            child: SingleChildScrollView(child: _getBody(context)),
          ),
          floatingActionButton: Builder(builder: (BuildContext context) {
            return _floatingActionButton(context);
          })),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.question, color: Colors.white),
              onPressed: () {
                utils.showIntroVideo(context);
              }),
          GestureDetector(
            onTap: () {
              _videoPlayerController?.dispose();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SeniorListPage()));
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
                    Text(widget.adulto.nombres, style: utils.estBodyAccent16),
                    Text(widget.adulto.apellidos, style: utils.estBodyAccent19),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
              icon: Icon(FontAwesomeIcons.powerOff, color: Colors.white),
              onPressed: () async {
                await _videoPlayerController.pause();
                await utils.logoff(context);
              }),
        ],
      ),
    );
  }

  Drawer _drawer(BuildContext context) {
    return Drawer(
      elevation: 10,
      child: Material(
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(color: utils.primary),
            child: Column(
              children: [
                SizedBox(height: 10),
                Image.asset(
                  "assets/images/logo.png",
                  width: 200,
                ),
                SizedBox(height: 30),
                FutureBuilder(
                    future: _response,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      final Map<String, dynamic> response = snapshot.data;
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          final List videos = response["all_viewed_videos"];

                          return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: videos.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    onTap: () {
                                      // utils.showWindow(
                                      //     context: context,
                                      //     idModulo: videos[index]["module_id"],
                                      //     idVideo: i);
                                    },
                                    tileColor: Colors.white,
                                    leading: Icon(
                                      (videos[index]['showed'])
                                          ? Icons.lock_open
                                          : Icons.lock,
                                      color: (videos[index]['showed'])
                                          ? utils.primary
                                          : Colors.grey,
                                      size: 32,
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(videos[index]['name']),
                                        Text("módulo: " +
                                            videos[index]['module_id']
                                                .toString()),
                                      ],
                                    ),
                                  );
                                }),
                          );
                        }
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
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
            child: Icon(Icons.info_outline),
            backgroundColor: utils.accent,
            label: 'Información acerca de los videos.',
            labelStyle: TextStyle(fontSize: 12.0),
            onTap: () {
              utils.showInfo(context);
            }),
        SpeedDialChild(
          child: Icon(FontAwesomeIcons.question),
          backgroundColor: utils.primary,
          label: 'video de introducción',
          labelStyle: TextStyle(fontSize: 12.0),
          onTap: () {
            utils.showIntroVideo(context);
          },
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

              if (!_modules[0]['visited']) {
                _modules[0]['visited'] = true;
                _selectedModule = 1;
                _idSelectedModule = 1;
              }

              if (_selectedVideo != null) {
                _videoPlayerController = VideoPlayerController?.network(
                  AppConfig.host + "/stream/" + _selectedVideo["file_name"],
                );
                _hasInitialize = _videoPlayerController.initialize();
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    SizedBox(
                      height: 82,
                      width: parentWidth,
                      child: _toggleBarModule(list: _modules),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      width: 400,
                      child: (_selectedVideo == null)
                          ? Image.asset("assets/images/default_video.png")
                          : FutureBuilder(
                              future: _hasInitialize,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return VideoPlayerWidget(
                                    videocontroller: _videoPlayerController,
                                    newKey: UniqueKey(),
                                    autoplay: true,
                                    aInitialize: true,
                                  );
                                }
                                return Center(
                                    child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator(
                                            backgroundColor:
                                                Colors.transparent)));
                              },
                            ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 72,
                      width: parentWidth,
                      child: Center(
                        child: _toggleBarVideos(
                            list: _videos
                                .where((video) =>
                                    video["module_id"] == _selectedModule)
                                .toList()),
                      ),
                    ),
                    SizedBox(height: 30),
                    RaisedButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text("IR A CUESTIONARIO",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      splashColor: Colors.tealAccent,
                      color: Color(0xff67CABA),
                      onPressed: (_selectedVideo != null)
                          ? () {
                              _sendInfoAndGotTo();
                            }
                          : null,
                    ),
                    SizedBox(height: 10),
                    Text((_selectedVideo != null) ? _selectedVideo["name"] : "")
                  ],
                ),
              );
            }
          }

          return Center(child: CircularProgressIndicator());
        });
  }

  Future<Map<String, dynamic>> _getRequest() async {
    var response = await Api()
        .getDataFromApi(url: "/senior_videos/" + widget.adulto.id.toString());
    return json.decode(response.body);
  }

  _sendInfoAndGotTo() async {
    var info = {
      "senior": widget.adulto,
      "modules": _modules,
      "videos": _videos
    };

    await Api().setPostDataFromApi(
        url: '/senior_videos/' + widget.adulto.id.toString(), data: info);
    //_videoPlayerController.pause();
    await _videoPlayerController?.dispose();

    await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext contex) => QuestionPage(info: {
              'adulto': widget.adulto,
              'idModulo': _idSelectedModule,
              'idVideo': _idSelectedVideo
            })));
  }

  Widget _toggleBarModule({List list}) {
    return Column(
      children: [
        Expanded(
            child: Center(
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                _isSelectedModule =
                    (list[index]['id'] == _idSelectedModule) ? true : false;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ToggleBtn(
                      diameter: 64,
                      digit: (index + 1).toString(),
                      visited: list[index]["visited"],
                      selectedBackgroundColor: Color(0xff67CABA),
                      selectedForegroundColor: Colors.black87,
                      background: Color(0xff67CABA),
                      foreground: Colors.white,
                      iconColor: Colors.white,
                      selected: _isSelectedModule,
                      onPressed: () {
                        setState(() {
                          _isSelectedModule = true;
                          _selectedModule = list[index]['id'];
                          _idSelectedModule = list[index]['id'];

                          list[index]["visited"] = true;
                          _selectedVideo = null;
                        });
                      }),
                );
              }),
        ))
      ],
    );
  }

  Widget _toggleBarVideos({List list}) {
    return Column(
      children: [
        Expanded(
            child: Center(
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                _isSelectedVideo =
                    (list[index]['id'] == _idSelectedVideo) ? true : false;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                  child: ToggleBtn(
                      diameter: 52,
                      digit: (index + 1).toString(),
                      visited: list[index]["showed"],
                      selectedBackgroundColor: Color(0xff67CABA),
                      selectedForegroundColor: Colors.black87,
                      background: Colors.black54,
                      foreground: Colors.white,
                      iconColor: Colors.white,
                      selected: _isSelectedVideo,
                      onPressed: () {
                        setState(() {
                          _isSelectedVideo = true;
                          _selectedVideo = list[index]['id'];
                          _idSelectedVideo = list[index]['id'];

                          list[index]["showed"] = true;
                          _selectedVideo = list[index];
                        });
                      }),
                );
              }),
        ))
      ],
    );
  }

  Future<void> _hasInitialize;

  _setVideoPlayer() async {
    _videoPlayerController = VideoPlayerController?.network(
      AppConfig.host + "/stream/" + _selectedVideo["file_name"],
    );
    _hasInitialize = _videoPlayerController.initialize();

    _hasInitialize.then((value) => VideoPlayerWidget(
          videocontroller: _videoPlayerController,
          newKey: UniqueKey(),
          autoplay: true,
          aInitialize: true,
        ));
  }

  Widget _sett2VideoPlayer() {
    if (_selectedVideo == null) {
      return Image.asset("assets/images/default_video.png");
    } else {
      _videoPlayerController = VideoPlayerController?.network(
        AppConfig.host + "/stream/" + _selectedVideo["file_name"],
      );

      return VideoPlayerWidget(
        videocontroller: _videoPlayerController,
        newKey: UniqueKey(),
        autoplay: true,
        aInitialize: true,
      );
    }
  }
}
