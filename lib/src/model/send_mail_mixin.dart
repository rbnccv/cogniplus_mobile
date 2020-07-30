import 'package:cogniplus_mobile/src/model/adulto_model.dart';
import 'package:cogniplus_mobile/src/model/historial_model.dart';
import 'package:cogniplus_mobile/src/providers/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;

class EmailManager {
  String _username;
  String _password;
  String _contacto;
  SmtpServer _smtpServer;

  static final EmailManager _instance = EmailManager._internal();

  factory EmailManager() => _instance;

  EmailManager._internal() {
    _username = 'cogniplus.santo.tomas@gmail.com';
    _password = 'Santo_tomas';
    _contacto = 'cogniplus.santo.tomas@gmail.com';
    _smtpServer = gmail(_username, _password);
  }

  sendEmail(AdultoModel adulto, HistorialModel historial,
      BuildContext context) async {
    String html = getEmailHtml(adulto, historial);
    String now = DateFormat("yyyy/MM/dd").format(DateTime.now());

    final message = Message()
      ..from = Address(_username, utils.user.name)
      ..recipients.add(_contacto)
      ..subject =
          '${utils.user.name.toUpperCase()} [${adulto.nombres} ${adulto.apellidos}] - $now'
      ..html = html;

    try {
      await send(message, _smtpServer);
      await DBProvider.db.updateEnviadoHistorial(historial.id);
      utils.showSnack('Info', 'correo electrónico enviado.', context);
    } on Exception catch (e) {
      print(e?.toString());
      utils.showToast(context, 'Correo no enviado.');
    }
  }

  String getEmailHtml(AdultoModel adulto, HistorialModel historial) {
    DateTime fecha = DateFormat('yyyy-MM-dd hh:mm:ss').parse(historial.fecha);
    String f = DateFormat('dd-MM-yyyy').format(fecha);
    String h = DateFormat('kk:mm:ss').format(fecha);

    var html = utils.html;

    html =
        html.replaceAll('{{TITLE}}', '${adulto.nombres} ${adulto.apellidos}');

  
    var resp1 = (historial.resp1 == null) ? 0 : int.parse(historial.resp1);
    var resp2 = (historial.resp1 == null) ? 0 : int.parse(historial.resp2);
    var evaluacion =
        (historial.evaluacion == null && (resp1 == 0 || resp2 == 0))
            ? 'Sin calificación.'
            : historial.evaluacion;

    double promedio = (resp2 == 0) ? 0 : ((resp1 + resp2) / 2);

    String body =
        ''' <table cellpadding="0" cellspacing="0" class="es-left" align="left"
                                                style="border-collapse:collapse;border-spacing:0px;float:left;"> '''
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Rut:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${adulto.rut}</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Escolaridad:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${adulto.escolaridad}</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Fecha de nacimiento:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${adulto.fechaNacimiento}</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Fono:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${adulto.fono}</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Ingresos:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${adulto.ingresos}</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Sexo:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${adulto.sexo}</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Información adicional:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${adulto.infoAdicional}</td>'''
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
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">$resp1 estrellas</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">¿Ejecuta el ejercicio sin problemas?:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">$resp2 estrella(s)</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Promedio:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${promedio.toString()} estrella(s)</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Visualizaciones del video:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">${historial.visualizaciones} visualización(es)</td>'''
        '</tr>'
        '<tr style="border-collapse:collapse;">'
        '''<td align="left" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">Evaluación profesional:</td>'''
        '''<td align="right" style="padding:0;Margin:0;line-height:120%;font-size:16px;color:#666666;">$evaluacion</td>'''
        '</tr>'
        '</table>';

    return html.replaceAll('{{BODY}}', body);
  }
}
