import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:sigsei/models/auditoria_bodega.dart';
import 'package:sigsei/models/auditoria_smu.dart';
import 'package:sigsei/models/avance.dart';
import 'package:sigsei/models/indicador.dart';
import 'package:sigsei/models/indicadores_respuesta.dart';
import 'package:sigsei/models/inventario_general.dart';
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
  String auditoriasSmu = "/v2/auditoriasSMU/programacion";
  String inventarioGeneralSemanal = "/v2/inventarios/programacion-semanal";

  bool cargando = false;

  Token? tokenUsuario;
  IndicadoresRespuesta? indicadores;
  List<Indicador>? listaIndicadores = [];
  List<AuditoriaSmu> listaAuditoriasSmu = [];
  List<AuditoriaBodega> listaAuditoriasBodega = [];
  List<InventarioGeneral> listaInventarioGeneral = [];

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

        final indicadores = IndicadoresRespuesta.fromJson(respuestaObtenerIndicadores.body);

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

  Future<String> descargarArchivoConProgreso(int idArchivo, String endpoint, Function(double) onProgreso) async {

    const almacenamiento = FlutterSecureStorage();
    final tokenUsuario = await almacenamiento.read(key: "tokenUsuario");

    try {

      Uri peticionDescargarArchivo = Uri.https(servidor, "/v2/inventario/archivo-final/$idArchivo/$endpoint");

      final peticionDescargarArchivoCliente = http.Request("GET", peticionDescargarArchivo);

      peticionDescargarArchivoCliente.headers["Authorization"] = "Bearer $tokenUsuario";

      final respuestaDescargarArchivo = await http.Client().send(peticionDescargarArchivoCliente);

      if (respuestaDescargarArchivo.statusCode == 200) {

        final tamanoContenido = respuestaDescargarArchivo.contentLength;
        final nombreArchivo = obtenerNombreArchivo(respuestaDescargarArchivo.headers["content-disposition"]);
        final rutaDescargas = Directory("/storage/emulated/0/Download");

        if (!rutaDescargas.existsSync()) {

          await rutaDescargas.create(recursive: true);

        }

        final rutaArchivo = "${rutaDescargas.path}/$nombreArchivo";
        final archivo = File(rutaArchivo);
        final sink = archivo.openWrite();

        int bytesLeidos = 0;
        
        await for (var chunk in respuestaDescargarArchivo.stream) {

          bytesLeidos += chunk.length;
          sink.add(chunk);

          if (tamanoContenido != null) {

            double progreso = (bytesLeidos / tamanoContenido) * 100;
            
            onProgreso(progreso);

          }

        }

        await sink.flush();
        await sink.close();

        final resultadoAbrirArchivo = await OpenFile.open(rutaArchivo);

        if (resultadoAbrirArchivo.type == ResultType.error) {

          return "Error en abrir archivo";

        }

        return "Archivo Descargado: $nombreArchivo";

      } else {

        return "Error al descargar el archivo: ${respuestaDescargarArchivo.statusCode}";

      }

    } catch (e) {

      return "Error en descargar";

    }

  }

  String? obtenerNombreArchivo(String? contentDisposition) {

    if (contentDisposition == null) return null;

    final regex = RegExp(r'filename="(.+)"');
    final match = regex.firstMatch(contentDisposition);
    
    return match?.group(1);

  }

  Future<List<AuditoriaSmu>?> obtenerAuditoriasSmu(String fechaInicio, String fechaFin) async {

    const almacenamiento = FlutterSecureStorage();
    
    final tokenUsuario = await almacenamiento.read(key: "tokenUsuario");

    try {

      Uri peticionObtenerAuditoriasSmu = Uri.https(servidor, auditoriasSmu, {

        "fechaInicio": fechaInicio,
        "fechaFin": fechaFin,
        "smuBodega": "0"

      });

      final respuestaObtenerAuditoriasSmu = await http.get(
        peticionObtenerAuditoriasSmu,
        headers: {
          "Authorization": "Bearer $tokenUsuario"
        }
      );

      if (respuestaObtenerAuditoriasSmu.statusCode == 200) {

        List<dynamic> auditoriasSmu = json.decode(respuestaObtenerAuditoriasSmu.body);

        listaAuditoriasSmu = auditoriasSmu.map((json) => AuditoriaSmu.fromJson(json)).toList();

        return listaAuditoriasSmu;
          
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

  Future<List<AuditoriaBodega>?> obtenerAuditoriasBodega(String fechaInicio, String fechaFin) async {

    const almacenamiento = FlutterSecureStorage();
    
    final tokenUsuario = await almacenamiento.read(key: "tokenUsuario");

    try {

      Uri peticionObtenerAuditoriasBodega = Uri.https(servidor, auditoriasSmu, {

        "fechaInicio": fechaInicio,
        "fechaFin": fechaFin,
        "smuBodega": "1"

      });

      final respuestaObtenerAuditoriasBodega = await http.get(
        peticionObtenerAuditoriasBodega,
        headers: {
          "Authorization": "Bearer $tokenUsuario"
        }
      );

      if (respuestaObtenerAuditoriasBodega.statusCode == 200) {

        List<dynamic> auditoriasBodega = json.decode(respuestaObtenerAuditoriasBodega.body);

        listaAuditoriasBodega = auditoriasBodega.map((json) => AuditoriaBodega.fromJson(json)).toList();

        return listaAuditoriasBodega;
          
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

  Future<List<InventarioGeneral>?> obtenerInventarioGeneral(String fechaInicio, String fechaFin) async {

    const almacenamiento = FlutterSecureStorage();
    
    final tokenUsuario = await almacenamiento.read(key: "tokenUsuario");

    try {

      Uri peticionObtenerInventarioGeneralSemanal = Uri.https(servidor, inventarioGeneralSemanal, {

        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFin,
        "cliente_id": "0"

      });

      final respuestaObtenerInventarioGeneralSemanal = await http.get(
        peticionObtenerInventarioGeneralSemanal,
        headers: {
          "Authorization": "Bearer $tokenUsuario"
        }
      );

      if (respuestaObtenerInventarioGeneralSemanal.statusCode == 200) {

        print(respuestaObtenerInventarioGeneralSemanal.body);

        List<dynamic> inventarioGeneral = json.decode(respuestaObtenerInventarioGeneralSemanal.body);

        listaInventarioGeneral = inventarioGeneral.map((json) => InventarioGeneral.fromJson(json)).toList();

        return listaInventarioGeneral;
          
      } else {

        return [];

      }

    } catch (excepcion, stack) {

      print(stack);

      return [];

    } finally {

      cargando = false;

      notifyListeners();

    }

  }

}
