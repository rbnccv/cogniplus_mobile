import 'dart:async';
import 'dart:convert';

import 'package:cogniplus_mobile/src/model/adulto_model.dart';
import 'package:cogniplus_mobile/src/providers/api.dart';
import 'package:cogniplus_mobile/src/providers/db_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;

enum TipoSexo { masculino, femenino }

class FormAdultoPage extends StatefulWidget {
  @override
  _FormAdultoPageState createState() => _FormAdultoPageState();
}

class _FormAdultoPageState extends State<FormAdultoPage> {
  static final _formKey = GlobalKey<FormState>();
  int _radioValue = 1;

  List<String> _gradoEscolaridad = [
    'Enseñanza básica incompleta',
    'Enseñanza básica completa',
    'Enseñanza media incompleta',
    'Enseñanza media completa',
    'Enseñanza superior incompleta',
    'Enseñanza superior completa'
  ];

  int _id = 0;
  String _nombre,
      _apellidos,
      _sexo,
      _escolaridad,
      _fechaNacimiento,
      _ingresos,
      _rut,
      _fono,
      _info,
      _email;

  TextEditingController _nombreTextController = new TextEditingController();
  TextEditingController _apellidoTextController = new TextEditingController();
  TextEditingController _ingresosTextController = new TextEditingController();
  TextEditingController _rutTextController = new TextEditingController();
  TextEditingController _infoTextController = new TextEditingController();
  TextEditingController _fonoTextController = new TextEditingController();

