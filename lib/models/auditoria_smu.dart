class AuditoriaSmu {

  Auditoria? auditoria;
  Auditor? auditor;
  Local? local;
  Direccion? direccion;
  Comuna? comuna;
  Region? region;
  ArchivosEstado? archivosEstado;

  AuditoriaSmu({
    this.auditoria,
    this.auditor,
    this.local,
    this.direccion,
    this.comuna,
    this.region,
    this.archivosEstado,
  });

  factory AuditoriaSmu.fromJson(Map<String, dynamic> json) {

    Auditoria objetoAuditoria = Auditoria.fromJson(json["auditoria"] as Map<String, dynamic>);
    Auditor objetoAuditor = Auditor.fromJson(json["auditor"] as Map<String, dynamic>);
    Local objetoLocal = Local.fromJson(json["local"] as Map<String, dynamic>);
    Direccion objetoDireccion = Direccion.fromJson(json["direccion"] as Map<String, dynamic>);
    Comuna objetoComuna = Comuna.fromJson(json["comuna"] as Map<String, dynamic>);
    Region objetoRegion = Region.fromJson(json["region"] as Map<String, dynamic>);
    ArchivosEstado objetoArchivosEstado = ArchivosEstado.fromJson(json["archivosEstado"] as Map<String, dynamic>);

    return AuditoriaSmu(
      auditoria: objetoAuditoria,
      auditor: objetoAuditor,
      local: objetoLocal,
      direccion: objetoDireccion,
      comuna: objetoComuna,
      region: objetoRegion,
      archivosEstado: objetoArchivosEstado
    );

  }

  String? get obtenerFecha {

    if (auditoria != null) {

      return auditoria!.fechaProgramada;

    }

    return "";

  }

  String? get obtenerNumero {

    if (local != null) {

      return local!.numero;

    }

    return "";

  }

  String? get obtenerNombre {

    if (local != null) {

      return local!.nombre;

    }

    return "";

  }

  String? get obtenerNombreCorto {

    if (local != null) {

      return local!.nombre!.length > 14 ? local!.nombre!.substring(0, 14) : local!.nombre;

    }

    return "";

  }

  String? get obtenerAuditor {

    if (auditor != null) {

      return auditor!.nombre;

    }

    return "";

  }

  String? get obtenerAuditorCorto {

    if (auditor != null) {

      return auditor!.nombre!.length > 14 ? auditor!.nombre!.substring(0, 14) : auditor!.nombre;

    }

    return "";

  }

  String? get obtenerRegion {

    if (region != null) {

      return region!.nombreCorto;

    }

    return "";

  }

  String? get obtenerComuna {

    if (comuna != null) {

      return comuna!.nombre;

    }

    return "";

  }

  String? get obtenerDireccion {

    if (direccion != null) {

      return direccion!.nombre;

    }

    return "";

  }

  String? get obtenerPorcentajeConteo {

    if (archivosEstado != null) {

      return obtenerHoraInicio!.isEmpty || obtenerHoraInicio == "-" ? "-" : formatearPorcentaje(archivosEstado!.porConteo, 2);

    }

    return "";

  }

  String? get obtenerPorcentajeChecklist {

    if (archivosEstado != null) {

      return obtenerHoraInicio!.isEmpty || obtenerHoraInicio == "-" ? "-" : formatearPorcentaje(archivosEstado!.porChecklist, 0);

    }

    return "";

  }

  String? get obtenerHoraInicio {

    if (auditoria != null) {

      return auditoria!.horaInicio;

    }

    return "";

  }

  String? get obtenerHoraTermino {

    if (auditoria != null) {

      return auditoria!.horaFin;

    }

    return "";

  }

  String? get obtenerTiempoProceso {

    if (auditoria != null) {

      return auditoria!.tiempoProceso;

    }

    return "";

  }

  bool? get obtenerMm60 {

    if (archivosEstado != null) {

      return archivosEstado!.mm60;

    }

    return false;

  }

  bool? get obtenerZmig43 {

    if (archivosEstado != null) {

      return archivosEstado!.zmig43;

    }

    return false;

  }

  String formatearPorcentaje(dynamic porcentaje, int cantidadDecimal) {

    if (porcentaje is String || porcentaje is int || porcentaje is double) {

      return "${double.parse(porcentaje.toString().replaceAll("%", "").replaceAll(",", ".")).toStringAsFixed(cantidadDecimal)} %";
      
    }

    return "";

  }
  
}

