import 'dart:convert';

import 'package:cogniplus_mobile/src/pages/question_pages.dart';
import 'package:cogniplus_mobile/src/pages/seniors_list_page.dart';
import 'package:cogniplus_mobile/src/pages/video_pages.dart';
import 'package:cogniplus_mobile/src/providers/api.dart';
import 'package:flushbar/flushbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter/material.dart';

import 'package:cogniplus_mobile/src/model/adulto_model.dart';
import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;

class EvaluacionPage extends StatefulWidget {
  final Map<String, dynamic> info;

  const EvaluacionPage({Key key, this.info}) : super(key: key);
  @override
  _EvaluacionPageState createState() => _EvaluacionPageState();
}

class _EvaluacionPageState extends State<EvaluacionPage> {
  AdultoModel _adulto;
  int _idModulo;
  int _idVideo;
  Map<String, dynamic> _response;
  List<dynamic> _questions;

  final _editController = TextEditingController();

  bool _isButtonDisabled;

  @override
  void initState() {
    _setinit();
    super.initState();
  }

  void _setinit() async {
    _isButtonDisabled = false;
    _adulto = widget.info["adulto"];
    _idModulo = widget.info["idModulo"];
    _idVideo = widget.info["idVideo"];
    _response = widget.info["response"];
    _questions = _response["results"];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    icon: Icon(FontAwesomeIcons.question, color: Colors.white),
                    onPressed: () {}),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SeniorListPage()));
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
                          Text('${_adulto.nombres}',
                              style: utils.estBodyAccent16),
                          Text('${_adulto.apellidos}',
                              style: utils.estBodyAccent19),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                    icon: Icon(FontAwesomeIcons.powerOff, color: Colors.white),
                    onPressed: () => utils.logoff(context)),
              ],
            ),
          ),
          body: SafeArea(
              child: SingleChildScrollView(
            child: _getBody(context),
          ))),
    );
  }

  Widget _getBody(BuildContext context) {
    final TextStyle font1 = TextStyle(fontSize: 16);
    int length = _questions.length;
    return Container(
        padding: EdgeInsets.fromLTRB(60.0, 10.0, 60.0, 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${_questions[index]["question_text"]}',
                          style: font1,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            _starsQuestion(
                                context, _questions[index]["assessment"]),
                            Expanded(child: SizedBox()),
                            Text(_questions[index]["assessment"].toString() +
                                ((_questions[index]["assessment"] <= 1)
                                    ? " estrella"
                                    : " estrellas")),
                          ],
                        ),
                        SizedBox(height: 10),
                      ]),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              "Evaluación profesional: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: TextField(
                  controller: _editController,
                  keyboardType: TextInputType.multiline,
                  minLines: 6,
                  maxLines: 10,
                  maxLengthEnforced: true,
                  textInputAction: TextInputAction.newline,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                      hintText: 'Añadir Comentario...',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(10.0),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.black)))),
            ),
            SizedBox(height: 30),
            _getBotones(context),
          ],
        ));
  }

  Widget _getBotones(BuildContext context) {
    bool isLandscape =
        (MediaQuery.of(context).orientation == Orientation.landscape);
    return Flex(
      direction: (isLandscape) ? Axis.horizontal : Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(
            color: Theme.of(context).primaryColor,
            child: SizedBox(
                width: (isLandscape) ? 240 : double.infinity,
                height: 50,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
                    child: Text('VOLVER A INTENTAR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)))),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => QuestionPage(
                        info: {
                          'adulto': _adulto,
                          'idModulo': _idModulo,
                          'idVideo': _idVideo
                        },
                      )));
            }),
        (isLandscape)
            ? SizedBox()
            : SizedBox(
                height: 10,
              ),
        FlatButton(
            color: Theme.of(context).primaryColor,
            child: SizedBox(
                width: (isLandscape) ? 240 : double.infinity,
                height: 50,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
                    child: Text((_isButtonDisabled) ? 'ENVIANDO' : 'GUARDAR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)))),
            onPressed: _isButtonDisabled ? null : _guardar)
      ],
    );
  }

  void _guardar() async {
    setState(() {});
    _isButtonDisabled = true;
    if (_isButtonDisabled) {
      Map<String, dynamic> result = {
        "user_id": utils.user.id,
        "senior_id": this._adulto.id,
        "module_id": this._idModulo,
        "video_id": this._idVideo,
        "evaluation": this._editController.text,
        "results": this._questions,
      };

      final response =
          await Api().setPostDataFromApi(url: '/results', data: result);

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        _showSnack("Evaluación", body["message"], context);
      } else {
        _showSnack("Error", "Error al intentar guardar el resultado.", context);
      }
    }
  }

  Widget _starsQuestion(BuildContext context, int rating) {
    return SmoothStarRating(
        allowHalfRating: false,
        isReadOnly: true,
        starCount: 5,
        rating: rating.toDouble(),
        size: 25,
        color: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        spacing: 0.0);
  }

  void _showSnack(String title, String message, BuildContext context) {
    Flushbar flush;

    flush = Flushbar<bool>(
      backgroundColor: utils.accent,
      //showProgressIndicator: true,
      title: title,
      message: message,
      icon: Icon(
        Icons.info_outline,
        color: utils.primary,
        size: 34.0,
      ),
      //dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      //flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: false,
      mainButton: FlatButton(
          child: Text("VER MÁS VIDEOS.", style: TextStyle(color: Colors.amber)),
          onPressed: () {
            flush.dismiss(true); // result = true
          }),
    )..show(context).then((result) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VideoPage(adulto: this._adulto)));
      });
  }
}
