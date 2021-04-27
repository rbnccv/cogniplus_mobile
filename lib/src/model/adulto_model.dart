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
  String correo;
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
      this.correo,
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
      correo: jsonData["email"],
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
      correo: json["email"],
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
        "correo": this.correo,
        "infoAdicional": this.infoAdicional
      };
}
