import 'dart:convert';

import 'package:cogniplus_mobile/src/model/adulto_model.dart';
import 'package:cogniplus_mobile/src/pages/seniors_list_page.dart';
import 'package:cogniplus_mobile/src/providers/api.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:cogniplus_mobile/src/utils/utils.dart' as utils;

enum TipoSexo { masculino, femenino }

class RegisterSeniorPage extends StatefulWidget {
  final AdultoModel adulto;

  RegisterSeniorPage({this.adulto});

  @override
  _RegisterSeniorPageState createState() => _RegisterSeniorPageState();
}

class _RegisterSeniorPageState extends State<RegisterSeniorPage> {
  final _formKey = GlobalKey<FormState>();

  int _id = 0;
  AdultoModel _adulto;
  int _radioValue = 1;
  bool _isUpdate = false;

  List<String> _gradoEscolaridad = [
    'Enseñanza básica incompleta',
    'Enseñanza básica completa',
    'Enseñanza media incompleta',
    'Enseñanza media completa',
    'Enseñanza superior incompleta',
    'Enseñanza superior completa'
  ];

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

  @override
  void initState() {
    super.initState();

    if (widget.adulto != null) {
      _setFormFields(widget.adulto);
    } else {
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
  Scaffold build(BuildContext context) {
    setState(() {
      if (_adulto != null) _setFormFields(_adulto);
    });
    return Scaffold(
      backgroundColor: Color(0xffE6E6E6),
      appBar: _appbar(context),
      body: SafeArea(
        child: SingleChildScrollView(child: _getForm(context)),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.question, color: Colors.white),
              onPressed: () {
                utils.showIntroVideo(context);
              }),
          Text(
            'Añadir perfil',
            style: utils.estTitulo,
          ),
          IconButton(
              icon: Icon(FontAwesomeIcons.powerOff, color: Colors.white),
              onPressed: () {
                utils.logoff(context);
              }),
        ],
      ),
    );
  }

  Container _getForm(BuildContext context) {
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
                                    FilteringTextInputFormatter.digitsOnly
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

  FlatButton _recordButton(BuildContext context) {
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

  Container _makeRadioButton(double width, BuildContext context) {
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

  Container _makeDropdown(double width) {
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

  FlatButton _makeDate(BuildContext context) {
    return FlatButton(
      onPressed: () {
        DatePicker.showDatePicker(
          context,
          showTitleActions: true,
          minTime: DateTime(1900),
          maxTime: DateTime(2050),
          onConfirm: (DateTime date) {
            setState(() {
              _fechaNacimiento = DateFormat('yyyy-MM-dd').format(date);
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

  _setFormFields(AdultoModel adulto) {
    bool isInGrade = _gradoEscolaridad
        .toString()
        .toLowerCase()
        .contains(adulto.escolaridad.toLowerCase());

    if (adulto.escolaridad.trim() != "" && !isInGrade)
      _gradoEscolaridad.add(adulto.escolaridad);

    _escolaridad = adulto.escolaridad;

    // _escolaridad =
    //     isInGrade ? adulto.escolaridad : "Enseñanza básica incompleta";

    _id = adulto.id;
    _nombreTextController.text = adulto.nombres;
    _apellidoTextController.text = adulto.apellidos;
    _fechaNacimiento = adulto.fechaNacimiento;
    _ingresosTextController.text = adulto.ingresos;
    _rutTextController.text = adulto.rut;
    _fonoTextController.text = adulto.fono;
    _infoTextController.text = adulto.infoAdicional;
    _isUpdate = true;

    setState(() {
      _radioValue = (adulto.sexo == '0') ? 0 : 1;
      _sexo = adulto.sexo;
    });
  }

  _registrarAnciano(BuildContext context) async {
    if (!_formKey.currentState.validate()) return null;
    _formKey.currentState.save();

    var connectivity = await Connectivity().checkConnectivity();

    if (connectivity != ConnectivityResult.none) {
      await _storeInNetwork(context);
    }
    //Navigator.of(context).pop();

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SeniorListPage()));
    //Navigator.of(context).pushReplacementNamed('home');
  }

  _storeInNetwork(BuildContext context) async {
    utils.showToast(context, 'En linea.');

    DateTime tmp = DateFormat('yyyy-MM-dd').parse(_fechaNacimiento);

    Map<String, dynamic> senior = {
      "user_id": utils.user.id,
      "rut": _rut,
      "names": _nombre,
      "last_names": _apellidos,
      "gender": (_sexo == '0') ? 0 : 1,
      "course": _escolaridad,
      "phone": _fono,
      "email": _email,
      "birthday": DateFormat('yyyy-MM-dd').format(tmp),
      "revenue": _ingresos,
      "info": _info
    };

    String msg;
    var body;

    try {
      if (_isUpdate && _id != 0) {
        //update
        var response = await Api().setUpdateDataFromApi(
            url: '/seniors/' + _id.toString(), data: senior);
        body = json.decode(response.body);
        msg = '${body["names"]}, actualizado.';
      } else {
        //insert
        var response =
            await Api().setPostDataFromApi(url: '/seniors', data: senior);
        body = json.decode(response.body);
        msg = '${body["names"]}, agregado.';
      }
    } catch (e) {
      utils.showToast(context, e.toString());
    }
    utils.showToast(context, msg);
    //utils.showToast(_formKey.currentContext, body.toString());
  }
}
