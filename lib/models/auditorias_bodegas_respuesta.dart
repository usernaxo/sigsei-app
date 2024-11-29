import 'package:sigsei/models/auditoria_bodega.dart';

class AuditoriasBodegasRespuesta {

  List<AuditoriaBodega>? listaAuditoriasBodega;

  AuditoriasBodegasRespuesta({
    this.listaAuditoriasBodega,
  });

  factory AuditoriasBodegasRespuesta.fromJson(List<dynamic> json) {

    return AuditoriasBodegasRespuesta(
      listaAuditoriasBodega: json.map((auditoriaBodega) => AuditoriaBodega.fromJson(auditoriaBodega)).toList(),
    );
    
  }

}
