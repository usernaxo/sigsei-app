import 'dart:convert';

import 'package:intl/intl.dart';

class Avance {

  int? idInventario;
  int? jornada;
  int? localMall;
  int? localCerrado;
  int? estadoInventario;
  String? codCliente;
  String? codLocal;
  String? fechaInventario;
  String? capturaUno;
  dynamic cantidadFisica;
  dynamic cantidadTeorica;
  int? dotacionEfectiva;
  dynamic porAvance;
  dynamic porAvanceAuditoria;
  dynamic porNivelError;
  String? nombreLider;
  String? nombreArchivoOriginal;
  String? nombreLocal;
  String? ciudad;
  String? fechaHoraInicioProgramada;
  String? horaInicioProgramada;
  String? horaInicioReal;
  String? dotacionDiferencia;
  int? tiempoDesfaceInicio;
  dynamic porAvanceUnidades;
  String? tiempoTranscurridoHoraCapturando;
  String? tiempoFaltanteHoraCaptura;
  dynamic tiempoTranscurrido;
  dynamic tiempoFaltante;
  String? fechaEstimadaCierre;
  String? fechaInicioAuditoria;
  bool? teoricoCargado;
  List<OperadorRendimiento>? operadorRendimiento;

  String get obtenerPorAvance {

    return formatearPorcentaje(porAvance, 2);

  }

  String get obtenerPorAvanceAuditoria {

    return formatearPorcentaje(porAvanceAuditoria, 2);

  }

  String get obtenerPorNivelError {

    return formatearPorcentaje(porNivelError, 2);

  }

  String get obtenerPorAvanceUnidades {

    return formatearPorcentaje(porAvanceUnidades, 2);

  }

  String get obtenerCantidadFisica {

    return formatearCantidad(cantidadFisica);

  }

  String get obtenerCantidadTeorica {

    return formatearCantidad(cantidadTeorica);

  }

  Avance({
    this.idInventario,
    this.jornada,
    this.localMall,
    this.localCerrado,
    this.estadoInventario,
    this.codCliente,
    this.codLocal,
    this.fechaInventario,
    this.capturaUno,
    this.cantidadFisica,
    this.cantidadTeorica,
    this.dotacionEfectiva,
    this.porAvance,
    this.porAvanceAuditoria,
    this.porNivelError,
    this.nombreLider,
    this.nombreArchivoOriginal,
    this.nombreLocal,
    this.ciudad,
    this.fechaHoraInicioProgramada,
    this.horaInicioProgramada,
    this.horaInicioReal,
    this.dotacionDiferencia,
    this.tiempoDesfaceInicio,
    this.porAvanceUnidades,
    this.tiempoTranscurridoHoraCapturando,
    this.tiempoFaltanteHoraCaptura,
    this.tiempoTranscurrido,
    this.tiempoFaltante,
    this.fechaEstimadaCierre,
    this.fechaInicioAuditoria,
    this.teoricoCargado,
    this.operadorRendimiento,
  });

  factory Avance.fromJson(Map<String, dynamic> json) {

    var operadorRendimientoList = json['operador_rendimiento'] as List;

    List<OperadorRendimiento> operadorList = operadorRendimientoList.map((operadorRendimiento) => OperadorRendimiento.fromJson(operadorRendimiento)).toList();

    return Avance(
      idInventario: json['idInventario'],
      jornada: json['jornada'],
      localMall: json['local_mall'],
      localCerrado: json['local_cerrado'],
      estadoInventario: json['estadoInventario'],
      codCliente: json['cod_cliente'],
      codLocal: json['cod_local'],
      fechaInventario: json['fecha_inventario'],
      capturaUno: json['captura_uno'],
      cantidadFisica: json['cantidad_fisica'],
      cantidadTeorica: json['cantidad_teorica'],
      dotacionEfectiva: json['dotacion_efectiva'],
      porAvance: json['por_avance'],
      porAvanceAuditoria: json['por_avance_auditoria'],
      porNivelError: json['por_nivel_error'],
      nombreLider: json['nombre_lider'],
      nombreArchivoOriginal: json['nombre_archivo_original'],
      nombreLocal: json['nombre_local'],
      ciudad: json['ciudad'],
      fechaHoraInicioProgramada: json['fecha_hora_inicio_programada'],
      horaInicioProgramada: json['hora_inicio_programada'],
      horaInicioReal: json['hora_inicio_real'],
      dotacionDiferencia: json['dotacion_diferencia'],
      tiempoDesfaceInicio: json['tiempo_desface_inicio'],
      porAvanceUnidades: json['por_avance_unidades'],
      tiempoTranscurridoHoraCapturando: json['tiempo_transcurrido_hora_capturando'],
      tiempoFaltanteHoraCaptura: json['tiempo_faltante_hora_captura'],
      tiempoTranscurrido: json['tiempo_transcurrido'],
      tiempoFaltante: json['tiempo_faltante'],
      fechaEstimadaCierre: json['fecha_estimada_cierre'],
      fechaInicioAuditoria: json['fecha_inicio_auditoria'],
      teoricoCargado: json['teorico_cargado'],
      operadorRendimiento: operadorList,
    );

  }

  String formatearPorcentaje(dynamic porcentaje, int cantidadDecimal) {

    if (porcentaje is String || porcentaje is int || porcentaje is double) {

      return "${double.parse(porcentaje.toString().replaceAll("%", "")).toStringAsFixed(cantidadDecimal)} %";
      
    }

    return "";

  }

  String formatearCantidad(dynamic cantidad) {

    if (cantidad is String) {

      cantidad = cantidad.replaceAll(",", ".").split(".")[0];

    }

    if (cantidad is int || cantidad is String) {

      return NumberFormat("#,###", "es_ES").format(int.parse(cantidad.toString()));

    }

    return "";

  }

  bool estaCompletado() {

    if (porAvance is String || porAvance is int || porAvance is double) {

      if (double.parse(porAvance.toString()) >= 95) {

        return true;

      }
      
    }

    return false;

  }

}

class OperadorRendimiento {

  String? nombre;
  int? cantidad;
  double? error;

  OperadorRendimiento({
    this.nombre,
    this.cantidad,
    this.error,
  });

  factory OperadorRendimiento.fromJson(Map<String, dynamic> json) {

    return OperadorRendimiento(
      nombre: json['nombre'],
      cantidad: json['cantidad'],
      error: json['error'].toDouble(),
    );
    
  }

  String toJson() => json.encode(toMap());

  factory OperadorRendimiento.fromMap(Map<String, dynamic> json) => OperadorRendimiento(
    nombre: json["nombre"],
    cantidad: json["cantidad"],
    error: json["error"]?.toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "nombre": nombre,
    "cantidad": cantidad,
    "error": error,
  };

}