  bool _isUpdate = false;

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      final AdultoModel adulto = ModalRoute.of(context).settings.arguments;
      if (adulto != null) _setFormFields(adulto);
    });
    _nombre = '';
    _apellidos = '';
    _sexo = 'M';
    _escolaridad = 'Enseñanza básica incompleta';
    _fechaNacimiento = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _ingresos = '';
    _rut = '';
    _email = '';
    _fonoTextController.text = '(56) 9';
    _info = '';
  }

  @override
  void dispose() {
    _nombreTextController.dispose();
    _apellidoTextController.dispose();
    _ingresosTextController.dispose();
    _rutTextController.dispose();
    _infoTextController.dispose();
    _fonoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE6E6E6),
      appBar: _appbar(context),
      body: SafeArea(
        child: SingleChildScrollView(child: _getForm(context)),
      ),
    );
  }

  _appbar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.question, color: Colors.white),
              onPressed: () {}),
          Text(
            'Añadir perfil',
            style: utils.estTitulo,
          ),
          IconButton(
              icon: Icon(FontAwesomeIcons.powerOff, color: Colors.white),
              onPressed: () {}),
        ],
      ),
    );
  }

  _setFormFields(AdultoModel adulto) {
    _id = adulto.id;
    _nombreTextController.text = adulto.nombres;
    _apellidoTextController.text = adulto.apellidos;

    _escolaridad = adulto.escolaridad;
    _fechaNacimiento = adulto.fechaNacimiento;
    _ingresosTextController.text = adulto.ingresos;
    _rutTextController.text = adulto.rut;
    _fonoTextController.text = adulto.fono;
    _infoTextController.text = adulto.infoAdicional;
    _isUpdate = true;

    setState(() {
      _radioValue = (adulto.sexo == 'F') ? 0 : 1;
      _sexo = adulto.sexo;
    });
  }

  Widget _getForm(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2 - 40;
    final inputDecorator = InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.all(10.0),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.black)));

    return Container(
        padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 30.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Nombres:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0)),
                          SizedBox(width: 0, height: 10),
                          Container(
                              width: width,
                              child: TextFormField(
                                  controller: _nombreTextController,
                                  onSaved: (nombre) =>
                                      setState(() => _nombre = nombre),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value.length <= 0)
                                      return 'Debe ingresar un nombre.';
                                    return null;
                                  },
                                  style: TextStyle(fontSize: 14),
                                  decoration: inputDecorator))
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Apellidos:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0)),
                          SizedBox(width: 0, height: 10),
                          Container(
                              width: width,
                              child: TextFormField(
                                  controller: _apellidoTextController,
                                  onSaved: (apellidos) =>
                                      setState(() => _apellidos = apellidos),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) => null,
                                  style: TextStyle(fontSize: 14),
                                  decoration: inputDecorator))
                        ]),
                  ],
                ),
                SizedBox(width: 0, height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _makeRadioButton(width, context),
                    _makeDropdown(width),
                  ],
                ),
                SizedBox(width: 0, height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Fecha de nacimiento:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Container(
                            width: width,
                            child: _makeDate(context),
                          )
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Ingresos:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Container(
                              width: width,
                              child: TextFormField(
                                  controller: _ingresosTextController,
                                  onSaved: (value) =>
                                      setState(() => _ingresos = value),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) => null,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly,
                                  ],
                                  style: TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                      hintText: 'Aproximaciones de ingresos',
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          borderSide: BorderSide(
                                              color: Colors.black)))))
                        ]),
                  ],
                ),
                SizedBox(width: 0, height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Rut:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Container(
                              width: width,
                              child: TextFormField(
                                  controller: _rutTextController,
                                  onSaved: (value) =>
                                      setState(() => _rut = value),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) => null,
                                  style: TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          borderSide: BorderSide(
                                              color: Colors.black)))))
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Fono:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Container(
                              width: width,
                              child: TextFormField(
                                  controller: _fonoTextController,
                                  onSaved: (value) =>
                                      setState(() => _fono = value),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) => null,
                                  style: TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          borderSide: BorderSide(
                                              color: Colors.black)))))
                        ]),
                  ],
                ),
                SizedBox(width: 0, height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Información adicional:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Container(
                              width: width * 2,
                              child: TextFormField(
                                  controller: _infoTextController,
                                  onSaved: (value) =>
                                      setState(() => _info = value),
                                  keyboardType: TextInputType.multiline,
                                  minLines: 4,
                                  maxLines: 6,
                                  maxLengthEnforced: true,
                                  textInputAction: TextInputAction.newline,
                                  validator: (value) => null,
                                  style: TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          borderSide: BorderSide(
                                              color: Colors.black)))))
                        ]),
                  ],
                ),
                SizedBox(width: 0, height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                        width: (width / 2) + 60,
                        height: 50.0,
                        child: _recordButton(context))
                  ],
                ),
              ],
            )));
  }

  Widget _recordButton(BuildContext context) {
    return FlatButton(
      color: Theme.of(context).primaryColor,
      child: Text('REGISTRAR',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold)),
      onPressed: () => _registrarAnciano(context),
    );
  }

  _registrarAnciano(BuildContext context) async {
    if (!_formKey.currentState.validate()) return null;
    _formKey.currentState.save();

    var connectivity = await Connectivity().checkConnectivity();

    if (connectivity == ConnectivityResult.none) {
      await _storeInDatabase(context);
    } else {
      await _storeInNetwork(context);
    }
    //Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('home');
  }

  _storeInDatabase(BuildContext context) async {
    utils.showToast(context, 'Fuera de linea');

    AdultoModel adulto = new AdultoModel(
        nombres: _nombre,
        apellidos: _apellidos,
        sexo: _sexo,
        escolaridad: _escolaridad,
        fechaNacimiento: _fechaNacimiento,
        ingresos: _ingresos,
        rut: _rut,
        fono: _fono,
        m1: 1,
        m2: 0,
        m3: 0,
        m4: 0,
        m1v: '[1,0,0,0,0,0,0]',
        m2v: '[0,0,0,0,0,0]',
        m3v: '[0,0,0,0,0,0]',
        m4v: '[0,0,0,0,0,0]',
        infoAdicional: _info);

    int res;
    String msg;
    if (_isUpdate && _id != 0) {
      adulto.id = _id;
      res = await DBProvider.db.updateAdulto(adulto);
      msg = '${adulto.nombres} ${adulto.apellidos}, actualizado.';
    } else {
      res = await DBProvider.db.insertAdulto(adulto);
      msg = '${adulto.nombres} ${adulto.apellidos}, registrado.';
    }

    if (res <= 0) {
      utils.showToast(context, 'Error al registrar a:  ${adulto.nombres}');
      return null;
    }
    utils.showToast(context, msg);
  }

  _storeInNetwork(BuildContext context) async {
    utils.showToast(context, 'En linea.');

    DateTime tmp = DateFormat('dd-MM-yyyy').parse(_fechaNacimiento);

    Map<String, dynamic> senior = {
      "user_id": utils.user.id,
      "rut": _rut,
      "names": _nombre,
      "last_names": _apellidos,
      "gender": (_sexo == 'F') ? 0 : 1,
      "course": _escolaridad,
      "phone": _fono,
      "email": _email,
      "birthday": DateFormat('yyyy-MM-dd').format(tmp),
      "revenue": _ingresos,
      "info": _fono
    };

    var response =
        await Api().setPostDataFromApi(url: '/seniors', data: senior);

    var body = json.decode(response.body);

    //utils.showToast(_formKey.currentContext, body.toString());
    print("DEBUG:" + body.toString());
  }

  Widget _makeRadioButton(double width, BuildContext context) {
    bool isLandScape =
        (MediaQuery.of(context).orientation == Orientation.landscape);
    return Container(
        width: width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Sexo:',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
              Flex(
                  direction: isLandScape ? Axis.horizontal : Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Radio(
                            activeColor: utils.primary,
                            value: 1,
                            groupValue: _radioValue,
                            onChanged: (value) => setState(() {
                                  _radioValue = value;
                                  _sexo = "M";
                                })),
                        Text('Masculino', style: TextStyle(fontSize: 14.0)),
                      ],
                    ),
                    (isLandScape)
                        ? Container(
                            height: 20.0,
                            width: 2.0,
                            color: Colors.grey,
                            margin: const EdgeInsets.only(left: 9.0, right: 0))
                        : Container(
                            height: 2.0,
                            width: double.infinity,
                            color: Colors.grey,
                            margin: const EdgeInsets.only(left: 9.0, right: 0)),
                    Row(
                      children: <Widget>[
                        Radio(
                            activeColor: utils.primary,
                            value: 0,
                            groupValue: _radioValue,
                            onChanged: (value) => setState(() {
                                  _radioValue = value;
                                  _sexo = "F";
                                })),
                        Text('Femenino', style: TextStyle(fontSize: 14.0))
                      ],
                    ),
                  ])
            ]));
  }

  Widget _makeDropdown(double width) {
    return Container(
        width: width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Grado de escolaridad:',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: DropdownButton(
                    underline: Container(
                        height: 1.0,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.transparent, width: 0.0)))),
                    isExpanded: true,
                    value: _escolaridad,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    items: getOpcionesDropdown(),
                    onChanged: (opt) {
                      setState(() => _escolaridad = opt);
                    }),
              )
            ]));
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = new List();

    _gradoEscolaridad.forEach((opt) {
      lista.add(DropdownMenuItem(
        child: Text('  $opt'),
        value: opt,
      ));
    });

    return lista;
  }

  Widget _makeDate(BuildContext context) {
    return FlatButton(
      onPressed: () {
        DatePicker.showDatePicker(
          context,
          showTitleActions: true,
          minTime: DateTime(1900),
          maxTime: DateTime(2050),
          onConfirm: (DateTime date) {
            setState(() {
              _fechaNacimiento = DateFormat('dd-MM-yyyy').format(date);
            });
          },
          locale: LocaleType.es,
        );
      },
      color: Colors.white,
      child: Text(
        '$_fechaNacimiento',
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}
