import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InventarioGeneral {

  dynamic invIdInventario;
  String? invFechaProgramadaF;
  String? invFechaProgramada;
  String? invFechaProgramadaDow;
  int? invEstadoPublicacion;
  List<InvComentario>? invComentarios;
  int? invAuditoriaSmu;
  dynamic clienteIdCliente;
  String? clienteNombreCorto;
  int? localIdLocal;
  String? localCeco;
  String? localNombre;
  int? localIdFormato;
  String? localFormatoLocal;
  String? localProduccionSugerida;
  String? localComuna;
  int? localCutComuna;
  String? localRegion;
  int? localCutRegion;
  String? localDireccion;
  String? localHoraApertura;
  String? localHoraCierre;
  String? localTopeFechaConAuditoria;
  int? localRecintoCerrado;
  int? localIsMall;
  int? localIsFarma;
  String? localGmapLatitud;
  String? localGmapLongitud;
  String? storeDepartureTime;
  bool? localLogistica;
  List<LocalComentario>? localComentarios;
  int? invIdJornada;
  String? invJornada;
  int? invStockTeorico;
  String? invFechaStock;
  String? invPromStock;
  bool? invFechaStockAntigua;
  int? invPatentes;
  int? invPda;
  int? invUnidadesReales;
  int? invUnidadesTeorico;
  String? invEstadoArchivoFinal;
  int? invReporte;
  int? ndiaIdNomina;
  int? ndiaDotTotal;
  int? ndiaDotOperadores;
  List<NdiaTotalDadosBaja>? ndiaTotalTitulares;
  List<NdiaTotalDadosBaja>? ndiaTotalDadosBaja;
  int? ndiaTotalTitularesBaja;
  dynamic ndiaBloqueoDotacion;
  int? ndiaEstadoDotacion;
  int? ndiaIdLider;
  String? ndiaLider;
  String? ndiaHrLider;
  String? ndiaHrEquipo;
  int? ndiaIdSupervisor;
  String? ndiaSupervisor;
  dynamic ndiaIdCaptador1;
  String? ndiaCaptador1;
  int? ndiaRectificada;
  int? ndiaRectificaSistema;
  List<Captador>? ndiaCaptadores;
  int? ndiaIdEstadoNomina;
  String? ndiaEstadoNomina;
  int? ndiaHabilitada;
  String? ndiaUrlNominaPago;
  int? ndiaCalificacionNomina;
  dynamic ndiaCantidadNuevos;
  String? ndiaConteoSugerido;
  String? ndiaStockSugerido;
  String? ndiaDiferenciaConteo;
  String? ndiaMensaje;
  int? ndiaConBaja;
  int? nnocheIdNomina;
  int? nnocheDotTotal;
  int? nnocheDotOperadores;
  List<NdiaTotalDadosBaja>? nnocheTotalTitulares;
  List<NdiaTotalDadosBaja>? nnocheTotalDadosBaja;
  int? nnocheTotalTitularesBaja;
  dynamic nnocheBloqueoDotacion;
  int? nnocheEstadoDotacion;
  int? nnocheIdLider;
  String? nnocheLider;
  String? nnocheHrLider;
  String? nnocheHrEquipo;
  int? nnocheIdSupervisor;
  String? nnocheSupervisor;
  dynamic nnocheIdCaptador1;
  String? nnocheCaptador1;
  int? nnocheRectificada;
  int? nnocheRectificaSistema;
  List<Captador>? nnocheCaptadores;
  int? nnocheIdEstadoNomina;
  String? nnocheEstadoNomina;
  int? nnocheHabilitada;
  String? nnocheUrlNominaPago;
  int? nnocheCalificacionNomina;
  int? nnocheCantidadNuevos;
  String? nnocheConteoSugerido;
  String? nnocheStockSugerido;
  String? nnocheDiferenciaConteo;
  String? nnocheMensaje;
  int? nnocheConBaja;
  String? ultLider;
  String? actaDot;
  String? actaTotalSala;
  String? actaTotalBodega;
  String? actaUnidades;
  String? actaUnidadesTeorico;
  String? actaHoraLlegada;
  String? actaRevisionGrilla;
  String? actaFechaToma;
  String? actaNota1;
  String? actaNota2;
  String? actaNota3;
  dynamic actaEstandar;
  String? actaErrorSei;
  dynamic stats;
  String? nominaAnteriorFecha;
  dynamic nominaAnteriorTurno;
  List<NominaAnteriorStat>? nominaAnteriorStats;
  List<Region>? regiones;

  InventarioGeneral({
    this.invIdInventario,
    this.invFechaProgramadaF,
    this.invFechaProgramada,
    this.invFechaProgramadaDow,
    this.invEstadoPublicacion,
    this.invComentarios,
    this.invAuditoriaSmu,
    this.clienteIdCliente,
    this.clienteNombreCorto,
    this.localIdLocal,
    this.localCeco,
    this.localNombre,
    this.localIdFormato,
    this.localFormatoLocal,
    this.localProduccionSugerida,
    this.localComuna,
    this.localCutComuna,
    this.localRegion,
    this.localCutRegion,
    this.localDireccion,
    this.localHoraApertura,
    this.localHoraCierre,
    this.localTopeFechaConAuditoria,
    this.localRecintoCerrado,
    this.localIsMall,
    this.localIsFarma,
    this.localGmapLatitud,
    this.localGmapLongitud,
    this.storeDepartureTime,
    this.localLogistica,
    this.localComentarios,
    this.invIdJornada,
    this.invJornada,
    this.invStockTeorico,
    this.invFechaStock,
    this.invPromStock,
    this.invFechaStockAntigua,
    this.invPatentes,
    this.invPda,
    this.invUnidadesReales,
    this.invUnidadesTeorico,
    this.invEstadoArchivoFinal,
    this.invReporte,
    this.ndiaIdNomina,
    this.ndiaDotTotal,
    this.ndiaDotOperadores,
    this.ndiaTotalTitulares,
    this.ndiaTotalDadosBaja,
    this.ndiaTotalTitularesBaja,
    this.ndiaBloqueoDotacion,
    this.ndiaEstadoDotacion,
    this.ndiaIdLider,
    this.ndiaLider,
    this.ndiaHrLider,
    this.ndiaHrEquipo,
    this.ndiaIdSupervisor,
    this.ndiaSupervisor,
    this.ndiaIdCaptador1,
    this.ndiaCaptador1,
    this.ndiaRectificada,
    this.ndiaRectificaSistema,
    this.ndiaCaptadores,
    this.ndiaIdEstadoNomina,
    this.ndiaEstadoNomina,
    this.ndiaHabilitada,
    this.ndiaUrlNominaPago,
    this.ndiaCalificacionNomina,
    this.ndiaCantidadNuevos,
    this.ndiaConteoSugerido,
    this.ndiaStockSugerido,
    this.ndiaDiferenciaConteo,
    this.ndiaMensaje,
    this.ndiaConBaja,
    this.nnocheIdNomina,
    this.nnocheDotTotal,
    this.nnocheDotOperadores,
    this.nnocheTotalTitulares,
    this.nnocheTotalDadosBaja,
    this.nnocheTotalTitularesBaja,
    this.nnocheBloqueoDotacion,
    this.nnocheEstadoDotacion,
    this.nnocheIdLider,
    this.nnocheLider,
    this.nnocheHrLider,
    this.nnocheHrEquipo,
    this.nnocheIdSupervisor,
    this.nnocheSupervisor,
    this.nnocheIdCaptador1,
    this.nnocheCaptador1,
    this.nnocheRectificada,
    this.nnocheRectificaSistema,
    this.nnocheCaptadores,
    this.nnocheIdEstadoNomina,
    this.nnocheEstadoNomina,
    this.nnocheHabilitada,
    this.nnocheUrlNominaPago,
    this.nnocheCalificacionNomina,
    this.nnocheCantidadNuevos,
    this.nnocheConteoSugerido,
    this.nnocheStockSugerido,
    this.nnocheDiferenciaConteo,
    this.nnocheMensaje,
    this.nnocheConBaja,
    this.ultLider,
    this.actaDot,
    this.actaTotalSala,
    this.actaTotalBodega,
    this.actaUnidades,
    this.actaUnidadesTeorico,
    this.actaHoraLlegada,
    this.actaRevisionGrilla,
    this.actaFechaToma,
    this.actaNota1,
    this.actaNota2,
    this.actaNota3,
    this.actaEstandar,
    this.actaErrorSei,
    this.stats,
    this.nominaAnteriorFecha,
    this.nominaAnteriorTurno,
    this.nominaAnteriorStats,
    this.regiones,
  });

  factory InventarioGeneral.fromJson(Map<String, dynamic> json) {

    var invComentariosLista = json["inv_comentarios"] as List;
    List<InvComentario> listaComentarios = json["inv_comentarios"] == null ? [] : invComentariosLista.map((c) => InvComentario.fromJson(c)).toList();

    var localComentariosLista = json["local_comentarios"] as List;
    List<LocalComentario> listaLocalComentarios = json["local_comentarios"] == null ? [] : localComentariosLista.map((c) => LocalComentario.fromJson(c)).toList();

    var ndiaTotalTitularesLista = json["ndia_totalTitulares"] as List;
    List<NdiaTotalDadosBaja> listaNdiaTotalTitulares = json["ndia_totalTitulares"] == null ? [] : ndiaTotalTitularesLista.map((c) => NdiaTotalDadosBaja.fromJson(c)).toList();

    var ndiaTotalDadosBajaLista = json["ndia_totalDadosBaja"] as List;
    List<NdiaTotalDadosBaja> listaNdiaTotalDadosBaja = json["ndia_totalDadosBaja"] == null ? [] : ndiaTotalDadosBajaLista.map((c) => NdiaTotalDadosBaja.fromJson(c)).toList();

    var ndiaCaptadoresLista = json["ndia_captadores"] as List;
    List<Captador> listaNdiaCaptadores = json["ndia_captadores"] == null ? [] : ndiaCaptadoresLista.map((c) => Captador.fromJson(c)).toList();

    var nnocheTotalTitularesLista = json["nnoche_totalTitulares"] as List;
    List<NdiaTotalDadosBaja> listaNnocheTotalTitulares = json["nnoche_totalTitulares"] == null ? [] : nnocheTotalTitularesLista.map((c) => NdiaTotalDadosBaja.fromJson(c)).toList();

    var nnocheTotalDadosBajaLista = json["nnoche_totalDadosBaja"] as List;
    List<NdiaTotalDadosBaja> listaNnocheTotalDadosBaja = json["nnoche_totalDadosBaja"] == null ? [] : nnocheTotalDadosBajaLista.map((c) => NdiaTotalDadosBaja.fromJson(c)).toList();

    var nnocheCaptadoresLista = json["nnoche_captadores"] as List;
    List<Captador> listaNnocheCaptadores = json["nnoche_captadores"] == null ? [] : nnocheCaptadoresLista.map((c) => Captador.fromJson(c)).toList();

    var nominaAnteriorStatsLista = json["nomina_anterior_stats"] as List;
    List<NominaAnteriorStat> listaNominaAnteriorStats = json["nomina_anterior_stats"] == null ? [] : nominaAnteriorStatsLista.map((c) => NominaAnteriorStat.fromJson(c)).toList();

    var regionesLista = json["regiones"] as List;
    List<Region> listaRegiones = json["regiones"] == null ? [] : regionesLista.map((c) => Region.fromJson(c)).toList();

    return InventarioGeneral(
      invIdInventario: ProcesarDato.procesar(json["inv_idInventario"]),
      invFechaProgramadaF: json["inv_fechaProgramadaF"] ?? "",
      invFechaProgramada: json["inv_fechaProgramada"] ?? "",
      invFechaProgramadaDow: json["inv_fechaProgramadaDOW"] ?? "",
      invEstadoPublicacion: json["inv_estadoPublicacion"] ?? 0,
      invComentarios: listaComentarios,
      invAuditoriaSmu: json["inv_auditoriaSMU"] ?? 0,
      clienteIdCliente: json["cliente_idCliente"] is int ? json["cliente_idCliente"] : (json["cliente_idCliente"] is double ? json["cliente_idCliente"] : null),
      clienteNombreCorto: json["cliente_nombreCorto"] ?? "",
      localIdLocal: json["local_idLocal"] ?? 0,
      localCeco: json["local_ceco"] ?? "",
      localNombre: json["local_nombre"] ?? "",
      localIdFormato: json["local_idFormato"] ?? 0,
      localFormatoLocal: json["local_formatoLocal"] ?? "",
      localProduccionSugerida: json["local_produccionSugerida"] ?? "",
      localComuna: json["local_comuna"] ?? "",
      localCutComuna: json["local_cutComuna"] ?? 0,
      localRegion: json["local_region"] ?? "",
      localCutRegion: json["local_cutRegion"] ?? 0,
      localDireccion: json["local_direccion"] ?? "",
      localHoraApertura: json["local_horaApertura"] ?? "",
      localHoraCierre: json["local_horaCierre"] ?? "",
      localTopeFechaConAuditoria: json["local_topeFechaConAuditoria"] ?? "",
      localRecintoCerrado: json["local_recintoCerrado"] ?? 0,
      localIsMall: json["local_isMall"] ?? 0,
      localIsFarma: json["local_isFarma"] ?? 0,
      localGmapLatitud: json["local_gmap_latitud"] ?? "",
      localGmapLongitud: json["local_gmap_longitud"] ?? "",
      storeDepartureTime: json["store_departureTime"] ?? "",
      localLogistica: json["local_logistica"] ?? false,
      localComentarios: listaLocalComentarios,
      invIdJornada: json["inv_idJornada"] ?? 0,
      invJornada: json["inv_jornada"] ?? "",
      invStockTeorico: json["inv_stockTeorico"] ?? 0,
      invFechaStock: json["inv_fechaStock"] ?? "",
      invPromStock: json["inv_promStock"] ?? "",
      invFechaStockAntigua: json["inv_fechaStockAntigua"] ?? false,
      invPatentes: json["inv_patentes"] ?? 0,
      invPda: json["inv_pda"] ?? 0,
      invUnidadesReales: json["inv_unidadesReales"] ?? 0,
      invUnidadesTeorico: json["inv_unidadesTeorico"] ?? 0,
      invEstadoArchivoFinal: json["inv_estadoArchivoFinal"] ?? "",
      invReporte: json["inv_reporte"] ?? 0,
      ndiaIdNomina: json["ndia_idNomina"] ?? 0,
      ndiaDotTotal: json["ndia_dotTotal"] ?? 0,
      ndiaDotOperadores: json["ndia_dotOperadores"] ?? 0,
      ndiaTotalTitulares: listaNdiaTotalTitulares,
      ndiaTotalDadosBaja: listaNdiaTotalDadosBaja,
      ndiaTotalTitularesBaja: json["ndia_totalTitulares_baja"] ?? 0,
      ndiaBloqueoDotacion: json["ndia_bloqueoDotacion"] is List ? json["ndia_bloqueoDotacion"] : (json["ndia_bloqueoDotacion"] is bool ? json["ndia_bloqueoDotacion"] : null),
      ndiaEstadoDotacion: json["ndia_estadoDotacion"] ?? 0,
      ndiaIdLider: json["ndia_idLider"] ?? 0,
      ndiaLider: json["ndia_lider"] ?? "",
      ndiaHrLider: json["ndia_hrLider"] ?? "",
      ndiaHrEquipo: json["ndia_hrEquipo"] ?? "",
      ndiaIdSupervisor: json["ndia_idSupervisor"] ?? 0,
      ndiaSupervisor: json["ndia_supervisor"] ?? "",
      ndiaIdCaptador1: json["ndia_idCaptador1"],
      ndiaCaptador1: json["ndia_captador1"] ?? "",
      ndiaRectificada: json["ndia_rectificada"] ?? 0,
      ndiaRectificaSistema: json["ndia_rectificaSistema"] ?? 0,
      ndiaCaptadores: listaNdiaCaptadores,
      ndiaIdEstadoNomina: json["ndia_idEstadoNomina"] ?? 0,
      ndiaEstadoNomina: json["ndia_estadoNomina"] ?? "",
      ndiaHabilitada: json["ndia_habilitada"] ?? 0,
      ndiaUrlNominaPago: json["ndia_urlNominaPago"] ?? "",
      ndiaCalificacionNomina: json["ndia_calificacionNomina"] ?? 0,
      ndiaCantidadNuevos: json["ndia_cantidadNuevos"] is String ? json["ndia_cantidadNuevos"] : (json["ndia_cantidadNuevos"] is int ? json["ndia_cantidadNuevos"] : null),
      ndiaConteoSugerido: json["ndia_conteoSugerido"] ?? "",
      ndiaStockSugerido: json["ndia_stockSugerido"] ?? "",
      ndiaDiferenciaConteo: json["ndia_diferenciaConteo"] ?? "",
      ndiaMensaje: json["ndia_mensaje"] ?? "",
      ndiaConBaja: json["ndia_conBaja"] ?? 0,
      nnocheIdNomina: json["nnoche_idNomina"] ?? 0,
      nnocheDotTotal: json["nnoche_dotTotal"] ?? 0,
      nnocheDotOperadores: json["nnoche_dotOperadores"] ?? 0,
      nnocheTotalTitulares: listaNnocheTotalTitulares,
      nnocheTotalDadosBaja: listaNnocheTotalDadosBaja,
      nnocheTotalTitularesBaja: json["nnoche_totalTitulares_baja"] ?? 0,
      nnocheBloqueoDotacion: json["nnoche_bloqueoDotacion"] is List ? json["nnoche_bloqueoDotacion"] : json["nnoche_bloqueoDotacion"] is bool ? json["nnoche_bloqueoDotacion"] : null,
      nnocheEstadoDotacion: json["nnoche_estadoDotacion"] ?? 0,
      nnocheIdLider: json["nnoche_idLider"] ?? 0,
      nnocheLider: json["nnoche_lider"] ?? "",
      nnocheHrLider: json["nnoche_hrLider"] ?? "",
      nnocheHrEquipo: json["nnoche_hrEquipo"] ?? "",
      nnocheIdSupervisor: json["nnoche_idSupervisor"] ?? 0,
      nnocheSupervisor: json["nnoche_supervisor"] ?? "",
      nnocheIdCaptador1: json["nnoche_idCaptador1"] ,
      nnocheCaptador1: json["nnoche_captador1"] ?? "",
      nnocheRectificada: json["nnoche_rectificada"] ?? 0,
      nnocheRectificaSistema: json["nnoche_rectificaSistema"] ?? 0,
      nnocheCaptadores: listaNnocheCaptadores,
      nnocheIdEstadoNomina: json["nnoche_idEstadoNomina"] ?? 0,
      nnocheEstadoNomina: json["nnoche_estadoNomina"] ?? "",
      nnocheHabilitada: json["nnoche_habilitada"] ?? 0,
      nnocheUrlNominaPago: json["nnoche_urlNominaPago"] ?? "",
      nnocheCalificacionNomina: json["nnoche_calificacionNomina"] ?? 0,
      nnocheCantidadNuevos: json["nnoche_cantidadNuevos"] ?? 0,
      nnocheConteoSugerido: json["nnoche_conteoSugerido"] ?? "",
      nnocheStockSugerido: json["nnoche_stockSugerido"] ?? "",
      nnocheDiferenciaConteo: json["nnoche_diferenciaConteo"] ?? "",
      nnocheMensaje: json["nnoche_mensaje"] ?? "",
      nnocheConBaja: json["nnoche_conBaja"] ?? 0,
      ultLider: json["ult_lider"] ?? "",
      actaDot: json["acta_dot"] ?? "",
      actaTotalSala: json["acta_total_sala"] ?? "",
      actaTotalBodega: json["acta_total_bodega"] ?? "",
      actaUnidades: json["acta_unidades"] ?? "",
      actaUnidadesTeorico: json["acta_unidades_teorico"] ?? "",
      actaHoraLlegada: json["acta_hora_llegada"] ?? "",
      actaRevisionGrilla: json["acta_revision_grilla"] ?? "",
      actaFechaToma: json["acta_fecha_toma"] ?? "",
      actaNota1: json["acta_nota1"] ?? "",
      actaNota2: json["acta_nota2"] ?? "",
      actaNota3: json["acta_nota3"] ?? "",
      actaEstandar: json["acta_estandar"] is String ? json["acta_estandar"] : (json["acta_estandar"] is int ? json["acta_estandar"] : (json["acta_estandar"] is double ? json["acta_estandar"] : null)),
      actaErrorSei: json["acta_error_sei"] ?? "",
      stats: json["stats"] is String ? json["stats"] : (json["stats"] is bool ? json["stats"] : null),
      nominaAnteriorFecha: json["nomina_anterior_fecha"] ?? "",
      nominaAnteriorTurno: json["nomina_anterior_turno"] is String ? json["nomina_anterior_turno"] : null,
      nominaAnteriorStats: listaNominaAnteriorStats,
      regiones: listaRegiones,
    );

  }

  String? get obtenerNombreCliente {

    return clienteNombreCorto;

  }

  String? get obtenerCE {

    return localCeco;

  }

  String? get obtenerNombreLocal {

    return localNombre;

  }

  String? get obtenerDotacionTotal {

    return esNoche! ? "$nnocheDotTotal-$nnocheDotOperadores" : "$ndiaDotTotal-$ndiaDotOperadores";

  }

  String? get obtenerComuna {

    return localComuna;

  }

  String? get obtenerRegion {

    return localRegion;

  }

  String? get obtenerDireccion {

    return localDireccion;

  }

  String? get obtenerLider {

    return esNoche! ? nnocheLider : ndiaLider;

  }

  String? get obtenerHorarioLider {

    return esNoche! ? nnocheHrLider : ndiaHrLider;

  }

  String? get obtenerHorarioEquipo {

    return esNoche! ? nnocheHrEquipo : ndiaHrEquipo;

  }

  String? get obtenerHoraEgreso {

    return storeDepartureTime;

  }

  String? get obtenerPTT {

    return invPatentes.toString();

  }

  String? get obtenerPDA {

    return invPda.toString();

  }

  String? get obtenerStockTeorico {

    return NumberFormat("#,###", "es_ES").format(invStockTeorico);

  }

  String? get obtenerStockConteo {

    return NumberFormat("#,###", "es_ES").format(invUnidadesReales);

  }

  bool? get esNoche {

    return invJornada!.toLowerCase().contains("noche");

  }

  bool? get contieneDadosBaja {

    return esNoche! ? (nnocheTotalDadosBaja!.isNotEmpty ? true : false) : (ndiaTotalDadosBaja!.isNotEmpty ? true : false);

  }

  Map<String, dynamic> get obtenerEstadoNomina {

    final estadoNomina = {
      2: {"estado": "Pendiente", "fontColor": contieneDadosBaja! ? Colors.white : Colors.black ,"backgroundColor": contieneDadosBaja! ? Colors.black : Colors.amber.shade100},
      3: {"estado": "Aceptada", "fontColor": contieneDadosBaja! ? Colors.white : Colors.black ,"backgroundColor": contieneDadosBaja! ? Colors.black : Colors.green.shade100},
      4: {"estado": "Aprobada", "fontColor": contieneDadosBaja! ? Colors.white : Colors.black ,"backgroundColor": contieneDadosBaja! ? Colors.black : Colors.blue.shade50},
      5: {"estado": "Informada", "fontColor": contieneDadosBaja! ? Colors.white : Colors.black ,"backgroundColor": contieneDadosBaja! ? Colors.black : Colors.blue.shade100},
    };

    final estado = esNoche! ? estadoNomina[nnocheIdEstadoNomina] : estadoNomina[ndiaIdEstadoNomina];

    return estado ?? {"estado": "Pendiente", "color": Colors.amber.shade200};

  }

  Map<String, dynamic> get obtenerEstadoMensajeInventario {

    final mensajes = {
      "optimo": {"valor": "OP", "backgroundColor": Colors.green.shade300},
      "sobredotación": {"valor": "SD", "backgroundColor": Colors.blue.shade300},
      "sobredotación alta": {"valor": "SDA", "backgroundColor": Colors.blue.shade300},
      "precaución": {"valor": "PR", "backgroundColor": Colors.deepOrange.shade300},
      "peligro": {"valor": "PE", "backgroundColor": Colors.red.shade300},
    };

    final mensaje = esNoche! ? nnocheMensaje!.toLowerCase() : ndiaMensaje!.toLowerCase();

    final mensajesOrdenados = mensajes.keys.toList()..sort((a, b) => b.length.compareTo(a.length));
    
    final mensajeEncontrado = mensajesOrdenados.firstWhere(
      (clave) => mensaje.startsWith(clave),
      orElse: () => "desconocido",
    );

    return mensajes[mensajeEncontrado] ?? {"valor": "UNK", "backgroundColor": Colors.black};

  }

  List<Map<String, dynamic>> get obtenerTitulares {
    
    final List<Map<String, dynamic>> mensajes = [];

    final titulares = esNoche! ? nnocheTotalTitulares : ndiaTotalTitulares;
    final titularesBaja = esNoche! ? nnocheTotalDadosBaja : ndiaTotalDadosBaja;

    for (var titular in titulares!) {

      mensajes.add({
        "operador": titular,
        "colorEstadoOperador": titular.estadoAsistencia! < 3 ? Colors.red : Colors.green,
        "baja": false
      });

    }

    if (titularesBaja != null) {

      for (var titularBaja in titularesBaja) {

        mensajes.add({
          "operador": titularBaja,
          "colorEstadoOperador": Colors.red,
          "baja": true
        });

      }

    }

    return mensajes;

  }

  String? get obtenerMensajeInventario {

    return esNoche! ? nnocheMensaje : ndiaMensaje;

  }

  bool? get estadoInventarioVerde {

    if (esNoche!) {

      return nnocheTotalTitulares!.every((titular) => titular.estadoAsistencia! >= 3) ? true : false;

    } else {

      return ndiaTotalTitulares!.every((titular) => titular.estadoAsistencia! >= 3) ? true : false;

    }

  }

  double? get obtenerLocalLatitud {

    if (localGmapLatitud != null) {

      if (localGmapLatitud is String) {

        return double.tryParse(localGmapLatitud!);

      }

    }

    return null;

  }

  double? get obtenerLocalLongitud {

    if (localGmapLongitud != null) {

      if (localGmapLongitud is String) {

        return double.tryParse(localGmapLongitud!);

      }

    }

    return null;

  }

}

