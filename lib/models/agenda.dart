import 'package:flutter/material.dart';

class Agenda {

  String id;
  String fecha;
  String hora;
  String descripcion;
  Color color;

  Agenda({
    required this.id,
    required this.fecha,
    required this.hora,
    required this.descripcion,
    required this.color
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {

    return Agenda(
      id: json["id"],
      fecha: json["fecha"],
      hora: json["hora"],
      descripcion: json["descripcion"],
      color: Color(json["color"]),
    );

  }

  Map<String, dynamic> toJson() => {

    "id": id,
    "fecha": fecha,
    "hora": hora,
    "descripcion": descripcion,
    "color": color.value

  };

}
