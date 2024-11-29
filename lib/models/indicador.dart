import 'dart:convert';

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
  DateTime? fecha;
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

  String get obtenerStockTeorico {

    return formatearCantidad(stockTeorico);

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

  String? get obtenerVariance {

    if (indicator != null) {

      return formatearPorcentaje(indicator!.variance, 1);

    }

    return "-";

  }

  String? get obtenerAvgScores {

    if (indicator != null) {

      return indicator!.avgScores;

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

  factory Indicador.fromJson(String str) => Indicador.fromMap(json.decode(str));

  factory Indicador.fromMap(Map<String, dynamic> json) => Indicador(
    clientName: json["client_name"],
    storeNumber: json["store_number"],
    storeName: json["store_name"],
    storeCommune: json["store_commune"],
    leader: json["leader"],
    indicator: (json["indicator"] != null && json["indicator"] is! List) ? Indicator.fromMap(json["indicator"]) : null,
    inv: json["inv"],
    invReport: json["inv_report"],
    stockTeorico: json["stock_teorico"],
    esDia: json["es_dia"],
    dotacion: json["dotacion"],
    deterioro: json["deterioro"],
    horario: json["horario"],
    fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
    logs: json["logs"] == null ? [] : List<Log>.from(json["logs"]!.map((x) => Log.fromMap(x))),
    avance: null
  );

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

  factory Indicator.fromJson(String str) => Indicator.fromMap(json.decode(str));

  factory Indicator.fromMap(Map<String, dynamic> json) => Indicator(
    idFile: json["id_file"],
    unitsCounted: json["units_counted"],
    durationCount: json["duration_count"],
    durationProcess: json["duration_process"],
    igHours: json["ig_hours"],
    avgScores: json["avg_scores"],
    seiError: json["sei_error"],
    seiStandard: json["sei_standard"]?.toDouble(),
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
    tooltipTitulares: json["tooltip_titulares"] == null ? [] : List<Titular>.from(json["tooltip_titulares"]!.map((x) => Titular.fromMap(x))),
    tooltipLider: json["tooltip_lider"] == null ? null : Lider.fromMap(json["tooltip_lider"]),
    tooltipJl: json["tooltip_jl"],
    inventario: json["inventario"],
    tooltipNomina: json["tooltip_nomina"] == null ? null : Nomina.fromMap(json["tooltip_nomina"]),
  );

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

  factory Nomina.fromJson(String str) => Nomina.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Nomina.fromMap(Map<String, dynamic> json) => Nomina(
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

  Map<String, dynamic> toMap() => {
    "prod_sugerida": prodSugerida,
    "hora_llegada": horaLlegada,
    "total_horas_conteo": totalHorasConteo,
    "dotacion": dotacion,
    "total_sala": totalSala,
    "total_bodega": totalBodega,
    "nota_presentacion": notaPresentacion,
    "nota_supervisor": notaSupervisor,
    "total_teorico": totalTeorico,
  };

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

class Log {

  int? id;
  String? log;
  int? tipo;
  int? idInventario;
  DateTime? createdAt;

  Log({
    this.id,
    this.log,
    this.tipo,
    this.idInventario,
    this.createdAt,
  });

  factory Log.fromJson(String str) => Log.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Log.fromMap(Map<String, dynamic> json) => Log(
    id: json["id"],
    log: json["log"],
    tipo: json["tipo"],
    idInventario: json["idInventario"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "log": log,
    "tipo": tipo,
    "idInventario": idInventario,
    "created_at": createdAt?.toIso8601String(),
  };

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

  factory Reporte.fromJson(String str) => Reporte.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Reporte.fromMap(Map<String, dynamic> json) => Reporte(
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
    auditoria: json["auditoria"]?.toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "idMarca": idMarca,
    "idInventario": idInventario,
    "idDescripcionReportesIG": idDescripcionReportesIg,
    "idDescripcionReportesLocal": idDescripcionReportesLocal,
    "tipo": tipo,
    "hora": hora,
    "dotacion": dotacion,
    "avance": avance,
    "error": error,
    "comentario": comentario,
    "idUser": idUser,
    "auditoria": auditoria,
  };

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

  factory Titular.fromJson(String str) => Titular.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Titular.fromMap(Map<String, dynamic> json) => Titular(
    titular: json["Titular"],
    comuna: json["Comuna"],
    error: json["Error"],
    cantError: json["CantError"],
    conteo: json["Conteo"],
    exp: json["EXP"],
  );

  Map<String, dynamic> toMap() => {
    "Titular": titular,
    "Comuna": comuna,
    "Error": error,
    "CantError": cantError,
    "Conteo": conteo,
    "EXP": exp,
  };

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
