import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sigsei/models/avance.dart';
import 'package:sigsei/models/indicador.dart';
import 'package:sigsei/models/indicadores_respuesta.dart';
import 'package:sigsei/models/token.dart';
import 'package:http/http.dart' as http;

class ProveedorEstado extends ChangeNotifier {

  String servidor = "sig.seiconsultores.cl";

  String iniciarSesionEndpoint = "/v2/login";
  String cerrarSesionEndpoint = "/v2/logout";
  String datosUsuarioEndpoint = "/v2/me";
  String usuarioEndpoint = "/v2/user";
  String indicadoresEndpoint = "/v2/indicadores-inventarios";
  String avancesEndpoint = "/v2/avance-inventarios";

  bool cargando = false;

  Token? tokenUsuario;
  IndicadoresResponse? indicadores;
  List<Indicador>? listaIndicadores = [];

  List<String> ordenIndicadores = [
    "PUC",
    "FCV",
    "CID",
    "FSB",
    "SMU",
    "MAI",
    "SCF",
    "LIQ",
    "DBS",
    "TM",
    "ISA",
    "FPK",
    "FAH",
  ];

  ProveedorEstado();

  bool get estaCargando => cargando;

  Future<Map<String, dynamic>> iniciarSesion(String email, String clave) async {

    cargando = true;

    notifyListeners();

    try {

      Uri peticionValidarUsuario = Uri.https(servidor, iniciarSesionEndpoint, {

        "email": email,
        "password": clave

      });

      final respuestaValidarUsuario = await http.post(peticionValidarUsuario);

      if (respuestaValidarUsuario.statusCode == 200) {

        tokenUsuario = Token.fromJson(respuestaValidarUsuario.body);

        const almacenamiento = FlutterSecureStorage();

        await almacenamiento.write(key: "tokenUsuario", value: tokenUsuario?.accessToken);
        await almacenamiento.write(key: "usuario", value: tokenUsuario?.user.toJson());

        return {

          "success": true,

        };
        
      } else {

        Map<String, dynamic> error = json.decode(respuestaValidarUsuario.body);

        return {

          "success": false,
          "message": error["message"] ?? "Error Desconocido"

        };

      }

    } catch (excepcion) {

      return {

        "success": false,
        "message": "Error de Conexión"

      };

    } finally {

      cargando = false;

      notifyListeners();

    }

  }

  Future<int> cerrarSesion() async {

    cargando = true;

    notifyListeners();

    const almacenamiento = FlutterSecureStorage();

    final tokenUsuario = await almacenamiento.read(key: "tokenUsuario");

    try {

      Uri peticionCerrarSesion = Uri.https(servidor, cerrarSesionEndpoint);

      final respuestaCerrarSesion = await http.post(
        peticionCerrarSesion,
        headers: {
          "Authorization": "Bearer $tokenUsuario"
        }
      );

      return respuestaCerrarSesion.statusCode;

    } catch (excepcion) {

      return 0;

    } finally {

      cargando = false;

      notifyListeners();

    }

  }

  Future<List<Indicador>?> obtenerIndicadores(String fechaInicio, String fechaFin) async {

    const almacenamiento = FlutterSecureStorage();
    
    final tokenUsuario = await almacenamiento.read(key: "tokenUsuario");

    try {

      Uri peticionObtenerIndicadores = Uri.https(servidor, indicadoresEndpoint, {

        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFin

      });

      final respuestaObtenerIndicadores = await http.get(
        peticionObtenerIndicadores,
        headers: {
          "Authorization": "Bearer $tokenUsuario"
        }
      );

      if (respuestaObtenerIndicadores.statusCode == 200) {

        final indicadores = IndicadoresResponse.fromJson(respuestaObtenerIndicadores.body);

        listaIndicadores = indicadores.listaIndicadores;

        Uri peticionObtenerAvances = Uri.https(servidor, avancesEndpoint, {
          "fecha_inicio": fechaInicio,
          "fecha_fin": fechaFin
        });

        final respuestaObtenerAvances = await http.get(
          peticionObtenerAvances,
          headers: {
            "Authorization": "Bearer $tokenUsuario"
          }
        );

        if (respuestaObtenerAvances.statusCode == 200) {

          List<dynamic> avances = json.decode(respuestaObtenerAvances.body);

          List<Avance> listaAvances = avances.map((json) => Avance.fromJson(json)).toList();

          for (var indicador in listaIndicadores!) {

            final avance = listaAvances.firstWhere(
              (avance) => avance.idInventario == indicador.inv,
              orElse: () => Avance(idInventario: indicador.inv),
            );

            indicador.avance = avance;

          }

        }

        listaIndicadores?.sort((indicadorA, indicadorB) {

          int indiceA = ordenIndicadores.indexOf(indicadorA.clientName ?? "");
          int indiceB = ordenIndicadores.indexOf(indicadorB.clientName ?? "");

          indiceA = indiceA == -1 ? ordenIndicadores.length : indiceA;
          indiceB = indiceB == -1 ? ordenIndicadores.length : indiceB;

          return indiceA.compareTo(indiceB);

        });

        return listaIndicadores;
          
      } else {

        return [];

      }

    } catch (excepcion) {

      return [];

    } finally {

      cargando = false;

      notifyListeners();

    }

  }

}
