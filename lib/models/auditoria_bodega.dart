import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sigsei/themes/tema.dart';

class AuditoriaBodega {

  Auditoria? auditoria;
  Auditor? auditor;
  String? auditorTelefono;
  String? auditorRut;
  List<Nomina>? nomina;
  Local? local;
  Direccion? direccion;
  Comuna? comuna;
  Region? region;
  ArchivosEstado? archivosEstado;
  int? cantidadRegistros;
  dynamic porcentajeError;
  String? horaCierre;
  String? fechaMuestra;
  UltimoIndicadorAvance? ultimoIndicadorAvance;
  String? estadoCierre;

  AuditoriaBodega({
    this.auditoria,
    this.auditor,
    this.auditorTelefono,
    this.auditorRut,
    this.nomina,
    this.local,
    this.direccion,
    this.comuna,
    this.region,
    this.archivosEstado,
    this.cantidadRegistros,
    this.porcentajeError,
    this.horaCierre,
    this.fechaMuestra,
    this.ultimoIndicadorAvance,
    this.estadoCierre,
  });

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

  String? get obtenerPorcentajeGeneralAvance {

    if (ultimoIndicadorAvance != null) {

      return formatearPorcentaje(ultimoIndicadorAvance!.avanceGeneral, 2);

    }

    return "";

  }

  UltimoIndicadorAvance? obtenerUltimoIndicadorAvance() {

    if (ultimoIndicadorAvance != null) {

      return ultimoIndicadorAvance!;

    }

    return null;

  }

  List<Detalle>? obtenerDetallesAvance() {

    if (ultimoIndicadorAvance != null) {

      if (ultimoIndicadorAvance!.detalle!.isNotEmpty) {

        return ultimoIndicadorAvance!.detalle!;

      }

    }

    return [];

  }

  String? get obtenerPorcentajeGeneralError {

    if (ultimoIndicadorAvance != null) {

      return formatearPorcentaje(ultimoIndicadorAvance!.errorGeneralAbs, 2);

    }

    return "";

  }

  String? get obtenerPorcentajeError {

    return formatearPorcentaje(porcentajeError, 2);

  }

  String? get obtenerRegistro {

    if (cantidadRegistros != 0 && fechaMuestra!.isNotEmpty) {

      return "$cantidadRegistros $fechaMuestra";

    }

    return "";

  }

  String? get obtenerHoraCierre {

    return horaCierre ?? "";

  }

  String? get obtenerNombreCargadorArchivos {

    if (archivosEstado != null) {

      return archivosEstado!.report is bool ? "" : archivosEstado!.report;

    }

    return "";

  }

  bool? get obtenerPatente {

    if (archivosEstado != null) {

      return archivosEstado!.resumenPatentes;

    }

    return false;

  }

  bool? get obtenerZmig43 {

    if (archivosEstado != null) {

      return archivosEstado!.zmig43;

    }

    return false;

  }

  bool? get obtenerMuestra {

    if (archivosEstado != null) {

      return archivosEstado!.muestra!.toLowerCase().contains("generado") ? true : false;

    }

    return false;

  }

  Color get obtenerEstado {

    return obtenerMuestra! ? (obtenerHoraCierre!.isNotEmpty ? Colors.green : Colors.deepOrange.shade400) : Tema.secondaryLight;

  }

  String? get obtenerEstadoCierre {

    return estadoCierre;

  }