class InvComentario {

  int? id;
  String? texto;
  String? usuario;
  String? fecha;
  String? usuarioCompleto;
  bool? editable;

  InvComentario({
    this.id,
    this.texto,
    this.usuario,
    this.fecha,
    this.usuarioCompleto,
    this.editable,
  });

  factory InvComentario.fromJson(Map<String, dynamic> json) {

    return InvComentario(
      id: json["id"] ?? 0,
      texto: json["texto"] ?? "",
      usuario: json["usuario"] ?? "",
      fecha: json["fecha"] ?? "",
      usuarioCompleto: json["usuario_completo"] ?? "",
      editable: json["editable"] ?? false
    );

  }

}

class LocalComentario {

  int? id;
  int? idUser;
  String? texto;
  String? usuario;
  String? fecha;
  String? usuarioCompleto;
  int? validado;

  LocalComentario({
    this.id,
    this.idUser,
    this.texto,
    this.usuario,
    this.fecha,
    this.usuarioCompleto,
    this.validado,
  });

  factory LocalComentario.fromJson(Map<String, dynamic> json) {

    return LocalComentario(
      id: json["id"] ?? 0,
      idUser: json["id_user"] ?? 0,
      texto: json["texto"] ?? "",
      usuario: json["usuario"] ?? "",
      fecha: json["fecha"] ?? "",
      usuarioCompleto: json["usuario_completo"] ?? "",
      validado: json["validado"] ?? 0,
    );

  }

}

