import 'package:sigsei/models/auditoria_smu.dart';

class AuditoriasSmuRespuesta {

  List<AuditoriaSmu>? listaAuditoriasSmu;

  AuditoriasSmuRespuesta({
    this.listaAuditoriasSmu,
  });

  factory AuditoriasSmuRespuesta.fromJson(List<dynamic> json) {

    return AuditoriasSmuRespuesta(
      listaAuditoriasSmu: json.map((auditoriaSmu) => AuditoriaSmu.fromJson(auditoriaSmu)).toList(),
    );
    
  }

}
