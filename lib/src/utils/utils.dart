import 'dart:convert';

import 'package:cogniplus_mobile/src/model/user_model.dart';
import 'package:cogniplus_mobile/src/providers/api.dart';
import 'package:flushbar/flushbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

final primary = const Color(0xff67CABA);
final accent = const Color(0xff323E47);
final fontColor = const Color(0xff303E48);
final scaffoldBackground = const Color(0xffE6E6E6);

final estTitulo = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Montserrat',
  color: accent,
);
final estSubtitulo = TextStyle(
  fontSize: 48.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Montserrat',
);
final estBodyBlack18 = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.normal,
  fontFamily: 'Quicksand',
);

final estBodyAccent16 = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.normal,
  fontFamily: 'Quicksand',
  color: accent,
);

final estBodyAccent19 = TextStyle(
  fontSize: 19.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Quicksand',
  color: accent,
);

final estBodyAccent14 = TextStyle(
  fontSize: 14.0,
  color: accent,
  fontWeight: FontWeight.normal,
  fontFamily: 'Quicksand',
);

final estBodyWhite18 = TextStyle(
  fontSize: 18.0,
  color: Colors.white,
  fontWeight: FontWeight.normal,
  fontFamily: 'Quicksand',
);
showToast(BuildContext context, String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: Theme.of(context).accentColor,
      textColor: Colors.white,
      fontSize: 16.0);
}

void showSnack(String title, String message, BuildContext context) {
  Flushbar flush;

  flush = Flushbar<bool>(
    backgroundColor: accent,
    //showProgressIndicator: true,
    title: title,
    message: message,
    icon: Icon(
      Icons.info_outline,
      color: primary,
      size: 34.0,
    ),
    //dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    //flushbarStyle: FlushbarStyle.GROUNDED,
    isDismissible: false,
    mainButton: FlatButton(
        child: Text("OK", style: TextStyle(color: Colors.amber)),
        onPressed: () {
          flush.dismiss(true); // result = true
        }),
  )..show(context);
}

logoff(BuildContext context) async {
  user = null;

  var response = await Api().getDataFromApi(url: '/logout');
  var body = json.decode(response.body);

  showToast(context, body['message']);

  Navigator.of(context)
      .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
}

onBackPressed(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('Seguro?'),
      content: new Text('Deseas salir de la aplicación.'),
      actions: <Widget>[
        new GestureDetector(
          onTap: () => Navigator.of(context).pop(false),
          child: Text("NO"),
        ),
        SizedBox(height: 16),
        new GestureDetector(
          onTap: () => Navigator.of(context).pop(true),
          child: Text("YES"),
        ),
      ],
    ),
  ) ??
      false;
}

UserModel user;

final String folder = "assets/videos";
final String intro = "$folder/Introduccion.mp4";

final List<String> listFilesModulo1 = [
  "$folder/modulo1/beberaguayrespiracion.mp4",
  "$folder/modulo1/dedoscirculares.mp4",
  "$folder/modulo1/bailedemanos.mp4",
  "$folder/modulo1/nadaralreves.mp4",
  "$folder/modulo1/botonesdetucuerpo.mp4",
  "$folder/modulo1/nudos.mp4",
  "$folder/modulo1/1.mp4"
];

final List<String> listFilesModulo2 = [
  "$folder/modulo2/8perezosoodecostado.mp4",
  "$folder/modulo2/arribayabajo.mp4",
  "$folder/modulo2/pinzasalternas.mp4",
  "$folder/modulo2/escalerasdededos.mp4",
  "$folder/modulo2/rayas.mp4",
  "$folder/modulo2/2.mp4"
];

final List<String> listFilesModulo3 = [
  "$folder/modulo3/1secuencias.mp4",
  "$folder/modulo3/2garabateodoble.mp4",
  "$folder/modulo3/3narizorejacruzado.mp4",
  "$folder/modulo3/4pulgaresopuestos.mp4",
  "$folder/modulo3/5tijerasycirculos.mp4",
  "$folder/modulo3/3.mp4"
]; //revisar

final List<String> listFilesModulo4 = [
  "$folder/modulo4/1gateocruzado.mp4",
  "$folder/modulo4/2meniqueypulgaralternado.mp4",
  "$folder/modulo4/3circulosycuadradosenelaire.mp4",
  "$folder/modulo4/4pulgaresopuestoscomplejos.mp4",
  "$folder/modulo4/4.mp4"
  //"$folder/modulo4/desafios.mp4",
]; //revisar

