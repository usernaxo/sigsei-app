import 'dart:convert';

import 'package:sigsei/models/lider.dart';
import 'package:sigsei/models/nomina.dart';
import 'package:sigsei/models/titular.dart';

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
