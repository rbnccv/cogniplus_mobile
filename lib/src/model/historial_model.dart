class HistorialModel {
  int id;
  int idVideo;
  int idModulo;
  int idAdulto;
  String titulo;
  String fecha;
  String resp1;
  String resp2;
  String evaluacion;
  int enviado;

  int visualizaciones;

  HistorialModel(
      {this.id,
      this.idVideo,
      this.idModulo,
      this.idAdulto,
      this.titulo,
      this.fecha,
      this.resp1,
      this.resp2,
      this.evaluacion,
      this.visualizaciones,
      this.enviado});

  factory HistorialModel.fromJson(Map<String, dynamic> json) => HistorialModel(
      id: json['id'],
      idVideo: json['id_video'],
      idModulo: json['id_modulo'],
      idAdulto: json['id_adulto'],
      titulo: json['titulo'],
      fecha: json['fecha'],
      resp1: json['resp1'],
      resp2: json['resp2'],
      evaluacion: json['evaluacion'],
      visualizaciones: json['visualizaciones'],
      enviado: json['enviado']);

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "id_video": this.idVideo,
        "id_modulo": this.idModulo,
        "id_adulto": this.idAdulto,
        "titulo": this.titulo,
        "fecha": this.fecha,
        "resp1": this.resp1,
        "resp2": this.resp2,
        "evaluacion": this.evaluacion,
        "visualizaciones": this.visualizaciones,
        "enviado": this.enviado
      };
}
