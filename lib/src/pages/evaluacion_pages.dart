import 'package:flushbar/flushbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'package:cogniplus_mobile/src/providers/db_provider.dart';
import 'package:cogniplus_mobile/src/model/adulto_model.dart';
import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;
import 'package:cogniplus_mobile/src/model/historial_model.dart';

class EvaluacionPage extends StatefulWidget {
  @override
  _EvaluacionPageState createState() => _EvaluacionPageState();
}

class _EvaluacionPageState extends State<EvaluacionPage> {
  AdultoModel _adulto;
  int _idModulo;
  int _idVideo;
  int _response1;
  int _response2;
  double _promedio;
  int _idHistorial;
  String _contacto;
  final _editController = TextEditingController();
  String _userName;
  String _password;
  bool _isButtonDisabled;

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = false;
  }

  @override
  Widget build(BuildContext context) {
    final List data = ModalRoute.of(context).settings.arguments;
    _adulto = data[0];
    _response1 = data[1];
    _response2 = data[2];
    _idModulo = data[3];
    _idVideo = data[4];
    _idHistorial = data[5];
    _promedio = ((_response1 + _response2) / 2);
    _contacto = 'cogniplus.santo.tomas@gmail.com';
    _userName = 'cogniplus.santo.tomas@gmail.com';
    _password = 'Santo_tomas';

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
                  onPressed: () => utils.logoff(context)),
            ],
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: _getBody(context),
        )));
  }

  Widget _getBody(BuildContext context) {
    final TextStyle font1 = TextStyle(fontSize: 16);
    return Container(
        padding: EdgeInsets.fromLTRB(60.0, 30.0, 60.0, 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                '¿El adulto mayor se muestra predispuesto/a  realizar el ejercicio?',
                style: font1),
            Row(
              children: <Widget>[
                _starsQuestion1(context),
                Expanded(child: SizedBox()),
                Text(
                    _response1.toString() +
                        ((_response1 <= 1) ? ' estrella' : ' estrellas'),
                    style: font1)
              ],
            ),
            Text('¿Ejecuta el ejercicio sin problemas?', style: font1),
            Row(
              children: <Widget>[
                _starsQuestion2(context),
                Expanded(child: SizedBox()),
                Text(
                    _response2.toString() +
                        ((_response2 <= 1) ? ' estrella' : ' estrellas'),
                    style: font1)
              ],
            ),
            Text('Promedio', style: font1),
            Row(
              children: <Widget>[
                _starsPromedio(context),
                Expanded(child: SizedBox()),
                Text(
                    _promedio.toString() +
                        ((_promedio <= 1) ? ' estrella' : ' estrellas'),
                    style: font1)
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Evaluación profesional:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
                width: double.infinity,
                child: TextField(
                    controller: _editController,
                    keyboardType: TextInputType.text,
                    minLines: 8,
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.black))))),
            SizedBox(height: 20),
            _getBotones(context),
          ],
        ));
  }

  Widget _starsQuestion2(BuildContext context) {
    return SmoothStarRating(
        allowHalfRating: false,
        onRated: (value) {},
        starCount: 5,
        rating: _response2.toDouble(),
        size: 30,
        color: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        spacing: 0.0);
  }

  Widget _starsQuestion1(BuildContext context) {
    return SmoothStarRating(
        allowHalfRating: false,
        onRated: (value) {},
        starCount: 5,
        rating: _response1.toDouble(),
        size: 30,
        color: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        spacing: 0.0);
  }

  Widget _starsPromedio(BuildContext context) {
    return SmoothStarRating(
        allowHalfRating: true,
        onRated: (value) {},
        starCount: 5,
        rating: _promedio,
        size: 30,
        color: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        spacing: 0.0);
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
            Navigator.pushReplacementNamed(context, 'cuestionario',
                arguments: [_adulto, _idModulo, _idVideo, _idHistorial]);
          },
        ),
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
    if (_isButtonDisabled) {
      setState(() {});
      return null;
    }

    _isButtonDisabled = true;
    HistorialModel historial = await DBProvider.db.getHistorialId(_idHistorial);
    historial.evaluacion = _editController.text;

    historial.resp1 = _response1.toString();
    historial.resp2 = _response2.toString();

    await DBProvider.db.updateHistorial(historial);
    /*List<HistorialModel> historia =
                        await DBProvider.db.getAllHistorial();
                    historia.forEach((f) {
                      if (f.id == historial.id)
                        print(
                            '${f.id} ${f.idAdulto} ${f.idModulo} ${f.idVideo} ${f.resp1} ${f.resp2} ${f.fecha} ${f.evaluacion}\n');
                    });*/

    String now = DateFormat("yyyy/MM/dd").format(DateTime.now());

    DateTime fecha = DateFormat('yyyy-MM-dd hh:mm:ss').parse(historial.fecha);
    String f = DateFormat('dd-MM-yyyy').format(fecha);
    String h = DateFormat('kk:mm:ss').format(fecha);

    final smtpServer = gmail(_userName, _password);

    String html = utils.html;
    html =
        html.replaceAll('{{TITLE}}', '${_adulto.nombres} ${_adulto.apellidos}');

    String body =
        ''' <table cellpadding="0" cellspacing="0" class="es-left" align="left"
                                                style="border-collapse:collapse;border-spacing:0px;float:left;"> '''
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Rut:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${_adulto.rut}</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Escolaridad:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${_adulto.escolaridad}</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Fecha de nacimiento:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${_adulto.fechaNacimiento}</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Fono:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${_adulto.fono}</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Ingresos:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${_adulto.ingresos}</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Sexo:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${_adulto.sexo}</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Información adicional:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${_adulto.infoAdicional}</td>'''
        '</tr>'
        '<tr><td align="center" colspan="2">Evaluación</td></tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Fecha de la evaluación:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">$f [$h]</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Módulo:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${utils.modulos[historial.idModulo - 1]['nombre']}</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">video:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${utils.modulos[historial.idModulo - 1][historial.idVideo]}</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">¿El adulto mayor se muestra predispuesto/a a realizar el ejercicio?:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${historial.resp1} estrellas</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">¿Ejecuta el ejercicio sin problemas?:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${historial.resp2} estrella(s)</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Promedio:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${_promedio.toString()} estrella(s)</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Visualizaciones del video:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${historial.visualizaciones} visualización(es)</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Evaluación profesional:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${historial.evaluacion}</td>'''
        '</tr>'
        '</table>';

    html = html.replaceAll('{{BODY}}', body);

    final message = Message()
      ..from = Address(_userName, utils.user.name)
      ..recipients.add(_contacto)
      ..subject =
          '${utils.user.name.toUpperCase()} [${_adulto.nombres} ${_adulto.apellidos}] - $now'
      ..html = html;
    try {
      final sendReport = await send(message, smtpServer);

      //utils.showToast(context, 'Correo enviado a: $_contacto');
      await DBProvider.db.updateEnviadoHistorial(historial.id);
      print('Message sent: ' + sendReport.toString());
      _showSnack('Mensaje enviado: ', sendReport.toString(), context);
    } on Exception catch (e) {
      //print('Message not sent.');
      //utils.showToast(context, 'Error al enviar el correo!!!');

      _showSnack('Mensaje no enviado', e?.toString(), context);
    }
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
        Navigator.of(context)
            .pushReplacementNamed('video', arguments: _adulto);
      });
  }
}