class ArchivosEstado {

  bool? archivoFinal;
  bool? informeConteo;
  bool? informeChecklist;
  bool? mm60;
  bool? zmig43;
  bool? muestra;
  String? porConteo;
  dynamic porChecklist;

  ArchivosEstado({
    this.archivoFinal,
    this.informeConteo,
    this.informeChecklist,
    this.mm60,
    this.zmig43,
    this.muestra,
    this.porConteo,
    this.porChecklist,
  });

  factory ArchivosEstado.fromJson(Map<String, dynamic> json) {

    return ArchivosEstado(
      archivoFinal: json["archivoFinal"],
      informeConteo: json["informeConteo"],
      informeChecklist: json["informeChecklist"],
      mm60: json["mm60"],
      zmig43: json["zmig43"],
      muestra: json["muestra"],
      porConteo: json["por_conteo"],
      porChecklist: json["por_checklist"]
    );

  }

}

class Auditor {

  int? idAuditor;
  String? nombre;

  Auditor({
    this.idAuditor,
    this.nombre,
  });

  factory Auditor.fromJson(Map<String, dynamic> json) {

    return Auditor(
      idAuditor: json["idAuditor"],
      nombre: json["nombre"]
    );

  }

}

class Auditoria {

  int? id;
  String? fechaProgramada;
  String? horaInicio;
  String? horaFin;
  String? tiempoProceso;
  int? facturable;

  Auditoria({
    this.id,
    this.fechaProgramada,
    this.horaInicio,
    this.horaFin,
    this.tiempoProceso,
    this.facturable,
  });

  factory Auditoria.fromJson(Map<String, dynamic> json) {

    return Auditoria(
      id: json["id"],
      fechaProgramada: json["fechaProgramada"],
      horaInicio: json["hora_inicio"],
      horaFin: json["hora_fin"],
      tiempoProceso: json["tiempo_proceso"],
      facturable: json["facturable"],
    );

  }

}

class Comuna {

  int? idComuna;
  String? nombre;

  Comuna({
    this.idComuna,
    this.nombre,
  });

  factory Comuna.fromJson(Map<String, dynamic> json) {

    return Comuna(
      idComuna: json["idComuna"],
      nombre: json["nombre"]
    );

  }

}

class Direccion {

  String? nombre;
  String? gmapLatitude;
  String? gmapLongitude;
  dynamic gmapPlaceId;

  Direccion({
    this.nombre,
    this.gmapLatitude,
    this.gmapLongitude,
    this.gmapPlaceId,
  });

  factory Direccion.fromJson(Map<String, dynamic> json) {

    return Direccion(
      nombre: json["nombre"],
      gmapLatitude: json["gmap_latitude"],
      gmapLongitude: json["gmap_longitude"],
      gmapPlaceId: json["gmap_place_id"]
    );

  }

}

class Local {

  int? idLocal;
  String? numero;
  String? nombre;
  int? stock;
  bool? isMall;
  bool? isCerrado;

  Local({
    this.idLocal,
    this.numero,
    this.nombre,
    this.stock,
    this.isMall,
    this.isCerrado,
  });

  factory Local.fromJson(Map<String, dynamic> json) {

    return Local(
      idLocal: json["idLocal"],
      numero: json["numero"],
      nombre: json["nombre"],
      stock: json["stock"],
      isMall: json["isMall"],
      isCerrado: json["isCerrado"]
    );

  }

}

class Region {

  int? idRegion;
  String? nombreCorto;
  String? numero;
  String? nombre;

  Region({
    this.idRegion,
    this.nombreCorto,
    this.numero,
    this.nombre,
  });

  factory Region.fromJson(Map<String, dynamic> json) {

    return Region(
      idRegion: json["idRegion"],
      nombreCorto: json["nombreCorto"],
      numero: json["numero"],
      nombre: json["nombre"],
    );

  }

}
