import 'package:intl/intl.dart';
import 'package:sigsei/models/avance.dart';

class Indicador {

  String? clientName;
  String? storeNumber;
  String? storeName;
  String? storeCommune;
  String? leader;
  Indicator? indicator;
  int? inv;
  dynamic invReport;
  int? stockTeorico;
  bool? esDia;
  int? dotacion;
  bool? deterioro;
  String? horario;
  String? fecha;
  List<Log>? logs;
  Avance? avance;

  Indicador({
    this.clientName,
    this.storeNumber,
    this.storeName,
    this.storeCommune,
    this.leader,
    this.indicator,
    this.inv,
    this.invReport,
    this.stockTeorico,
    this.esDia,
    this.dotacion,
    this.deterioro,
    this.horario,
    this.fecha,
    this.logs,
    this.avance
  });

  String? get obtenerNombreCliente {

    return clientName;

  }

  String? get obtenerCE {

    return storeNumber;

  }

  String? get obtenerNombreLocal {

    return storeName!;

  }

  String? get obtenerNombreLocalCorto {

    return storeName!.length > 14 ? storeName!.substring(0, 14) : storeName!;

  }

  String? get obtenerStockTeorico {

    return formatearCantidad(stockTeorico);

  }

  String? get obtenerVarianza {

    if (indicator != null) {

      return formatearPorcentaje(indicator!.variance, 1);

    }

    return "-";

  }

  String? get obtenerSeiError {

    if (indicator != null) {

      return formatearPorcentaje(indicator!.seiError, 1);

    }

    return "-";

  }

  String? get obtenerSeiStandard {

    if (indicator != null) {

      return formatearPorcentaje(indicator!.seiStandard, 1);

    }

    return "-";

  }

  String? get obtenerAvgScores {

    if (indicator != null) {

      return indicator!.avgScores;

    }

    return "-";

  }

  String? get obtenerNotaConteo {

    if (indicator != null) {

      return indicator!.notaConteo;

    }

    return "-";

  }

  String? get obtenerTooltipJl {

    if (indicator != null) {

      return indicator!.tooltipJl;

    }

    return "-";

  }

  String? get obtenerIgHours {

    if (indicator != null) {

      return indicator!.igHours;

    }

    return "-";

  }

  String? get obtenerUnitsCounted {

    if (indicator != null) {

      return formatearCantidad(indicator!.unitsCounted);

    }

    return "-";

  }

  String? get obtenerDiffCounted {

    if (indicator != null) {

      return indicator!.diffCountedInformed;

    }

    return "-";

  }

  String? get obtenerDiffNeto {

    if (indicator != null) {

      return indicator!.differenceNeto;

    }

    return "-";

  }

  List<Titular>? get obtenerTitulares {

    if (indicator != null) {

      return indicator!.tooltipTitulares;

    }

    return [];

  }

  Lider? get obtenerLider {

    if (indicator != null) {

      return indicator!.tooltipLider;

    }

    return null;

  }

  bool? get obtenerEsDia {

    return esDia;

  }

  factory Indicador.fromJson(Map<String, dynamic> json) {

    Indicator? objetoIndicador = json["indicator"] == null || json["indicator"] is List ? null : Indicator.fromJson(json["indicator"] as Map<String, dynamic>);

    var logsLista = json['logs'] as List;

    List<Log> listaLogs = logsLista.map((log) => Log.fromJson(log)).toList();

    return Indicador(
      clientName: json["client_name"],
      storeNumber: json["store_number"],
      storeName: json["store_name"],
      storeCommune: json["store_commune"],
      leader: json["leader"],
      indicator: objetoIndicador,
      inv: json["inv"],
      invReport: json["inv_report"],
      stockTeorico: json["stock_teorico"],
      esDia: json["es_dia"],
      dotacion: json["dotacion"],
      deterioro: json["deterioro"],
      horario: json["horario"],
      fecha: json["fecha"],
      logs: listaLogs,
      avance: null
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

      cantidad = cantidad.replaceAll(",", ".").replaceAll(".", "");

    }

    if (cantidad is int || cantidad is String) {

      return NumberFormat("#,###", "es_ES").format(int.parse(cantidad.toString()));

    }

    return "";

  }

}

class Indicator {

  int? idFile;
  String? unitsCounted;
  int? durationCount;
  String? durationProcess;
  String? igHours;
  dynamic avgScores;
  dynamic seiError;
  dynamic seiStandard;
  dynamic variance;
  String? diffCountedInformed;
  String? pttRevRate;
  String? itemsRevRate;
  String? errorClient;
  dynamic clientStandard;
  String? differenceNeto;
  bool? errorOperadores;
  String? notaConteo;
  String? tiempoConteo;
  List<Titular>? tooltipTitulares;
  Lider? tooltipLider;
  String? tooltipJl;
  int? inventario;
  Nomina? tooltipNomina;

  Indicator({
    this.idFile,
    this.unitsCounted,
    this.durationCount,
    this.durationProcess,
    this.igHours,
    this.avgScores,
    this.seiError,
    this.seiStandard,
    this.variance,
    this.diffCountedInformed,
    this.pttRevRate,
    this.itemsRevRate,
    this.errorClient,
    this.clientStandard,
    this.differenceNeto,
    this.errorOperadores,
    this.notaConteo,
    this.tiempoConteo,
    this.tooltipTitulares,
    this.tooltipLider,
    this.tooltipJl,
    this.inventario,
    this.tooltipNomina,
  });

