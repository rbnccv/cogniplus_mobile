import 'dart:convert';

class AdultoModel {
  int id;
  String rut;
  String nombres;
  String apellidos;
  String sexo;
  String escolaridad;
  String fechaNacimiento;
  String ingresos;
  String fono;
  int m1;
  int m2;
  int m3;
  int m4;
  String m1v;
  String m2v;
  String m3v;
  String m4v;
  String infoAdicional;

  AdultoModel(
      {this.id,
      this.rut,
      this.nombres,
      this.apellidos,
      this.sexo,
      this.escolaridad,
      this.fechaNacimiento,
      this.ingresos,
      this.fono,
      this.m1,
      this.m2,
      this.m3,
      this.m4,
      this.m1v,
      this.m2v,
      this.m3v,
      this.m4v,
      this.infoAdicional});

  static AdultoModel toAdultoModelFromNetwork({String string}) {
    final jsonData = json.decode(string);

    return AdultoModel(
      id: jsonData["id"],
      rut: jsonData["rut"],
      nombres: jsonData["names"],
      apellidos: jsonData["last_names"],
      sexo: jsonData["gender"].toString(),
      escolaridad: jsonData["course"],
      fechaNacimiento: jsonData["birthday"],
      ingresos: jsonData["revenue"].toString(),
      fono: jsonData["phone"],
      infoAdicional: jsonData["info"],
    );
  }

  factory AdultoModel.fromJson(Map<String, dynamic> json) => AdultoModel(
      id: json['id'],
      rut: json['rut'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      sexo: json['sexo'],
      escolaridad: json['escolaridad'],
      fechaNacimiento: json['fechaNacimiento'],
      ingresos: json['ingresos'],
      fono: json['fono'],
      m1: json['m1'],
      m2: json['m2'],
      m3: json['m3'],
      m4: json['m4'],
      m1v: json['m1v'],
      m2v: json['m2v'],
      m3v: json['m3v'],
      m4v: json['m4v'],
      infoAdicional: json['infoAdicional']);

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "rut": this.rut,
        "nombres": this.nombres,
        "apellidos": this.apellidos,
        "sexo": this.sexo,
        "escolaridad": this.escolaridad,
        "fechaNacimiento": this.fechaNacimiento,
        "ingresos": this.ingresos,
        "fono": this.fono,
        "m1": this.m1,
        "m2": this.m2,
        "m3": this.m3,
        "m4": this.m4,
        "m1v": this.m1v,
        "m2v": this.m2v,
        "m3v": this.m3v,
        "m4v": this.m4v,
        "infoAdicional": this.infoAdicional
      };
}
