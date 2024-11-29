import 'dart:convert';

import 'package:sigsei/models/indicador.dart';

class IndicadoresRespuesta {

  List<Indicador>? listaIndicadores;

  IndicadoresRespuesta({
    this.listaIndicadores,
  });

  factory IndicadoresRespuesta.fromJson(String str) => IndicadoresRespuesta.fromMap(json.decode(str));

  factory IndicadoresRespuesta.fromMap(Map<String, dynamic> json) => IndicadoresRespuesta(
    listaIndicadores: json["indicadores"] == null ? [] : List<Indicador>.from(json["indicadores"]!.map((x) => Indicador.fromMap(x))),
  );

}
