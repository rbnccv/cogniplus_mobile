import 'dart:convert';

import 'package:cogniplus_mobile/src/model/user_model.dart';
import 'package:cogniplus_mobile/src/providers/api.dart';
import 'package:cogniplus_mobile/src/widgets/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//Text('headline', style: Theme.of(context).textTheme.headline,),

class LoginPage extends StatefulWidget {
  static final _formKey = GlobalKey<FormState>();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  String _remember_me;
  bool _isLoading = false;

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
      _getWidgetBodyForm(context),
      Align(
          alignment: Alignment(-0.9, -0.9),
          child: Column(children: <Widget>[
            Text('¿No tienes Cuenta?', style: utils.estBodyAccent12),
            FlatButton(
                color: utils.accent,
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 2),
                    child: Text('REGISTRATE', style: utils.estBodyWhite18)),
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

  Widget _getWidgetBodyForm(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(0, 80.0, 0, 0),
      child: Align(
          alignment: Alignment.center,
          child: Container(
              height: 450.0,
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
                      width: 260, height: 400,
                      //color: Colors.green,
                      child: _getWidgetLoginForm(),
                    ))
              ])))),
    );
  }

  Widget _getWidgetLoginForm() {
    return Form(
      key: LoginPage._formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InputText(
              hint: "Correo electrónico",
              onSaved: (value) => _email = value,
              inputType: TextInputType.emailAddress,
              fontSize: 20,
              prefixIcon: Icons.person,
              validator: (value) {
                if (!value.contains("@")) return "Correo invalido";
                if (value.isEmpty) return "Debe ingresar un Correo válido";

                return null;
              }),
          SizedBox(height: 20, width: 0),
          InputText(
              hint: "Contraseña.",
              onSaved: (value) => _password = value,
              isSecure: true,
              prefixIcon: Icons.lock,
              inputType: TextInputType.text,
              fontSize: 20,
              validator: (value) {
                if (value.isEmpty) return "La contraseña está vacia.";

                return null;
              }),
          SizedBox(height: 40, width: 0),
          FlatButton(
              color: utils.accent,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                  child: Text(
                    _isLoading ? 'Autenticando...' : 'INICIAR SESIÓN',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Quicksand'),
                  )),
              onPressed: () => _loginUser(context)),
          Text('Olvide mi contraseña', style: utils.estBodyAccent12),
        ],
      ),
    );
  }

  // dynamic _loginUser(BuildContext context) async {
  //   if (!LoginPage._formKey.currentState.validate()) return null;

  //   LoginPage._formKey.currentState.save();

  //   utils.user = await DBProvider.db.getUserByName(_name);
  //   if (utils.user == null) {
  //     utils.showToast(context, "El usuario no existe.");
  //     return null;
  //   }

  //   if (!await DBProvider.db.verifyUserPass(_name, _pass)) {
  //     utils.showToast(context, 'Contraseña incorrecta.');
  //     return null;
  //   }

  //   Navigator.of(context).pushReplacementNamed('home');

  //   //Navigator.of(context).pushNamed('/');
  // }

  void _loginUser(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    if (!LoginPage._formKey.currentState.validate()) return null;

    LoginPage._formKey.currentState.save();

    var data = {'email': _email, 'password': _password, 'remember_me': false};

    var response = await Api().authData(data, '/auth/login');
    var body = json.decode(response.body);

    if (body['access_token'] != null) {

      utils.user = UserModel(
        id: body['id'],
        name: body['name'],
        email: body['email']
      );

      FlutterSecureStorage storage = FlutterSecureStorage();
      storage.write(key: 'access_token', value: body['access_token']);
      storage.write(key: 'token_type', value: body['token_type']);
      storage.write(key: 'expires_at', value: body['expires_at']);

      Navigator.of(context).pushReplacementNamed('home');

    } else {
      setState(() {
        _isLoading = false;
      });

      utils.showSnack('Mensaje', body['message'], context);
    }
  }
}
