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
  dynamic porAvanceBodega;
  dynamic porAvanceSala;
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
  List<TopDiferencia>? topDiferencias;
  String? fechahoraSincroniza;
  bool? online;

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
    this.porAvanceBodega,
    this.porAvanceSala,
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
    this.topDiferencias,
    this.fechahoraSincroniza,
    this.online
  });

  factory Avance.fromJson(Map<String, dynamic> json) {

    var operadorRendimientoLista = json['operador_rendimiento'] == null ? [] : json['operador_rendimiento'] as List;

    List<OperadorRendimiento> listaOperadorRendimiento = operadorRendimientoLista.map((operadorRendimiento) => OperadorRendimiento.fromJson(operadorRendimiento)).toList();

    var topDiferenciasLista = json['top_diferencias'] == null ? [] : json['top_diferencias'] as List;

    List<TopDiferencia> listaTopDiferencias = topDiferenciasLista.map((topDiferencia) => TopDiferencia.fromJson(topDiferencia)).toList();

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
      porAvanceBodega: json["por_avance_bodega"],
      porAvanceSala: json["por_avance_sala"],
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
      operadorRendimiento: listaOperadorRendimiento,
      topDiferencias : listaTopDiferencias,
      fechahoraSincroniza: json["fechahora_sincroniza"],
      online: json["online"]
    );

  }

  String get obtenerTiempoFaltante {

    return tiempoFaltanteHoraCaptura!;

  }

  String get obtenerPorAvance {

    return formatearPorcentaje(porAvance, 2);

  }

  String get obtenerPorAvanceAuditoria {

    return formatearPorcentaje(porAvanceAuditoria, 2);

  }

  String get obtenerPorNivelError {

    return formatearPorcentaje(porNivelError, 2);

  }

  String get obtenerPorAvanceBodega {

    return formatearPorcentaje(porAvanceBodega, 2);

  }

  String get obtenerPorAvanceSala {

    return formatearPorcentaje(porAvanceSala, 2);

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

  String? get obtenerNombreCliente {

    return codCliente;

  }

  String? get obtenerCodigoCeco {

    return codLocal;

  }

  String? get obtenerNombreLocal {

    return nombreLocal!.length > 14 ? nombreLocal!.substring(0, 14) : nombreLocal;

  }

  String? get obtenerHoraInicio {

    return horaInicioProgramada;

  }

  String? get obtenerHoraInicioReal {

    return horaInicioReal!.isEmpty ? "-" : horaInicioReal;

  }

  String? get obtenerDotacion {

    return "${dotacionDiferencia!.split("-")[1]} de ${dotacionDiferencia!.split("-")[0]}";

  }

  String? get obtenerHoraEstimadaCierre {

    return fechaEstimadaCierre;

  }

  bool? get estaEnLinea {

    return online;

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

}

class TopDiferencia {

  String? interno;
  String? deescripcion;
  String? fisico;
  String? teorico;
  String? dif;
  String? valorFisico;
  String? valorTeorico;
  String? valorDif;
  String? barra;

  TopDiferencia({
    this.interno,
    this.deescripcion,
    this.fisico,
    this.teorico,
    this.dif,
    this.valorFisico,
    this.valorTeorico,
    this.valorDif,
    this.barra,
  });

  factory TopDiferencia.fromJson(Map<String, dynamic> json) {

    return TopDiferencia(
      interno: json["interno"],
      deescripcion: json["deescripcion"],
      fisico: json["fisico"],
      teorico: json["teorico"],
      dif: json["dif"],
      valorFisico: json["valor_fisico"],
      valorTeorico: json["valor_teorico"],
      valorDif: json["valor_dif"],
      barra: json["barra"]
    );

  }

}
