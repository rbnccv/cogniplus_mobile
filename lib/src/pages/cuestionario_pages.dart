import 'package:cogniplus_mobile/src/model/adulto_model.dart';
//import 'package:cogniplus/src/model/video_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;

class CuestionarioPage extends StatefulWidget {
  final Map<String, dynamic> info;

  const CuestionarioPage({Key key, this.info}) : super(key: key);
  @override
  _CuestionarioPageState createState() => _CuestionarioPageState();
}

class _CuestionarioPageState extends State<CuestionarioPage> {
  AdultoModel _adulto;
  int _idVideo;
  int _idModulo;
  @override
  Widget build(BuildContext context) {
    _adulto = widget.info['adulto'];
    _idModulo = widget.info['idModulo'];
    _idVideo = widget.info['idVideo'];
    //VideoModel video = VideoModel(id: data[1], idModulo: data[2]);
    return Scaffold(
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
                        Text('${_adulto.nombres}', style: utils.estBodyAccent16),
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
          child: _getBody(context, _adulto),
        )));
  }

  Widget _getBody(BuildContext context, AdultoModel adulto) {
    return Container(
        padding: EdgeInsets.fromLTRB(80.0, 20.0, 80.0, 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('PREGUNTAS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Text(
              '¿El adulto mayor se muestra predispuesto/a  realizar el ejercicio?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            _starsQuestion1(context),
            Text(
              '¿Ejecuta el ejercicio sin problemas?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            _starsQuestion2(context),
            SizedBox(height: 20),
            _getBotones(context, adulto),
          ],
        ));
  }

  int _response1 = 0;
  int _response2 = 0;

  Widget _starsQuestion1(BuildContext context) {
    return Center(
      child: SmoothStarRating(
          allowHalfRating: false,
          onRated: (value) => setState(() => _response1 = value.toInt()),
          starCount: 5,
          rating: _response1.toDouble(),
          size: 40,
          color: Theme.of(context).primaryColor,
          borderColor: Theme.of(context).primaryColor,
          spacing: 0.0),
    );
  }

  Widget _starsQuestion2(BuildContext context) {
    return Center(
      child: SmoothStarRating(
          allowHalfRating: false,
          onRated: (value) => setState(() => _response2 = value.toInt()),
          starCount: 5,
          rating: _response2.toDouble(),
          size: 40,
          color: Theme.of(context).primaryColor,
          borderColor: Theme.of(context).primaryColor,
          spacing: 0.0),
    );
  }

  Widget _getBotones(BuildContext context, AdultoModel adulto) {
    bool isLandscape =
        (MediaQuery.of(context).orientation == Orientation.landscape);
    return Flex(
      direction: (isLandscape) ? Axis.horizontal : Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(
          color: Theme.of(context).primaryColor,
          child: SizedBox(
              width: (isLandscape) ? 150 : double.infinity,
              height: 50,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
                  child: Text('ANTERIOR',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)))),
          onPressed: () => Navigator.of(context).pop(),
        ),
        (isLandscape)
            ? Container()
            : SizedBox(
                height: 10.0,
              ),
        FlatButton(
          color: Theme.of(context).primaryColor,
          child: SizedBox(
              width: (isLandscape) ? 150 : double.infinity,
              height: 50,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
                  child: Text('SIGUIENTE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)))),
          onPressed: () {
            if (_response1 <= 0 || _response2 <= 0) return null;
            Navigator.of(context).pushReplacementNamed('evaluacion',
                arguments: [
                  adulto,
                  _response1,
                  _response2,
                  _idModulo,
                  _idVideo
                ]);
          },
        )
      ],
    );
  }
}