class Captador {

  int? idUsuario;
  String? nombre;
  int? asignados;
  List<int>? regiones;
  List<int>? regionesActuales;

  Captador({
    this.idUsuario,
    this.nombre,
    this.asignados,
    this.regiones,
    this.regionesActuales,
  });

  factory Captador.fromJson(Map<String, dynamic> json) {

    var regionesLista = json["regiones"] == null ? [] : json["regiones"] as List;
    List<int> listaRegiones = json["regiones"] == null ? [] : regionesLista.map((r) => r as int).toList();

    var regionesActualesLista = json["regiones_actuales"] == null ? [] : json["regiones_actuales"] as List;
    List<int> listaRegionesActuales = json["regiones_actuales"] == null ? [] : regionesActualesLista.map((r) => r as int).toList();

    return Captador(
      idUsuario: json["idUsuario"] ?? 0,
      nombre: json["nombre"] ?? "",
      asignados: json["asignados"] ?? 0,
      regiones: listaRegiones,
      regionesActuales: listaRegionesActuales
    );

  }

}

class NdiaTotalDadosBaja {

  String? nombreCorto;
  String? comuna;
  int? experienciaComoOperador;
  int? unidadesContadas;
  int? unidadesContadasReal;
  dynamic error;
  int? bloqueado;
  bool? bloqueadoCliente;
  int? estadoAsistencia;
  int? captador;

