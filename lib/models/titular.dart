import 'dart:convert';

import 'package:intl/intl.dart';

class Titular {

  String? titular;
  String? comuna;
  dynamic error;
  dynamic cantError;
  dynamic conteo;
  dynamic exp;

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
    error: json["Error"],
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

  String? get obtenerTitular {

    return titular;

  }

  String? get obtenerComuna {

    return comuna;

  }

  String? get obtenerError {

    return formatearPorcentaje(error, 2);

  }

  String? get obtenerCantError {

    return formatearCantidad(cantError);

  }

  String? get obtenerConteo {

    return formatearCantidad(conteo);

  }

  String? get obtenerExp {

    return formatearCantidad(exp);

  }

  String formatearPorcentaje(dynamic porcentaje, int cantidadDecimal) {

    if (porcentaje is String || porcentaje is int || porcentaje is double) {

      try {

        return "${double.parse(porcentaje.toString().replaceAll("%", "")).toStringAsFixed(cantidadDecimal)} %";

      } catch (excepcion) {

        return porcentaje.toString();

      }

    }

    return "";

  }

  String formatearCantidad(dynamic cantidad) {

    if (cantidad is String) {

      cantidad = cantidad.replaceAll(",", ".").split(".")[0];

    }

    if (cantidad is int || cantidad is String) {

      try {

        return NumberFormat("#,###", "es_ES").format(int.parse(cantidad.toString()));

      } catch (excepcion) {

        return cantidad.toString();

      }

    }

    return "";

  }

}
