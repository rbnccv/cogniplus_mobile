import 'dart:convert';

import 'package:cogniplus_mobile/src/pages/login_user_page.dart';
import 'package:cogniplus_mobile/src/providers/api.dart';
import 'package:cogniplus_mobile/src/widgets/input_text.dart';
import 'package:flutter/material.dart';
import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connectivity/connectivity.dart';

class RegisterUserPage extends StatefulWidget {
  

  @override
  _RegisterUserPageState createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final _registerFormKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _password;
  String _passwordConfirmation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

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
            MaterialButton(
                color: utils.accent,
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 2),
                    child: Text('VOLVER', style: utils.estBodyWhite18)),
                onPressed: () {
                  Navigator.of(context).pop();
                })
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
                  Text('Siganos', style: utils.estBodyAccent14),
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
              height: 500.0,
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
                      height: 80.0,
                    )),
                Positioned(
                    top: 100,
                    left: 5,
                    child: Container(
                      width: 260, height: 450,
                      //color: Colors.green,
                      child: _getWidgetLoginForm(),
                    ))
              ])))),
    );
  }

  Widget _getWidgetLoginForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InputText(
              hint: "Nombre",
              onSaved: (value) => _name = value.trim(),
              inputType: TextInputType.text,
              fontSize: 20,
              prefixIcon: Icons.face,
              validator: (value) {
                if (value.isEmpty)
                  return "Debe ingresar al menos un nombre de usuario.";
                return null;
              }),
          SizedBox(height: 10, width: 0),
          InputText(
              hint: "Correo electrónico",
              onSaved: (value) => _email = value.trim(),
              inputType: TextInputType.emailAddress,
              fontSize: 20,
              prefixIcon: Icons.mail_outline,
              validator: (value) {
                if (!value.contains("@")) return "Correo invalido";
                if (value.isEmpty) return "Debe ingresar un Correo válido";

                return null;
              }),
          SizedBox(height: 10, width: 0),
          InputText(
              hint: "Contraseña.",
              onSaved: (value) => _password = value.trim(),
              isSecure: true,
              prefixIcon: Icons.lock_outline,
              inputType: TextInputType.text,
              fontSize: 20,
              validator: (value) {
                if (value.isEmpty) return "La contraseña está vacia.";

                return null;
              }),
          SizedBox(height: 10, width: 0),
          InputText(
              hint: "Confirme su contraseña.",
              onSaved: (value) => _passwordConfirmation = value.trim(),
              isSecure: true,
              prefixIcon: Icons.lock,
              inputType: TextInputType.text,
              fontSize: 20,
              validator: (value) {
                if (value.isEmpty) return "La contraseña está vacia.";
                return null;
              }),
          SizedBox(height: 20, width: 0),
          MaterialButton(
              color: utils.accent,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                  child: Text(
                    _isLoading ? 'Registrandose...' : 'REGISTRATE',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Quicksand'),
                  )),
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });

                _registerUser(context);
              }),
        ],
      ),
    );
  }

  void _registerUser(BuildContext context) async {
    if (!_registerFormKey.currentState.validate()) {
      _isLoading = false;
      return null;
    }

    _registerFormKey.currentState.save();

    var data = {
      'name': _name,
      'email': _email,
      'password': _password,
      'password_confirmation': _passwordConfirmation,
    };
    if (_password.compareTo(_passwordConfirmation) != 0) {
      utils.showToast(
          context, "La contraseña y su confirmación deben coincidir.");
      _isLoading = false;
      return;
    }

    var connectivity = await Connectivity().checkConnectivity();

    if (connectivity != ConnectivityResult.none) {
      _registerFromNetwork(data, context);
    }
  }

  _registerFromNetwork(data, context) async {
    utils.showToast(context, 'Online');

    //var response = await Api().authData(data, '/auth/signup');
    var response =
        await Api().setPostDataFromApi(url: '/auth/signup', data: data);

    var body = json.decode(response.body);
    String msg = '';

    if (response.statusCode == 201 && body['user']['id'] != null) {
      msg = body["message"].toString();
      utils.showSnack('Mensaje', msg, context);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginUserPage()));
    } else {
      setState(() {
        _isLoading = false;
      });

      // if (body['message'] != null) {
      //   msg = body['message'].toString() + "\n";
      // }

      if (body['errors'] == null) return;
      body['errors'].forEach((key, value) {
        msg += "- " + value.toString() + "\n";
      });

      utils.showSnack('Mensaje', msg, context);
    }
  }
}
