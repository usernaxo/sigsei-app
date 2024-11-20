import 'dart:convert';

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
