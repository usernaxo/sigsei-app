import 'dart:convert';

import 'package:intl/intl.dart';

class Usuario {
  
  int id;
  String nombre1;
  String apellidoPaterno;
  DateTime fechaNacimiento;
  dynamic username;
  String email;
  String telefono;

  Usuario({
    required this.id,
    required this.nombre1,
    required this.apellidoPaterno,
    required this.fechaNacimiento,
    required this.username,
    required this.email,
    required this.telefono,
  });

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
    id: json["id"],
    nombre1: json["nombre1"],
    apellidoPaterno: json["apellido_paterno"],
    fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
    username: json["username"],
    email: json["email"],
    telefono: json["telefono"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nombre1": nombre1,
    "apellido_paterno": apellidoPaterno,
    "fecha_nacimiento": "${fechaNacimiento.year.toString().padLeft(4, '0')}-${fechaNacimiento.month.toString().padLeft(2, '0')}-${fechaNacimiento.day.toString().padLeft(2, '0')}",
    "username": username,
    "email": email,
    "telefono": telefono,
  };

  String? get obtenerNombre {

    return "$nombre1 $apellidoPaterno";

  }

  String? get obtenerFechaNacimiento {

    String fechaFormateada = DateFormat('EEEE d \'de\' MMMM \'de\' yyyy', 'es_ES').format(fechaNacimiento);

    String fechaConMayusculas = fechaFormateada.split(' ').map((palabra) {

      if (palabra.toLowerCase() == 'de') {

        return palabra;

      } else {

        return palabra.substring(0, 1).toUpperCase() + palabra.substring(1);

      }

    }).join(' ');

    return fechaConMayusculas;

  }

  String? get obtenerEmail {

    return email;

  }

  String? get obtenerTelefono {

    return telefono;

  }

}
