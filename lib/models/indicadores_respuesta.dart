import 'dart:convert';

import 'package:sigsei/models/indicador.dart';

class IndicadoresResponse {

  List<Indicador>? listaIndicadores;

  IndicadoresResponse({
    this.listaIndicadores,
  });

  factory IndicadoresResponse.fromJson(String str) => IndicadoresResponse.fromMap(json.decode(str));

  factory IndicadoresResponse.fromMap(Map<String, dynamic> json) => IndicadoresResponse(
    listaIndicadores: json["indicadores"] == null ? [] : List<Indicador>.from(json["indicadores"]!.map((x) => Indicador.fromMap(x))),
  );

}