  factory AuditoriaBodega.fromJson(Map<String, dynamic> json) {

    Auditoria objetoAuditoria = Auditoria.fromJson(json["auditoria"] as Map<String, dynamic>);
    Auditor objetoAuditor = Auditor.fromJson(json["auditor"] as Map<String, dynamic>);

    var nominas = json["nomina"] as List;
    List<Nomina> listaNominas = nominas.map((n) => Nomina.fromJson(n)).toList();

    Local objetoLocal = Local.fromJson(json["local"] as Map<String, dynamic>);
    Direccion objetoDireccion = Direccion.fromJson(json["direccion"] as Map<String, dynamic>);
    Comuna objetoComuna = Comuna.fromJson(json["comuna"] as Map<String, dynamic>);
    Region objetoRegion = Region.fromJson(json["region"] as Map<String, dynamic>);
    ArchivosEstado? objetoArchivosEstado = json["archivosEstado"] != null ? ArchivosEstado.fromJson(json["archivosEstado"] as Map<String, dynamic>) : null;
    UltimoIndicadorAvance? objetoUltimoIndicadorAvance = json["ultimoIndicadorAvance"] != null ? UltimoIndicadorAvance.fromJson(json["ultimoIndicadorAvance"] as Map<String, dynamic>) : null;

    return AuditoriaBodega(
      auditoria: objetoAuditoria,
      auditor: objetoAuditor,
      auditorTelefono: json["auditor_telefono"],
      auditorRut: json["auditor_rut"],
      nomina: listaNominas,
      local: objetoLocal,
      direccion: objetoDireccion,
      comuna: objetoComuna,
      region: objetoRegion,
      archivosEstado: objetoArchivosEstado,
      cantidadRegistros: json["cantidad_registros"],
      porcentajeError: json["porcentajeError"],
      horaCierre: json["hora_cierre"],
      fechaMuestra: json["fechaMuestra"],
      ultimoIndicadorAvance: objetoUltimoIndicadorAvance,
      estadoCierre: json["estadoCierre"]
    );

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
  bool? mm60;
  bool? zmig43;
  String? muestra;
  bool? resumenPatentes;
  dynamic report;

  ArchivosEstado({
    this.archivoFinal,
    this.informeConteo,
    this.mm60,
    this.zmig43,
    this.muestra,
    this.resumenPatentes,
    this.report,
  });

  factory ArchivosEstado.fromJson(Map<String, dynamic> json) {

    return ArchivosEstado(
      archivoFinal: json["archivoFinal"],
      informeConteo: json["informeConteo"],
      mm60: json["mm60"],
      zmig43: json["zmig43"] ?? false,
      muestra: json["muestra"] ?? "",
      resumenPatentes: json["resumenPatentes"] ?? false,
      report: json["report"],
    );

  }

}

class Auditor {

  dynamic id;
  String? nombre;

  Auditor({
    this.id,
    this.nombre,
  });

  factory Auditor.fromJson(Map<String, dynamic> json) {

    return Auditor(
      id: json["id"],
      nombre: json["nombre"],
    );

  }

}

class Auditoria {

  int? id;
  String? fechaProgramada;
  int? facturable;

  Auditoria({
    this.id,
    this.fechaProgramada,
    this.facturable,
  });

