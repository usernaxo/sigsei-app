import 'dart:convert';

import 'package:intl/intl.dart';

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

  String? get obtenerTitular {

    return titular;

  }

  String? get obtenerError {

    return formatearPorcentaje(error, 2);

  }

  String? get obtenerCantidadError {

    return cantError;

  }

  String? get obtenerConteo {

    return formatearCantidad(conteo);

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