  NdiaTotalDadosBaja({
    this.nombreCorto,
    this.comuna,
    this.experienciaComoOperador,
    this.unidadesContadas,
    this.unidadesContadasReal,
    this.error,
    this.bloqueado,
    this.bloqueadoCliente,
    this.estadoAsistencia,
    this.captador,
  });

  factory NdiaTotalDadosBaja.fromJson(Map<String, dynamic> json) {

    return NdiaTotalDadosBaja(
      nombreCorto: json["nombreCorto"] ?? "",
      comuna: json["comuna"] ?? "",
      experienciaComoOperador: json["experienciaComoOperador"] ?? 0,
      unidadesContadas: json["unidadesContadas"] ?? 0,
      unidadesContadasReal: json["unidadesContadasReal"] ?? 0,
      error: json["error"] is int ? json["error"] : (json["error"] is double ? json["error"] : (json["error"] is String ? json["error"] : null)),
      bloqueado: json["bloqueado"] ?? 0,
      bloqueadoCliente: json["bloqueadoCliente"] ?? false,
      estadoAsistencia: json["estado_asistencia"] ?? 0,
      captador: json["captador"] ?? 0
    );

  }

  String? get obtenerNombreCorto {

    return nombreCorto;

  }

  String? get obtenerComuna {

    return comuna;

  }

