import 'package:flutter/material.dart';
import 'package:cogniplus_mobile/src/pages/home_pages.dart';
import 'package:cogniplus_mobile/src/pages/login_pages.dart';
import 'package:cogniplus_mobile/src/pages/video_pages.dart';
import 'package:cogniplus_mobile/src/pages/form_adulto_pages.dart';
import 'package:cogniplus_mobile/src/pages/cuestionario_pages.dart';
import 'package:cogniplus_mobile/src/pages/evaluacion_pages.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(CogniApp());

class CogniApp extends StatelessWidget {
  final primary             = const Color(0xff67CABA);
  final accent              = const Color(0xff323E47);
  final fontColor           = const Color(0xff303E48);
  final scaffoldBackground  = const Color(0xffE6E6E6);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COGNI APPLICATION',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        //const Locale('en', 'US'), // English
        const Locale('es', 'ES'),
      ],
      initialRoute: 'login',
      routes: {
        'home':         (BuildContext context) => HomePage(),
        'login':        (BuildContext context) => LoginPage(),
        'formadulto':   (BuildContext context) => FormAdultoPage(),
        'video':        (BuildContext context) => VideoPage(),
        'cuestionario': (BuildContext context) => CuestionarioPage(),
        'evaluacion':   (BuildContext context) => EvaluacionPage(),
      },
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (context) => LoginPage()),
      theme: ThemeData(
        primaryColor: primary,
        accentColor: accent,
        brightness: Brightness.light,
        scaffoldBackgroundColor: scaffoldBackground,
        fontFamily: 'Quicksand',
      ),
    );
  }
}
