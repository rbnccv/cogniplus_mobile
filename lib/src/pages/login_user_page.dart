import 'dart:convert';

import 'package:cogniplus_mobile/src/model/user_model.dart';
import 'package:cogniplus_mobile/src/pages/register_user_page.dart';
import 'package:cogniplus_mobile/src/pages/seniors_list_page.dart';
import 'package:cogniplus_mobile/src/providers/api.dart';
import 'package:cogniplus_mobile/src/providers/userSharedPreferences.dart';
import 'package:cogniplus_mobile/src/widgets/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:url_launcher/url_launcher.dart';

//Text('headline', style: Theme.of(context).textTheme.headline,),

class LoginUserPage extends StatefulWidget {
  //static final _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  _LoginUserPageState createState() => _LoginUserPageState();
}

class _LoginUserPageState extends State<LoginUserPage> {
  String _email;
  String _password;
  bool _rememberMe = true;
  bool _isLoading = false;
  FlutterSecureStorage _storage = FlutterSecureStorage();
  String _userEmail;
  String _userPass;

  final _preferences = new UserSharedPreferences();

  final Widget figure =
      new SvgPicture.asset('assets/svg/figura.svg', color: Colors.grey);

  @override
  void initState() {
    super.initState();
    if (utils.user != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => SeniorListPage()));
    }
    setInit();
  }

  setInit() async {
    _userEmail = _preferences.userEmail;
    _userPass = _preferences.userPass;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: utils.primary,
        body: SafeArea(
          child: _createStack(context),
        ),
      ),
    );
  }

  _createStack(BuildContext context) {
    return new Stack(children: <Widget>[
      _getWidgetBodyForm(context),
      Align(
          alignment: Alignment(-0.9, -0.9),
          child: Column(children: <Widget>[
            Text('¿No tienes Cuenta?', style: utils.estBodyAccent14),
            MaterialButton(
              elevation: 3,
                color: utils.accent,
                child: Text('REGISTRATE', style: utils.estBodyWhite18),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return RegisterUserPage();
                  }));
                })
          ])),
      Align(
          alignment: Alignment(0.9, 0.9),
          child: Container(
            width: 100.0,
            height: 100.0,
            //color: Colors.red,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Politicas de privacidad',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.landmark, size: 25),
                    onPressed: () async {
                      const url = "https://cogniplus.cf/policy";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw "imposible lanzar la url: " + url;
                      }
                    },
                  ),
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
              height: 500.0,
              width: 270.0,
              //color: Colors.red,
              child: Center(
                  child: Stack(children: <Widget>[
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 240.0,
                    height: 120.0,
                  ),
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
      key: widget._formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InputText(
              hint: "Correo electrónico",
              value: (this._userEmail != null) ? this._userEmail : "",
              onSaved: (value) => _email = value,
              inputType: TextInputType.emailAddress,
              fontSize: 20,
              prefixIcon: Icons.mail_outline,
              validator: (value) {
                if (!value.contains("@")) return "Correo invalido";
                if (value.isEmpty) return "Debe ingresar un Correo válido";

                return null;
              }),
          SizedBox(height: 20, width: 0),
          InputText(
              value: (this._userPass != null) ? this._userPass : "",
              hint: "Contraseña.",
              onSaved: (value) => _password = value,
              isSecure: true,
              prefixIcon: Icons.lock_outline,
              inputType: TextInputType.text,
              fontSize: 20,
              validator: (value) {
                if (value.isEmpty) return "La contraseña está vacia.";

                return null;
              }),
          SizedBox(height: 10, width: 0),
          CheckboxListTile(
              title: Text('Recuerdame.',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500)),
              activeColor: Colors.white,
              checkColor: Colors.green,
              value: _rememberMe,
              onChanged: (bool value) {
                setState(() {
                  _rememberMe = value;
                });
              }),
          SizedBox(height: 40, width: 0),
          _loginButton(context),
          //Text('Olvide mi contraseña', style: utils.estBodyAccent14),
        ],
      ),
    );
  }

  String _buttonText = 'INICIAR SESIÓN';
  Widget _loginButton(BuildContext context) {
    return MaterialButton(
        elevation: 3,
        color: utils.accent,
        disabledColor: Color(0xff808C95),
        disabledTextColor: Colors.grey[400],
        disabledElevation: 0,
        height: 50,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: Text(
              '$_buttonText',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Quicksand'),
            )),
        onPressed: _isLoading
            ? null
            : () {
                setState(() {
                  _isLoading = true;
                  _buttonText = 'Autenticando...';
                  _loginUser(context);
                });
              });
  }

  void _loginUser(BuildContext context) async {
    if (!widget._formKey.currentState.validate()) {
      setState(() {
        _buttonText = 'INICIAR SESIÓN';
        _isLoading = false;
        return null;
      });
    }

    widget._formKey.currentState.save();

    var data = {
      'email': _email.trim(),
      'password': _password.trim(),
      'remember_me': _rememberMe
    };

    var connectivity = await Connectivity().checkConnectivity();

    switch (connectivity) {
      case ConnectivityResult.none:
        utils.showToast(context, 'sin conexión.');
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        _loginFromNetwork(data, context);
        break;
      default:
        print('Error: $connectivity');
    }
  }

  _loginFromNetwork(data, context) async {
    try {
      var response = await Api().authData(data, '/auth/login');
      var body = json.decode(response.body);

      if (body['access_token'] != null) {
        _isLoading = false;
        utils.user =
            UserModel(id: body['id'], name: body['name'], email: body['email']);

        await _storage.write(key: 'access_token', value: body['access_token']);
        await _storage.write(key: 'token_type', value: body['token_type']);
        await _storage.write(key: 'expires_at', value: body['expires_at']);

        _preferences.userEmail = data["email"];
        _preferences.userPass = data["password"];

        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return SeniorListPage();
        }));
      } else {
        setState(() {
          _isLoading = false;
          _buttonText = 'INICIAR SESIÓN';
          utils.showSnack("Error", 'Error en el token', context);
        });

        utils.showSnack('Mensaje', body['message'], context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _buttonText = 'INICIAR SESIÓN';
        utils.showSnack("Error", e.toString(), context);
      });
    }
  }
}