final modulos = [m1, m2, m3, m4];
Map m1 = {
  'nombre': 'Módulo 1: Soy corpóreo.',
  1: 'Beber agua y respiración abdominal.',
  2: 'Dedos circulares.',
  3: 'Baile de manos.',
  4: 'Nadar al reves',
  5: 'Botones de tu cuerpo.',
  6: 'Nudos.',
  7: 'Consejos'
};

Map m2 = {
  'nombre': 'Módulo 2: Cuerpo atento.',
  1: '8 perezoso o de acostado.',
  2: 'Arriba y abajo.',
  3: 'Pinzas alternas.',
  4: 'Escaleras de dedos.',
  5: 'Rayas.',
  6: 'Consejos'
};

Map m3 = {
  'nombre': 'Módulo 3: Memoria y movimiento.',
  1: 'Secuencias.',
  2: 'Garabateo doble.',
  3: 'Nariz y oreja cruzado.',
  4: 'Pulgares opuestos.',
  5: 'Tijeras-círculos.',
  6: 'Consejos'
};

Map m4 = {
  'nombre': 'Módulo 4: Cuerpo orientado.',
  1: 'Gateo cruzado.',
  2: 'Meñique y pulgar alternados.',
  3: 'Círculos y cuadrados en el aire.',
  4: 'Pulgares opuestos complejos.',
  5: 'Consejos',
  //6: 'Desafios'
};

