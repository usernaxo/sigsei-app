import 'dart:convert';

class Titular {

  String? titular;
  String? comuna;
  double? error;
  String? cantError;
  int? conteo;
  int? exp;

  Titular({
    this.titular,
    this.comuna,
    this.error,
    this.cantError,
    this.conteo,
    this.exp,
  });

  factory Titular.fromJson(String str) => Titular.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Titular.fromMap(Map<String, dynamic> json) => Titular(
    titular: json["Titular"],
    comuna: json["Comuna"],
    error: json["Error"]?.toDouble(),
    cantError: json["CantError"],
    conteo: json["Conteo"],
    exp: json["EXP"],
  );

  Map<String, dynamic> toMap() => {
    "Titular": titular,
    "Comuna": comuna,
    "Error": error,
    "CantError": cantError,
    "Conteo": conteo,
    "EXP": exp,
  };

}
