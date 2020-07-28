import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cogniplus_mobile/src/providers/db_provider.dart';
import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//Text('headline', style: Theme.of(context).textTheme.headline,),

class LoginPage extends StatefulWidget {
  static final _formKey = GlobalKey<FormState>();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _pass = '';
  String _name = '';

  final Widget figure =
      new SvgPicture.asset('assets/svg/figura.svg', color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: utils.primary,
      body: SafeArea(
        child: _createStack(context),
      ),
    );
  }

  _createStack(BuildContext context) {
    return new Stack(children: <Widget>[
      _getLogo(context),
      Align(
          alignment: Alignment(-0.9, -0.9),
          child: Column(children: <Widget>[
            Text('¿No tienes Cuenta?', style: utils.estBodyAccent12),
            FlatButton(
                color: utils.accent,
                child: Text('REGISTRATE', style: utils.estBodyWhite18),
                onPressed: () {})
          ])),
      Align(
          alignment: Alignment(0.9, 0.9),
          child: Container(
            width: 100.0,
            height: 80.0,
            //color: Colors.red,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Siganos', style: utils.estBodyAccent12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(FontAwesomeIcons.facebook, size: 35),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.twitterSquare, size: 35),
                        onPressed: () {},
                      ),
                    ],
                  )
                ]),
          )),
    ]);
  }

  Widget _getLogo(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(0, 80.0, 0, 0),
      child: Align(
          alignment: Alignment.center,
          child: Container(
              height: 400.0,
              width: 270.0,
              //color: Colors.red,
              child: Center(
                  child: Stack(children: <Widget>[
                Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 240.0,
                      height: 120.0,
                    )),
                Positioned(
                    top: 170,
                    left: 5,
                    child: Container(
                      width: 260,
                      height: 250,
                      //color: Colors.green,
                      child: Form(
                        key: LoginPage._formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              initialValue: 'casa1',
                              onSaved: (value) => _name = value,
                              decoration: InputDecoration(
                                  hintText: 'Nombre',
                                  fillColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  filled: true,
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.0)),
                                      borderSide:
                                          BorderSide(color: utils.accent))),
                              style: TextStyle(fontSize: 14),
                              validator: (value) {
                                if (value.isEmpty)
                                  return "El nombre esta vacio";

                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                              width: 0,
                            ),
                            TextFormField(
                              initialValue: 'casa1',
                              onSaved: (value) => _pass = value,
                              decoration: InputDecoration(
                                  hintText: 'Contraseña',
                                  fillColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  filled: true,
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.0)),
                                      borderSide:
                                          BorderSide(color: utils.accent))),
                              style: TextStyle(fontSize: 14),
                              validator: (value) {
                                if (value.isEmpty)
                                  return "La Contraseña esta vacia";

                                return null;
                              },
                            ),
                            SizedBox(height: 40, width: 0),
                            FlatButton(
                                color: utils.accent,
                                child: Text('INICIAR SESIÓN',
                                    style: utils.estBodyWhite18),
                                onPressed: () => _loginUser(context)),
                            Text('Olvide mi contraseña',
                                style: utils.estBodyAccent12),
                          ],
                        ),
                      ),
                    ))
              ])))),
    );
  }

  dynamic _loginUser(BuildContext context) async {
    if (!LoginPage._formKey.currentState.validate()) return null;

    LoginPage._formKey.currentState.save();

    utils.user = await DBProvider.db.getUserByName(_name);
    if (utils.user == null) {
      utils.showToast(context, "El usuario no existe.");
      return null;
    }

    if (!await DBProvider.db.verifyUserPass(_name, _pass)) {
      utils.showToast(context, 'Contraseña incorrecta.');
      return null;
    }

    Navigator.of(context).pushReplacementNamed('home');

    //Navigator.of(context).pushNamed('/');
  }
}
