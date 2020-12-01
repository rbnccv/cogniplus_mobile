import 'package:cogniplus_mobile/src/pages/login_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './src/utils/utils.dart';

void main() {
 
  return runApp(new CogniApp());
}

class CogniApp extends StatelessWidget {
  final GlobalKey<ScaffoldState> globalScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cogniplus',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        primaryColor: primary,
        accentColor: accent,
        brightness: Brightness.light,
        scaffoldBackgroundColor: scaffoldBackground,
        fontFamily: 'Quicksand',
      ),
      home: LoginPage(),
    );
  }
}
