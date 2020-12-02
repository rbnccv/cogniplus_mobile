import 'package:cogniplus_mobile/src/pages/login_user_page.dart';
import 'package:cogniplus_mobile/src/providers/userSharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './src/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = new UserSharedPreferences();
  await preferences.initPreferences();

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
      home: LoginUserPage(),
    );
  }
}