  factory Indicator.fromJson(Map<String, dynamic> json) {

    var titularesLista = json['tooltip_titulares'] == null ? [] : json['tooltip_titulares'] as List;

    List<Titular> listaTitulares = titularesLista.map((titular) => Titular.fromJson(titular)).toList();

    Lider? objetoLider = json["tooltip_lider"] == null ? null : Lider.fromJson(json["tooltip_lider"] as Map<String, dynamic>);
    Nomina? objetoNomina = json["tooltip_nomina"] == null ? null : Nomina.fromJson(json["tooltip_nomina"] as Map<String, dynamic>);

    return Indicator(
      idFile: json["id_file"],
      unitsCounted: json["units_counted"],
      durationCount: json["duration_count"],
      durationProcess: json["duration_process"],
      igHours: json["ig_hours"],
      avgScores: json["avg_scores"],
      seiError: json["sei_error"],
      seiStandard: json["sei_standard"],
      variance: json["variance"],
      diffCountedInformed: json["diff_counted_informed"],
      pttRevRate: json["ptt_rev_rate"],
      itemsRevRate: json["items_rev_rate"],
      errorClient: json["error_client"],
      clientStandard: json["client_standard"],
      differenceNeto: json["difference_neto"],
      errorOperadores: json["error_operadores"],
      notaConteo: json["nota_conteo"],
      tiempoConteo: json["tiempo_conteo"],
      tooltipTitulares: listaTitulares,
      tooltipLider: objetoLider,
      tooltipJl: json["tooltip_jl"],
      inventario: json["inventario"],
      tooltipNomina: objetoNomina,
    );

  }

}

class Nomina {

  int? prodSugerida;
  String? horaLlegada;
  String? totalHorasConteo;
  int? dotacion;
  String? totalSala;
  String? totalBodega;
  String? notaPresentacion;
  String? notaSupervisor;
  String? totalTeorico;

  Nomina({
    this.prodSugerida,
    this.horaLlegada,
    this.totalHorasConteo,
    this.dotacion,
    this.totalSala,
    this.totalBodega,
    this.notaPresentacion,
    this.notaSupervisor,
    this.totalTeorico,
  });

  factory Nomina.fromJson(Map<String, dynamic> json) {

    return Nomina(
      prodSugerida: json["prod_sugerida"],
      horaLlegada: json["hora_llegada"],
      totalHorasConteo: json["total_horas_conteo"],
      dotacion: json["dotacion"],
      totalSala: json["total_sala"],
      totalBodega: json["total_bodega"],
      notaPresentacion: json["nota_presentacion"],
      notaSupervisor: json["nota_supervisor"],
      totalTeorico: json["total_teorico"],
    );

  }

}

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

  factory Lider.fromJson(Map<String, dynamic> json) {

    return Lider(
      titular: json["Titular"],
      error: json["Error"],
      cantError: json["CantError"],
      conteo: json["Conteo"],
    );

  }

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

class Log {

  int? id;
  String? log;
  int? tipo;
  int? idInventario;
  String? createdAt;

  Log({
    this.id,
    this.log,
    this.tipo,
    this.idInventario,
    this.createdAt,
  });

  factory Log.fromJson(Map<String, dynamic> json) {

    return Log(
      id: json["id"],
      log: json["log"],
      tipo: json["tipo"],
      idInventario: json["idInventario"],
      createdAt: json["created_at"],
    );

  }

}

class Reporte {
  
  int? idMarca;
  int? idInventario;
  int? idDescripcionReportesIg;
  int? idDescripcionReportesLocal;
  int? tipo;
  String? hora;
  int? dotacion;
  int? avance;
  String? error;
  String? comentario;
  String? idUser;
  double? auditoria;

  Reporte({
    this.idMarca,
    this.idInventario,
    this.idDescripcionReportesIg,
    this.idDescripcionReportesLocal,
    this.tipo,
    this.hora,
    this.dotacion,
    this.avance,
    this.error,
    this.comentario,
    this.idUser,
    this.auditoria,
  });

  factory Reporte.fromJson(Map<String, dynamic> json) {

    return Reporte(
      idMarca: json["idMarca"],
      idInventario: json["idInventario"],
      idDescripcionReportesIg: json["idDescripcionReportesIG"],
      idDescripcionReportesLocal: json["idDescripcionReportesLocal"],
      tipo: json["tipo"],
      hora: json["hora"],
      dotacion: json["dotacion"],
      avance: json["avance"],
      error: json["error"],
      comentario: json["comentario"],
      idUser: json["idUser"],
      auditoria: json["auditoria"],
    );

  }

}

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

  factory Titular.fromJson(Map<String, dynamic> json) {

    return Titular(
      titular: json["Titular"],
      comuna: json["Comuna"],
      error: json["Error"],
      cantError: json["CantError"],
      conteo: json["Conteo"],
      exp: json["EXP"],
    );

  }

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
