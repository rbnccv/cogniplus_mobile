import 'dart:convert';

import 'package:cogniplus_mobile/src/model/user_model.dart';
import 'package:cogniplus_mobile/src/pages/login_user_page.dart';
import 'package:cogniplus_mobile/src/providers/api.dart';
import 'package:flushbar/flushbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

UserModel user;

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
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginUserPage()),
      (Route<dynamic> route) => false);
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