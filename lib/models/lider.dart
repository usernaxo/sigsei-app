import 'dart:convert';

class Lider {
  
  String? titular;
  dynamic error;
  String? cantError;
  dynamic conteo;

  Lider({
    this.titular,
    this.error,
    this.cantError,
    this.conteo,
  });

  factory Lider.fromJson(String str) => Lider.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Lider.fromMap(Map<String, dynamic> json) => Lider(
    titular: json["Titular"],
    error: json["Error"],
    cantError: json["CantError"],
    conteo: json["Conteo"],
  );

  Map<String, dynamic> toMap() => {
    "Titular": titular,
    "Error": error,
    "CantError": cantError,
    "Conteo": conteo,
  };

}
