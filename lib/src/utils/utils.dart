import 'dart:convert';

import 'package:cogniplus_mobile/src/model/user_model.dart';
import 'package:cogniplus_mobile/src/pages/login_user_page.dart';
import 'package:cogniplus_mobile/src/providers/api.dart';
import 'package:cogniplus_mobile/src/widgets/videp_player_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
    mainButton: MaterialButton(
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
  // Navigator.of(context).pushAndRemoveUntil(
  //     MaterialPageRoute(builder: (context) => LoginUserPage()),
  //     (Route<dynamic> route) => false);

  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginUserPage()));
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

void showIntroVideo(BuildContext context) {
  VideoPlayerController controller =
      new VideoPlayerController.asset("assets/intro.mp4");
  showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: Center(
                child: Container(
                  child: VideoPlayerWidget(
                    videocontroller: controller,
                    newKey: UniqueKey(),
                    allowFullScreen: true,
                    showControls: false,
                  ),
                ),
              ),
            ),
          ),
        );
      });
}

final imagesName = [
  {
    "name": "Beber agua y respiración abdominal.",
    "image": "m1v1",
  },
  {
    "name": "Dedos circulares.",
    "image": "m1v2",
  },
  {
    "name": "Baile de manos.",
    "image": "m1v3",
  },
  {
    "name": "Nadar al reves",
    "image": "m1v4",
  },
  {
    "name": "Botones de tu cuerpo.",
    "image": "m1v5",
  },
  {
    "name": "Nudos.",
    "image": "m1v6",
  },
  {
    "name": "8 Perezoso o de costado.",
    "image": "m2v1",
  },
  {
    "name": "Arriba y abajo.",
    "image": "m2v2",
  },
  {
    "name": "Pinzas alternas.",
    "image": "m2v3",
  },
  {
    "name": "Escalera de dedos.",
    "image": "m2v4",
  },
  {
    "name": "Rayas.",
    "image": "m2v5",
  },
  {
    "name": "Secuencias.",
    "image": "m3v1",
  },
  {
    "name": "Garabateo Doble.",
    "image": "m3v2",
  },
  {
    "name": "Nariz y orejas cruzados.",
    "image": "m3v3",
  },
  {
    "name": "Pulgares opuestos.",
    "image": "m3v4",
  },
  {
    "name": "Tijeras y Circulos.",
    "image": "m3v5",
  },
  {
    "name": "Gateo cruzado.",
    "image": "m4v1",
  },
  {
    "name": "Meñique y pulgar alternados.",
    "image": "m4v2",
  },
  {
    "name": "Circulos y cuadrados en el aire.",
    "image": "m4v3",
  },
  {
    "name": "Pulgares opuestos complejos.",
    "image": "m4v5",
  },
];

void showInfo(BuildContext context) {
  //final imageName =
  //  "m" + m[i].toString() + "v" + v[j].toString() + ".png";
  showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: Center(
                child: Container(
                  child: ListView.builder(
                      itemCount: imagesName.length,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          Text(
                            imagesName[index]['name'],
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Image.asset(
                            "assets/images/${imagesName[index]['image']}.png",
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 20),
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: Text(
                                    "No Existe información adicional.",
                                    style: TextStyle(fontSize: 20),
                                  ));
                            },
                          ),
                          SizedBox(height: 5),
                        ]);
                      }),
                ),
              ),
            ),
          ),
        );
      });
}