String html = '''

<!DOCTYPE html
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html
    style="width:100%;font-family:arial, 'helvetica neue', helvetica, sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0;">

<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1" name="viewport">
    <meta name="x-apple-disable-message-reformatting">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta content="telephone=no" name="format-detection">
    <title>New email</title>
    <!--[if (mso 16)]>
    <style type="text/css">
    a {text-decoration: none;}
    </style>
    <![endif]-->
    <!--[if gte mso 9]><style>sup { font-size: 100% !important; }</style><![endif]-->
    <style type="text/css">
        @media only screen and (max-width:600px) {

            p,
            ul li,
            ol li,
            a {
                font-size: 16px !important
            }

            h1 {
                font-size: 30px !important;
                text-align: center
            }

            h2 {
                font-size: 26px !important;
                text-align: center
            }

            h3 {
                font-size: 20px !important;
                text-align: center
            }

            h1 a {
                font-size: 30px !important
            }

            h2 a {
                font-size: 26px !important
            }

            h3 a {
                font-size: 20px !important
            }

            .es-menu td a {
                font-size: 16px !important
            }

            .es-header-body p,
            .es-header-body ul li,
            .es-header-body ol li,
            .es-header-body a {
                font-size: 16px !important
            }

            .es-footer-body p,
            .es-footer-body ul li,
            .es-footer-body ol li,
            .es-footer-body a {
                font-size: 16px !important
            }

            .es-infoblock p,
            .es-infoblock ul li,
            .es-infoblock ol li,
            .es-infoblock a {
                font-size: 12px !important
            }

            *[class="gmail-fix"] {
                display: none !important
            }

            .es-m-txt-c,
            .es-m-txt-c h1,
            .es-m-txt-c h2,
            .es-m-txt-c h3 {
                text-align: center !important
            }

            .es-m-txt-r,
            .es-m-txt-r h1,
            .es-m-txt-r h2,
            .es-m-txt-r h3 {
                text-align: right !important
            }

            .es-m-txt-l,
            .es-m-txt-l h1,
            .es-m-txt-l h2,
            .es-m-txt-l h3 {
                text-align: left !important
            }

            .es-m-txt-r img,
            .es-m-txt-c img,
            .es-m-txt-l img {
                display: inline !important
            }

            .es-button-border {
                display: block !important
            }

            .es-button {
                font-size: 20px !important;
                display: block !important;
                border-width: 10px 0px 10px 0px !important
            }

            .es-btn-fw {
                border-width: 10px 0px !important;
                text-align: center !important
            }

            .es-adaptive table,
            .es-btn-fw,
            .es-btn-fw-brdr,
            .es-left,
            .es-right {
                width: 100% !important
            }

            .es-content table,
            .es-header table,
            .es-footer table,
            .es-content,
            .es-footer,
            .es-header {
                width: 100% !important;
                max-width: 600px !important
            }

            .es-adapt-td {
                display: block !important;
                width: 100% !important
            }

            .adapt-img {
                width: 100% !important;
                height: auto !important
            }

            .es-m-p0 {
                padding: 0px !important
            }

            .es-m-p0r {
                padding-right: 0px !important
            }

            .es-m-p0l {
                padding-left: 0px !important
            }

            .es-m-p0t {
                padding-top: 0px !important
            }

            .es-m-p0b {
                padding-bottom: 0 !important
            }

            .es-m-p20b {
                padding-bottom: 20px !important
            }

            .es-mobile-hidden,
            .es-hidden {
                display: none !important
            }

            .es-desk-hidden {
                display: table-row !important;
                width: auto !important;
                overflow: visible !important;
                float: none !important;
                max-height: inherit !important;
                line-height: inherit !important
            }

            .es-desk-menu-hidden {
                display: table-cell !important
            }

            table.es-table-not-adapt,
            .esd-block-html table {
                width: auto !important
            }

            table.es-social {
                display: inline-block !important
            }

            table.es-social td {
                display: inline-block !important
            }
        }
    </style>
</head>

<body
    style="width:100%;font-family:arial, 'helvetica neue', helvetica, sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0;">
    <div class="es-wrapper-color" style="background-color:#F6F6F6;">
        <!--[if gte mso 9]>
			<v:background xmlns:v="urn:schemas-microsoft-com:vml" fill="t">
				<v:fill type="tile" color="#f6f6f6"></v:fill>
			</v:background>
		<![endif]-->
        <table cellpadding="0" cellspacing="0" class="es-wrapper" width="100%"
            style="border-collapse:collapse;border-spacing:0px;padding:0;Margin:0;width:100%;height:100%;background-repeat:repeat;background-position:center top;">
            <tr style="border-collapse:collapse;">
                <td valign="top" style="padding:0;Margin:0;">
                    <table cellpadding="0" cellspacing="0" class="es-content" align="center"
                        style="border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;">
                        <tr style="border-collapse:collapse;">
                            <td align="center" style="padding:0;Margin:0;">
                                <table class="es-content-body" align="center" cellpadding="0" cellspacing="0"
                                    width="600"
                                    style="border-collapse:collapse;border-spacing:0px;background-color:transparent;">
                                    <tr style="border-collapse:collapse;">
                                        <td align="left" style="padding:20px;Margin:0;">
                                            <!--[if mso]><table width="560"><tr><td width="356" valign="top"><![endif]-->
                                            <table cellpadding="0" cellspacing="0" class="es-left" align="left"
                                                style="border-collapse:collapse;border-spacing:0px;float:left;">
                                                <tr style="border-collapse:collapse;">
                                                    <td width="356" class="es-m-p0r es-m-p20b" valign="top"
                                                        align="center" style="padding:0;Margin:0;">
                                                        <table cellpadding="0" cellspacing="0" width="100%"
                                                            style="border-collapse:collapse;border-spacing:0px;">
                                                            <tr style="border-collapse:collapse;">
                                                                <td align="left" class="es-infoblock es-m-txt-c"
                                                                    style="padding:0;Margin:0;line-height:120%;font-size:12px;color:#CCCCCC;">
                                                                    <p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;font-size:12px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:120%;color:#CCCCCC;">
                                                                        {{TITLE}} 
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <!--[if mso]></td><td width="20"></td><td width="184" valign="top"><![endif]-->
                                            <table cellpadding="0" cellspacing="0" align="right"
                                                style="border-collapse:collapse;border-spacing:0px;">
                                                <tr style="border-collapse:collapse;">
                                                    <td width="184" align="left" style="padding:0;Margin:0;">
                                                        <table cellpadding="0" cellspacing="0" width="100%"
                                                            style="border-collapse:collapse;border-spacing:0px;">
                                                            <tr style="border-collapse:collapse;">
                                                                <td align="right" class="es-infoblock es-m-txt-c"
                                                                    style="padding:0;Margin:0;line-height:120%;font-size:12px;color:#CCCCCC;">
                                                                    <p
                                                                        style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;font-size:12px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:120%;color:#CCCCCC;">
                                                                        <a target="_blank"
                                                                            href="https://www.google.com/gmail/"
                                                                            style="-webkit-text-size-adjust:none;-ms-text-size-adjust:none;font-family:arial, 'helvetica neue', helvetica, sans-serif;font-size:12px;text-decoration:underline;color:#2CB543;">
                                                                            Correo Gmail</a></p>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <!--[if mso]></td></tr></table><![endif]-->
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <table cellpadding="0" cellspacing="0" class="es-content" align="center"
                        style="border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;">
                        <tr style="border-collapse:collapse;">
                            <td align="center" style="padding:0;Margin:0;">
                                <table class="es-content-body" align="center" cellpadding="0" cellspacing="0"
                                    width="600"
                                    style="border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;">
                                    <tr style="border-collapse:collapse;">
                                        <td align="left" style="padding:20px;Margin:0;">
                                            <table cellpadding="0" cellspacing="0" width="100%"
                                                style="border-collapse:collapse;border-spacing:0px;">
                                                <tr style="border-collapse:collapse;">
                                                    <td width="560" align="center" valign="top"
                                                        style="padding:0;Margin:0;">
                                                        <table cellpadding="0" cellspacing="0" width="100%"
                                                            style="border-collapse:collapse;border-spacing:0px;">
                                                            <tr style="border-collapse:collapse;">
                                                                <td align="left"
                                                                    style="padding:0;Margin:0;padding-bottom:15px;">
                                                                    <h2
                                                                        style="Margin:0;line-height:120%;font-family:arial, 'helvetica neue', helvetica, sans-serif;font-size:24px;font-style:normal;font-weight:normal;color:#333333;">
                                                                        {{TITLE}}
                                                                    </h2>
                                                                </td>
                                                            </tr>
                                                            <tr style="border-collapse:collapse;">
                                                            </tr>
                                                            <tr style="border-collapse:collapse;">
                                                                <td align="left"
                                                                    style="padding:0;Margin:0;padding-top:20px;">
                                                                    {{BODY}}
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <table cellpadding="0" cellspacing="0" class="es-footer" align="center"
                        style="border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top;">
                        <tr style="border-collapse:collapse;">
                            <td align="center" style="padding:0;Margin:0;">
                                <table class="es-footer-body" align="center" cellpadding="0" cellspacing="0" width="600"
                                    style="border-collapse:collapse;border-spacing:0px;background-color:transparent;">
                                    <tr style="border-collapse:collapse;">
                                        <td align="left"
                                            style="padding:0;Margin:0;padding-top:20px;padding-left:20px;padding-right:20px;">
                                            <table cellpadding="0" cellspacing="0" width="100%"
                                                style="border-collapse:collapse;border-spacing:0px;">
                                                <tr style="border-collapse:collapse;">
                                                    <td width="560" align="center" valign="top"
                                                        style="padding:0;Margin:0;">
                                                        <table cellpadding="0" cellspacing="0" width="100%"
                                                            style="border-collapse:collapse;border-spacing:0px;">
                                                            <tr style="border-collapse:collapse;">
                                                                <td align="center" style="padding:20px;Margin:0;">
                                                                    <table border="0" width="75%" height="100%"
                                                                        cellpadding="0" cellspacing="0"
                                                                        style="border-collapse:collapse;border-spacing:0px;">
                                                                        <tr style="border-collapse:collapse;">
                                                                            <td
                                                                                style="padding:0;Margin:0px 0px 0px 0px;border-bottom:1px solid #CCCCCC;background:none;height:1px;width:100%;margin:0px;">
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr style="border-collapse:collapse;">
                                                                <td align="center"
                                                                    style="padding:0;Margin:0;padding-top:10px;padding-bottom:10px;">
                                                                    <p
                                                                        style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;font-size:11px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:150%;color:#333333;">
                                                                        - COGNIPLUS - </p>
                                                                </td>
                                                            </tr>
                                                            <tr style="border-collapse:collapse;">
                                                                <td align="center"
                                                                    style="padding:0;Margin:0;padding-top:10px;padding-bottom:10px;">
                                                                    <p
                                                                        style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;font-size:11px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:150%;color:#333333;">
                                                                        © 2019 Cogniplus</p>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>
        </table>
    </div>
</body>

</html>

''';
