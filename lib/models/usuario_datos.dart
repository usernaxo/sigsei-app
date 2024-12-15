import 'package:intl/intl.dart';

class UsuarioDatos {

  String? run;
  String? dv;
  String? nombre1;
  String? nombre2;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? fechaNacimiento;
  String? sexo;
  String? nacionalidad;
  String? telefono;
  String? telefonoEmergencia;
  String? email;
  String? emailPersonal;
  int? region;
  int? comuna;
  String? direccion;
  int? banco;
  int? tipoCuenta;
  String? numeroCuenta;

  UsuarioDatos({
    this.run,
    this.dv,
    this.nombre1,
    this.nombre2,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.fechaNacimiento,
    this.sexo,
    this.nacionalidad,
    this.telefono,
    this.telefonoEmergencia,
    this.email,
    this.emailPersonal,
    this.region,
    this.comuna,
    this.direccion,
    this.banco,
    this.tipoCuenta,
    this.numeroCuenta,
  });

  String? get obtenerNombres {

    return "$nombre1 $nombre2";

  }

  String? get obtenerApellidos {

    return "$apellidoPaterno $apellidoMaterno";

  }

  String? get obtenerFechaNacimiento {

    String formatoFechaNacimiento = DateFormat('EEEE d \'de\' MMMM \'de\' yyyy', 'es_ES').format(DateTime.parse(fechaNacimiento!));

    String fechaConMayusculas = formatoFechaNacimiento.split(' ').map((palabra) {

      if (palabra.toLowerCase() == 'de') {

        return palabra;

      } else {

        return palabra.substring(0, 1).toUpperCase() + palabra.substring(1);

      }

    }).join(' ');

    return fechaConMayusculas;

  }

  String? get obtenerGenero {

    return sexo;

  }

  String? get obtenerNacionalidad {

    return nacionalidad;

  }

  String? get obtenerTelefonoContacto {

    return telefono;

  }

  String? get obtenerTelefonoEmergencia {

    return telefonoEmergencia;

  }

  String? get obtenerEmail {

    return email;

  }

  String? get obtenerEmailPersonal {

    return emailPersonal;

  }

  String? get obtenerDireccion {

    return direccion;

  }

  String? get obtenerNumeroCuenta {

    return numeroCuenta;

  }

  factory UsuarioDatos.fromJson(Map<String, dynamic> json) {

    return UsuarioDatos(
      run: json["run"].toString().isEmpty ? "-" : json["run"] ?? "-",
      dv: json["dv"].toString().isEmpty ? "-" : json["dv"] ?? "-",
      nombre1: json["nombre1"].toString().isEmpty ? "-" : json["nombre1"] ?? "-",
      nombre2: json["nombre2"].toString().isEmpty ? "-" : json["nombre2"] ?? "-",
      apellidoPaterno: json["apellidoPaterno"].toString().isEmpty ? "-" : json["apellidoPaterno"] ?? "-",
      apellidoMaterno: json["apellidoMaterno"].toString().isEmpty ? "-" : json["apellidoMaterno"] ?? "-",
      fechaNacimiento: json["fechaNacimiento"].toString().isEmpty ? "-" : json["fechaNacimiento"] ?? "-",
      sexo: json["sexo"].toString().isEmpty ? "-" : json["sexo"] ?? "-",
      nacionalidad: json["nacionalidad"].toString().isEmpty ? "-" : json["nacionalidad"] ?? "-",
      telefono: json["telefono"].toString().isEmpty ? "-" : json["telefono"] ?? "-",
      telefonoEmergencia: json["telefonoEmergencia"].toString().isEmpty ? "-" : json["telefonoEmergencia"] ?? "-",
      email: json["email"].toString().isEmpty ? "-" : json["email"] ?? "-",
      emailPersonal: json["emailPersonal"].toString().isEmpty ? "-" : json["emailPersonal"] ?? "-",
      region: json["region"] ?? 0,
      comuna: json["comuna"] ?? 0,
      direccion: json["direccion"].toString().isEmpty ? "-" : json["direccion"] ?? "-",
      banco: json["banco"] ?? 0,
      tipoCuenta: json["tipoCuenta"] ?? 0,
      numeroCuenta: json["numeroCuenta"].toString().isEmpty ? "-" : json["numeroCuenta"]  ?? "-",
    );

  }

}
