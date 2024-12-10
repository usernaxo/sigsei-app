import 'package:flutter/material.dart';

class Agenda {

  String fecha;
  String hora;
  String descripcion;
  Color color;

  Agenda({
    required this.fecha,
    required this.hora,
    required this.descripcion,
    required this.color
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {

    return Agenda(
      fecha: json["fecha"],
      hora: json["hora"],
      descripcion: json["descripcion"],
      color: Color(json["color"]),
    );

  }

  Map<String, dynamic> toJson() => {

    "fecha": fecha,
    "hora": hora,
    "descripcion": descripcion,
    "color": color.value

  };

}
