import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:sigsei/models/avance.dart';
import 'package:sigsei/models/indicator.dart';
import 'package:sigsei/models/lider.dart';
import 'package:sigsei/models/log.dart';
import 'package:sigsei/models/titular.dart';

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

    return "";

  }

  String? get obtenerSeiStandard {

    if (indicator != null) {

      return formatearPorcentaje(indicator!.seiStandard, 1);

    }

    return "";

  }

  String? get obtenerVariance {

    if (indicator != null) {

      return formatearPorcentaje(indicator!.variance, 1);

    }

    return "";

  }

  String? get obtenerAvgScores {

    if (indicator != null) {

      return indicator!.avgScores;

    }

    return "";

  }

  String? get obtenerTooltipJl {

    if (indicator != null) {

      return indicator!.tooltipJl;

    }

    return "";

  }

  String? get obtenerIgHours {

    if (indicator != null) {

      return indicator!.igHours;

    }

    return "";

  }

  String? get obtenerUnitsCounted {

    if (indicator != null) {

      return formatearCantidad(indicator!.unitsCounted);

    }

    return "";

  }

  String? get obtenerDiffCounted {

    if (indicator != null) {

      return indicator!.diffCountedInformed;

    }

    return "";

  }

  String? get obtenerDiffNeto {

    if (indicator != null) {

      return indicator!.differenceNeto;

    }

    return "";

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
