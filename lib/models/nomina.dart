import 'dart:convert';

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
