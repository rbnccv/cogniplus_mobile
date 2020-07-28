class UserModel {
  int     id;
  String  rut;
  String  nombres;
  String  pass;

  UserModel( {this.id, this.rut, this.nombres, this.pass} );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(
        id        : json['id'], 
        rut       : json['rut'], 
        nombres   : json['nombres'],
        pass      : json['pass']
      );

  Map<String, dynamic> toJson() => {
    "id"        : this.id,
    "rut"       : this.rut,
    "nombres"   : this.nombres,
    "pass"      : this.pass
  };

}
