import 'dart:convert';

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