  factory Auditoria.fromJson(Map<String, dynamic> json) {

    return Auditoria(
      id: json["id"],
      fechaProgramada: json["fechaProgramada"],
      facturable: json["facturable"]
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
  String? email;

  Local({
    this.idLocal,
    this.numero,
    this.nombre,
    this.stock,
    this.isMall,
    this.isCerrado,
    this.email,
  });

  factory Local.fromJson(Map<String, dynamic> json) {

    return Local(
      idLocal: json["idLocal"],
      numero: json["numero"],
      nombre: json["nombre"],
      stock: json["stock"],
      isMall: json["isMall"],
      isCerrado: json["isCerrado"],
      email: json["email"]
    );

  }

}

class Nomina {

  int? id;
  int? estadoId;
  String? turno;
  int? habilitada;
  int? dotacion;
  String? estadoNombre;
  int? numeroDotacion;
  Encargado? encargado;
  List<Tooltip>? tooltip;

  Nomina({
    this.id,
    this.estadoId,
    this.turno,
    this.habilitada,
    this.dotacion,
    this.estadoNombre,
    this.numeroDotacion,
    this.encargado,
    this.tooltip,
  });

  factory Nomina.fromJson(Map<String, dynamic> json) {

    Encargado? objetoEncargado = json["encargado"] == null ? null : Encargado.fromJson(json["encargado"] as Map<String, dynamic>);

    var tooltips = json["tooltip"] as List;
    List<Tooltip> listaTooltips = tooltips.map((t) => Tooltip.fromJson(t)).toList();

    return Nomina(
      id: json["id"],
      estadoId: json["estado_id"],
      turno: json["turno"],
      habilitada: json["habilitada"],
      dotacion: json["dotacion"],
      estadoNombre: json["estado_nombre"],
      numeroDotacion: json["numeroDotacion"],
      encargado: objetoEncargado,
      tooltip: listaTooltips
    );

  }

}

class Encargado {

  int? id;
  String? usuarioRun;
  String? nombre1;
  String? nombre2;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? fechaNacimiento;
  String? sexo;
  String? telefono;
  String? telefonoEmergencia;
  String? nombreTelEmergencia;
  String? parentezcoTelEmergencia;
  int? bloqueado;
  int? bloqueoPermanente;
  String? username;
  int? activo;
  String? createdAt;
  String? updatedAt;
  String? usuarioDv;
  int? almCodigo;
  String? emailPersonal;
  String? direccion;
  String? gmapLatitude;
  String? gmapLongitude;
  int? cutComuna;
  String? tipoContrato;
  dynamic fechaInicioContrato;
  String? fechaCertificadoAntecedentes;
  String? banco;
  int? codBanco;
  String? tipoCuenta;
  dynamic codTipoCuenta;
  String? numeroCuenta;
  int? idBanco;
  int? idCuentaBanco;
  String? email;
  String? imagenPerfil;
  int? documentationStatus;
  String? nacionalidad;
  int? registroAprobado;
  int? mustChangePassword;
  int? turnoId;

  Encargado({
    this.id,
    this.usuarioRun,
    this.nombre1,
    this.nombre2,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.fechaNacimiento,
    this.sexo,
    this.telefono,
    this.telefonoEmergencia,
    this.nombreTelEmergencia,
    this.parentezcoTelEmergencia,
    this.bloqueado,
    this.bloqueoPermanente,
    this.username,
    this.activo,
    this.createdAt,
    this.updatedAt,
    this.usuarioDv,
    this.almCodigo,
    this.emailPersonal,
    this.direccion,
    this.gmapLatitude,
    this.gmapLongitude,
    this.cutComuna,
    this.tipoContrato,
    this.fechaInicioContrato,
    this.fechaCertificadoAntecedentes,
    this.banco,
    this.codBanco,
    this.tipoCuenta,
    this.codTipoCuenta,
    this.numeroCuenta,
    this.idBanco,
    this.idCuentaBanco,
    this.email,
    this.imagenPerfil,
    this.documentationStatus,
    this.nacionalidad,
    this.registroAprobado,
    this.mustChangePassword,
    this.turnoId,
  });

  factory Encargado.fromJson(Map<String, dynamic> json) {

    return Encargado(
      id: json["id"],
      usuarioRun: json["usuarioRUN"],
      nombre1: json["nombre1"],
      nombre2: json["nombre2"],
      apellidoPaterno: json["apellidoPaterno"],
      apellidoMaterno: json["apellidoMaterno"],
      fechaNacimiento: json["fechaNacimiento"],
      sexo: json["sexo"],
      telefono: json["telefono"],
      telefonoEmergencia: json["telefonoEmergencia"],
      nombreTelEmergencia: json["nombreTelEmergencia"],
      parentezcoTelEmergencia: json["parentezcoTelEmergencia"],
      bloqueado: json["bloqueado"],
      bloqueoPermanente: json["bloqueo_permanente"],
      username: json["username"],
      activo: json["activo"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      usuarioDv: json["usuarioDV"],
      almCodigo: json["alm_codigo"],
      emailPersonal: json["emailPersonal"],
      direccion: json["direccion"],
      gmapLatitude: json["gmap_latitude"],
      gmapLongitude: json["gmap_longitude"],
      cutComuna: json["cutComuna"],
      tipoContrato: json["tipoContrato"],
      fechaInicioContrato: json["fechaInicioContrato"],
      fechaCertificadoAntecedentes: json["fechaCertificadoAntecedentes"],
      banco: json["banco"],
      codBanco: json["codBanco"],
      tipoCuenta: json["tipoCuenta"],
      codTipoCuenta: json["codTipoCuenta"],
      numeroCuenta: json["numeroCuenta"],
      idBanco: json["idBanco"],
      idCuentaBanco: json["idCuentaBanco"],
      email: json["email"],
      imagenPerfil: json["imagenPerfil"],
      documentationStatus: json["documentationStatus"],
      nacionalidad: json["nacionalidad"],
      registroAprobado: json["registroAprobado"],
      mustChangePassword: json["must_change_password"],
      turnoId: json["turno_id"],
    );

  }

}

class Tooltip {

  String? nombre;

  Tooltip({
    this.nombre,
  });

  factory Tooltip.fromJson(Map<String, dynamic> json) {

    return Tooltip(
      nombre: json["nombre"],
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

class UltimoIndicadorAvance {

  int? id;
  int? auditoriaId;
  String? local;
  String? fecha;
  String? avanceGeneral;
  String? errorGeneralAbs;
  String? avancePatentesCantidad;
  String? avancePatentesPorcentaje;
  int? totalUnidadesMuestra;
  int? totalValorizadaMuestra;
  int? detalleConteoZmig;
  int? detalleConteoSei;
  int? detalleDifUnd;
  int? detalleValorAjuste;
  String? createdAt;
  String? detalleDesvValorAbs;
  List<Detalle>? detalle;

  UltimoIndicadorAvance({
    this.id,
    this.auditoriaId,
    this.local,
    this.fecha,
    this.avanceGeneral,
    this.errorGeneralAbs,
    this.avancePatentesCantidad,
    this.avancePatentesPorcentaje,
    this.totalUnidadesMuestra,
    this.totalValorizadaMuestra,
    this.detalleConteoZmig,
    this.detalleConteoSei,
    this.detalleDifUnd,
    this.detalleValorAjuste,
    this.createdAt,
    this.detalleDesvValorAbs,
    this.detalle,
  });

  String? get obtenerCantidadPatentes {

    return avancePatentesCantidad;

  }

  String? get obtenerAvancePatentes {

    return formatearPorcentaje(avancePatentesPorcentaje, 2);

  }

  String? get obtenerTotalZmig {

    return NumberFormat("#,###", "es_ES").format(detalleConteoZmig);

  }

  String? get obtenerTotalSei {

    return NumberFormat("#,###", "es_ES").format(detalleConteoSei);

  }

  String? get obtenerTotalDiferenciaUnidades {

    return NumberFormat("#,###", "es_ES").format(detalleDifUnd);

  }

  String? get obtenerTotalValorAjuste {

    return NumberFormat("#,###", "es_ES").format(detalleValorAjuste);

  }

  factory UltimoIndicadorAvance.fromJson(Map<String, dynamic> json) {

    var detalles = json["detalle"] as List;
    List<Detalle> listaDetalles = detalles.map((d) => Detalle.fromJson(d)).toList();

    return UltimoIndicadorAvance(
      id: json["id"],
      auditoriaId: json["auditoria_id"],
      local: json["local"],
      fecha: json["fecha"],
      avanceGeneral: json["avance_general"],
      errorGeneralAbs: json["error_general_abs"],
      avancePatentesCantidad: json["avance_patentes_cantidad"],
      avancePatentesPorcentaje: json["avance_patentes_porcentaje"],
      totalUnidadesMuestra: json["total_unidades_muestra"],
      totalValorizadaMuestra: json["total_valorizada_muestra"],
      detalleConteoZmig: json["detalle_conteo_zmig"],
      detalleConteoSei: json["detalle_conteo_sei"],
      detalleDifUnd: json["detalle_dif_und"],
      detalleValorAjuste: json["detalle_valor_ajuste"],
      createdAt: json["created_at"],
      detalleDesvValorAbs: json["detalle_desv_valor_abs"],
      detalle: listaDetalles
    );

  }

  String formatearPorcentaje(dynamic porcentaje, int cantidadDecimal) {

    if (porcentaje is String || porcentaje is int || porcentaje is double) {

      return "${double.parse(porcentaje.toString().replaceAll("%", "").replaceAll(",", ".")).toStringAsFixed(cantidadDecimal)} %";
      
    }

    return "";

  }

}

class Detalle {
  
  int? id;
  int? indicadorAvanceId;
  String? patente;
  String? sku;
  String? descripcion;
  int? conteoZmig;
  int? conteoSei;
  int? difUnd;
  int? valorAjuste;
  String? porDifAbsUni;
  String? porDesvValorAbs;
  String? createdAt;

  Detalle({
    this.id,
    this.indicadorAvanceId,
    this.patente,
    this.sku,
    this.descripcion,
    this.conteoZmig,
    this.conteoSei,
    this.difUnd,
    this.valorAjuste,
    this.porDifAbsUni,
    this.porDesvValorAbs,
    this.createdAt,
  });

  String? get obtenerPatente {

    return patente;

  }

  String? get obtenerSku {

    return sku;

  }

  String? get obtenerDescripcion {

    return descripcion;

  }

  String? get obtenerConteoZmig {

    return NumberFormat("#,###", "es_ES").format(conteoZmig);

  }

  String? get obtenerConteoSei {

    return NumberFormat("#,###", "es_ES").format(conteoSei);

  }

  String? get obtenerDiferenciaUnidades {

    return NumberFormat("#,###", "es_ES").format(difUnd);

  }

  String? get obtenerValorAjuste {

    return NumberFormat("#,###", "es_ES").format(valorAjuste);

  }

  factory Detalle.fromJson(Map<String, dynamic> json) {

    return Detalle(
      id: json["id"],
      indicadorAvanceId: json["indicador_avance_id"],
      patente: json["patente"],
      sku: json["sku"],
      descripcion: json["descripcion"],
      conteoZmig: json["conteo_zmig"],
      conteoSei: json["conteo_sei"],
      difUnd: json["dif_und"],
      valorAjuste: json["valor_ajuste"],
      porDifAbsUni: json["por_dif_abs_uni"],
      porDesvValorAbs: json["por_desv_valor_abs"],
      createdAt: json["created_at"]
    );

  }

}

class Excluyente {

  GeneralConteo? generalConteo;
  bool? cierre;
  ResumenCierre? resumenCierre;
  List<DetalleConteo>? detalleConteo;
  LocalExcluyente? local;
  Observacion? observacion;

  Excluyente({
    this.generalConteo,
    this.cierre,
    this.resumenCierre,
    this.detalleConteo,
    this.local,
    this.observacion,
  });

  factory Excluyente.fromJson(Map<String, dynamic> json) {

    GeneralConteo? objetoGeneralConteo = json["generalConteo"] == null ? null : GeneralConteo.fromJson(json["generalConteo"] as Map<String, dynamic>);
    ResumenCierre? objetoResumenCierre = json["resumen_cierre"] == null ? null : ResumenCierre.fromJson(json["resumen_cierre"] as Map<String, dynamic>);
    LocalExcluyente? objetoLocal = json["local"] == null ? null : LocalExcluyente.fromJson(json["local"] as Map<String, dynamic>);
    Observacion? objetoObservacion = json["observacion"] == null ? null : Observacion.fromJson(json["observacion"] as Map<String, dynamic>);

    var detalleConteoLista = json["detalleConteo"] == null ? [] : json["detalleConteo"] as List;
    List<DetalleConteo> listaDetalleConteo = detalleConteoLista.map((d) => DetalleConteo.fromJson(d)).toList();

    return Excluyente(
      generalConteo: objetoGeneralConteo,
      cierre: json["cierre"],
      resumenCierre: objetoResumenCierre,
      detalleConteo: listaDetalleConteo,
      local: objetoLocal,
      observacion: objetoObservacion,
    );

  }

  List<DetalleConteo>? get obtenerDetalleConteo {

    return detalleConteo!.where((detalleConteo) => detalleConteo.excluir == 1).toList();

  }

  String? get obtenerTotalUnidadAbs {

    int? cantidadTotal = 0;

    for (var detalleConteo in detalleConteo!) {

      cantidadTotal = cantidadTotal! + detalleConteo.difUnd!.abs();

    }

    return NumberFormat("#,###", "es_ES").format(cantidadTotal);

  }

  String? get obtenerTotalValorAbs {

    int? valorTotal = 0;

    for (var detalleConteo in detalleConteo!) {

      valorTotal = valorTotal! + detalleConteo.valorAjuste!.abs();

    }

    return NumberFormat("#,###", "es_ES").format(valorTotal);

  }

  String? get obtenerObservacion {

    return observacion != null ? observacion!.observacion : "Sin observación";

  }

}

class DetalleConteo {

  int? id;
  int? excluir;
  String? patente;
  String? sku;
  String? descripcion;
  int? conteoZmig;
  int? conteoSei;
  int? difUnd;
  int? valorAjuste;
  String? porDifAbsUni;
  String? porDesvValorAbs;

  DetalleConteo({
    this.id,
    this.excluir,
    this.patente,
    this.sku,
    this.descripcion,
    this.conteoZmig,
    this.conteoSei,
    this.difUnd,
    this.valorAjuste,
    this.porDifAbsUni,
    this.porDesvValorAbs,
  });

  factory DetalleConteo.fromJson(Map<String, dynamic> json) {

    return DetalleConteo(
      id: json["id"],
      excluir: json["excluir"],
      patente: json["patente"],
      sku: json["sku"],
      descripcion: json["descripcion"],
      conteoZmig: json["conteo_zmig"],
      conteoSei: json["conteo_sei"],
      difUnd: json["dif_und"],
      valorAjuste: json["valor_ajuste"],
      porDifAbsUni: json["por_dif_abs_uni"],
      porDesvValorAbs: json["por_desv_valor_abs"],
    );

  }

  String? get obtenerPatente {

    return patente;

  }

  String? get obtenerSku {

    return sku;

  }

  String? get obtenerDescripcion {

    return descripcion;

  }

  String? get obtenerConteoZmig {

    return NumberFormat("#,###", "es_ES").format(conteoZmig);

  }

  String? get obtenerConteoSei {

    return NumberFormat("#,###", "es_ES").format(conteoSei);

  }

  String? get obtenerDiferenciaUnidades {

    return NumberFormat("#,###", "es_ES").format(difUnd);

  }

  bool? get esExcluido {

    return excluir == 0 ? false : true;

  }

}

class GeneralConteo {

  int? id;
  int? auditoriaId;
  String? local;
  String? fecha;
  String? avanceGeneral;
  String? errorGeneralAbs;
  String? avancePatentesCantidad;
  String? avancePatentesPorcentaje;
  int? totalUnidadesMuestra;
  int? totalValorizadaMuestra;
  int? detalleConteoZmig;
  int? detalleConteoSei;
  int? detalleDifUnd;
  int? detalleValorAjuste;
  String? createdAt;
  double? detalleDesvValorAbs;

  GeneralConteo({
    this.id,
    this.auditoriaId,
    this.local,
    this.fecha,
    this.avanceGeneral,
    this.errorGeneralAbs,
    this.avancePatentesCantidad,
    this.avancePatentesPorcentaje,
    this.totalUnidadesMuestra,
    this.totalValorizadaMuestra,
    this.detalleConteoZmig,
    this.detalleConteoSei,
    this.detalleDifUnd,
    this.detalleValorAjuste,
    this.createdAt,
    this.detalleDesvValorAbs,
  });

  factory GeneralConteo.fromJson(Map<String, dynamic> json) {

    return GeneralConteo(
      id: json["id"],
      auditoriaId: json["auditoria_id"],
      local: json["local"],
      fecha: json["fecha"],
      avanceGeneral: json["avance_general"],
      errorGeneralAbs: json["error_general_abs"],
      avancePatentesCantidad: json["avance_patentes_cantidad"],
      avancePatentesPorcentaje: json["avance_patentes_porcentaje"],
      totalUnidadesMuestra: json["total_unidades_muestra"],
      totalValorizadaMuestra: json["total_valorizada_muestra"],
      detalleConteoZmig: json["detalle_conteo_zmig"],
      detalleConteoSei: json["detalle_conteo_sei"],
      detalleDifUnd: json["detalle_dif_und"],
      detalleValorAjuste: json["detalle_valor_ajuste"],
      createdAt: json["created_at"],
      detalleDesvValorAbs: json["detalle_desv_valor_abs"],
    );

  }

  String? get obtenerTotalMuestraUnidades {

    return NumberFormat("#,###", "es_ES").format(totalUnidadesMuestra);

  }

  String? get obtenerTotalMuestraValorizada {

    return NumberFormat("#,###", "es_ES").format(totalValorizadaMuestra);

  }

  String? get obtenerTotalConteoZmig {

    return NumberFormat("#,###", "es_ES").format(detalleConteoZmig);

  }

  String? get obtenerTotalConteoSei {

    return NumberFormat("#,###", "es_ES").format(detalleConteoSei);

  }

  String? get obtenerTotalDiferenciaUnidades {

    return NumberFormat("#,###", "es_ES").format(detalleDifUnd);

  }

}

class LocalExcluyente {

  String? numero;
  String? nombre;

  LocalExcluyente({
    this.numero,
    this.nombre,
  });

  factory LocalExcluyente.fromJson(Map<String, dynamic> json) {

    return LocalExcluyente(
      numero: json["numero"],
      nombre: json["nombre"],
    );

  }

}

class Observacion {

  int? id;
  int? idAuditoria;
  String? observacion;
  int? idUsuario;
  String? createdAt;
  String? updatedAt;

  Observacion({
    this.id,
    this.idAuditoria,
    this.observacion,
    this.idUsuario,
    this.createdAt,
    this.updatedAt,
  });

  factory Observacion.fromJson(Map<String, dynamic> json) {

    return Observacion(
      id: json["id"],
      idAuditoria: json["idAuditoria"],
      observacion: json["observacion"],
      idUsuario: json["idUsuario"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );

  }

}

class ResumenCierre {

  int? id;
  int? auditoriaId;
  int? valida;
  String? errorUnidadesAbs;
  String? errorValorAbs;
  int? excluirUnidadesAbs;
  int? excluirTotalRegistros;
  int? usuarioId;
  String? createdAt;
  String? updatedAt;
  String? observacion;
  String? usuario;

  ResumenCierre({
    this.id,
    this.auditoriaId,
    this.valida,
    this.errorUnidadesAbs,
    this.errorValorAbs,
    this.excluirUnidadesAbs,
    this.excluirTotalRegistros,
    this.usuarioId,
    this.createdAt,
    this.updatedAt,
    this.observacion,
    this.usuario,
  });

  factory ResumenCierre.fromJson(Map<String, dynamic> json) {

    return ResumenCierre(
      id: json["id"],
      auditoriaId: json["auditoria_id"],
      valida: json["valida"],
      errorUnidadesAbs: json["error_unidades_abs"],
      errorValorAbs: json["error_valor_abs"],
      excluirUnidadesAbs: json["excluir_unidades_abs"],
      excluirTotalRegistros: json["excluir_total_registros"],
      usuarioId: json["usuario_id"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      observacion: json["observacion"],
      usuario: json["usuario"],
    );

  }

}