  String? get obtenerExp {

    return experienciaComoOperador.toString();

  }

  String? get obtenerError {

    return formatearPorcentaje(error, 2);

  }

  String? get obtenerUnidadesSugeridas {

    return NumberFormat("#,###", "es_ES").format(unidadesContadas);

  }

  String? get obtenerUnidadesReal {

    return NumberFormat("#,###", "es_ES").format(unidadesContadasReal);

  }

  String formatearPorcentaje(dynamic porcentaje, int cantidadDecimal) {

    if (porcentaje is String || porcentaje is int || porcentaje is double) {

      return "${double.parse(porcentaje.toString().replaceAll("%", "")).toStringAsFixed(cantidadDecimal)} %";
      
    }

    return "";

  }

}

class NominaAnteriorStat {

  String? operador;
  int? conteo;
  dynamic error;

  NominaAnteriorStat({
    this.operador,
    this.conteo,
    this.error,
  });

  factory NominaAnteriorStat.fromJson(Map<String, dynamic> json) {

    return NominaAnteriorStat(
      operador: json["operador"] ?? "",
      conteo: json["conteo"] ?? 0,
      error: json["error"] is int ? json["error"] : (json["error"] is double ? json["error"] : null)
    );

  }

}

class Region {
  
  int? cutRegion;
  String? nombre;
  String? numero;

  Region({
    this.cutRegion,
    this.nombre,
    this.numero,
  });

  factory Region.fromJson(Map<String, dynamic> json) {

    return Region(
      cutRegion: json["cutRegion"] ?? 0,
      nombre: json["nombre"] ?? "",
      numero: json["numero"] ?? "",
    );

  }

}

class ProcesarDato {

  static dynamic procesar(dynamic dato) {

    return (dato is int) ? dato : (dato is double) ? dato : (dato is String) ? dato : null;

  }

}
