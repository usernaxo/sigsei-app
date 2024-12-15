import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/helpers/indicador_deficiente.dart';
import 'package:sigsei/models/auditoria_bodega.dart';
import 'package:sigsei/providers/proveedor_estado.dart';
import 'package:sigsei/themes/tema.dart';

class FilaAuditoriaBodega extends StatefulWidget {

  final AuditoriaBodega auditoriaBodega;

  const FilaAuditoriaBodega({
    super.key,
    required this.auditoriaBodega
  });

  @override
  State<FilaAuditoriaBodega> createState() => _FilaAuditoriaBodegaState();

}

class _FilaAuditoriaBodegaState extends State<FilaAuditoriaBodega> {

  bool mostrarResumen = true;
  bool mostrarDiferencias = false;
  bool mostrarExcluyente = false;
  bool filaExpandida = false;

  @override
  Widget build(BuildContext context) {

    Text formatearCelda(String cadena, {alineacion = TextAlign.center, esBold = false, esDeficiente = false, color = Colors.black}) {

      return Text(
        cadena,
        textAlign: alineacion,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 9,
          color: esDeficiente ? Colors.red : color,
          fontWeight: esBold || esDeficiente ? FontWeight.bold : FontWeight.normal
        ),
      );

    }

    Widget estadoAuditoriaBodega(AuditoriaBodega auditoriaBodega) {

      return Icon(
        Icons.circle,
        size: 7,
        color: auditoriaBodega.obtenerEstado
      );

    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
          side: BorderSide(
            color: Tema.primaryLight
          )
        ),
        margin: const EdgeInsets.all(3),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          minTileHeight: 10,
          childrenPadding: EdgeInsets.zero,
          showTrailingIcon: false,
          title: Row(
            children: [
              Expanded(
                flex: 1,
                child: estadoAuditoriaBodega(widget.auditoriaBodega)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.auditoriaBodega.obtenerNumero!, esBold: true, color: Tema.primary)
              ),
              Expanded(
                flex: 2,
                child: formatearCelda(widget.auditoriaBodega.obtenerNombreCorto!, alineacion: TextAlign.start)
              ),
              Expanded(
                flex: 2,
                child: formatearCelda(widget.auditoriaBodega.obtenerAuditorCorto!, alineacion: TextAlign.start)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.auditoriaBodega.obtenerPorcentajeGeneralAvance!)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.auditoriaBodega.obtenerPorcentajeGeneralError!, esDeficiente: IndicadorDeficiente.esErrorAbsDeficiente(widget.auditoriaBodega.obtenerPorcentajeGeneralError!))
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(7),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: ColoredBox(
                        color: mostrarResumen ? Colors.blue.shade100 : Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.assessment_outlined,
                                size: 10,
                                color: Tema.primary,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                "Resumen",
                                style: TextStyle( 
                                  fontSize: 9
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        mostrarResumen = true;
                        mostrarDiferencias = false;
                        mostrarExcluyente = false;
                      });
                    },
                  ),
                  if (widget.auditoriaBodega.obtenerUltimoIndicadorAvance() != null)
                    InkWell(
                      borderRadius: BorderRadius.circular(7),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: ColoredBox(
                          color: mostrarDiferencias ? Colors.black12 : Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.timeline_rounded,
                                  size: 10,
                                  color: Tema.primary,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "Diferencias",
                                  style: TextStyle( 
                                    fontSize: 9
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          mostrarDiferencias = true;
                          mostrarResumen = false;
                          mostrarExcluyente = false;
                        });
                      },
                    ),
                  if (widget.auditoriaBodega.obtenerEstadoCierre != null)
                    InkWell(
                      borderRadius: BorderRadius.circular(7),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: ColoredBox(
                          color: mostrarExcluyente ? Colors.black12 : Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline_rounded,
                                  size: 10,
                                  color: Tema.primary,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text.rich(
                                  style: const TextStyle(
                                    fontSize: 9
                                  ),
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Excluyente: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                      TextSpan(
                                        text: widget.auditoriaBodega.obtenerEstadoCierre,
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                    ]
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          mostrarExcluyente = true;
                          mostrarResumen = false;
                          mostrarDiferencias = false;
                        });
                      },
                    ),
                ],
              ),
            ),
            if (mostrarResumen)
              ContenidoResumen(auditoriaBodega: widget.auditoriaBodega),
            if (mostrarDiferencias)
              ContenidoDiferencias(auditoriaBodega: widget.auditoriaBodega),
            if (mostrarExcluyente)
              ContenidoExcluyente(auditoriaBodegaId: widget.auditoriaBodega.auditoria!.id!, estadoExcluyente: widget.auditoriaBodega.estadoCierre!),
            BotonesDescargarArchivosBodega(auditoriaBodega: widget.auditoriaBodega),
          ],
          onExpansionChanged: (value) {

            setState(() {

              filaExpandida = value;

            });
            
          },
        ),
      ),
    );

  }

}

class ContenidoResumen extends StatelessWidget {

  final AuditoriaBodega auditoriaBodega;
  
  const ContenidoResumen({
    super.key,
    required this.auditoriaBodega
  });

  @override
  Widget build(BuildContext context) {

    Widget buildRow(List<String> listaCadenas, {bool esBold = false, bool esDeficiente = false, bool colorPrimario = false}) {

      return Row(
        children: listaCadenas.asMap().entries.map((entry) {

          final cadena = entry.value;
          final indice = entry.key;

          return Expanded(
            flex: indice == 0 ? 1 : 2,
            child: Text(
              cadena,
              textAlign: indice == 0 ? TextAlign.start : TextAlign.end,
              style: TextStyle(
                fontSize: 9,
                fontWeight: esBold || esDeficiente ? FontWeight.bold : FontWeight.normal,
                color: colorPrimario ? Tema.primary : (esDeficiente ? Colors.red : Colors.black)
              )
            ),
          );
          
        }).toList(),
      );

    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Column(
          children: [
            buildRow(["Auditoría - N° ${auditoriaBodega.obtenerNumero}", DateFormat("EEEE d MMM yyyy", "es_ES").format(DateTime.parse(auditoriaBodega.obtenerFecha!))], esBold: true),
            Divider(color: Colors.blue.shade200),
            buildRow(["Local", auditoriaBodega.obtenerNombre!], colorPrimario: true, esBold: true),
            buildRow(["Auditor", auditoriaBodega.obtenerAuditor!]),
            buildRow(["Región", auditoriaBodega.obtenerRegion!]),
            buildRow(["Comuna", auditoriaBodega.obtenerComuna!]),
            buildRow(["Dirección", auditoriaBodega.obtenerDireccion!]),
            Divider(color: Colors.blue.shade200),
            buildRow(["Avance General", auditoriaBodega.obtenerPorcentajeGeneralAvance!]),
            buildRow(["Error Unidad ABS", auditoriaBodega.obtenerPorcentajeGeneralError!], esDeficiente: IndicadorDeficiente.esErrorAbsDeficiente(auditoriaBodega.obtenerPorcentajeGeneralError!)),
            buildRow(["Error Cierre", auditoriaBodega.obtenerPorcentajeError!]),
            buildRow(["Hora Cierre", auditoriaBodega.obtenerHoraCierre!]),
            Divider(color: Colors.blue.shade200),
            buildRow(["Registro", auditoriaBodega.obtenerRegistro!], esBold: true),
          ],
        ),
      ),
    );

  }

}

class ContenidoDiferencias extends StatefulWidget {

  final AuditoriaBodega auditoriaBodega;
  
  const ContenidoDiferencias({
    super.key,
    required this.auditoriaBodega
  });

  @override
  State<ContenidoDiferencias> createState() => _ContenidoDiferenciasState();

}

class _ContenidoDiferenciasState extends State<ContenidoDiferencias> {

  double tamanoLetra = 8;
  double valorSlider = 8;

  @override
  Widget build(BuildContext context) {

    Widget buildRow(List<String> listaCadenas, {bool esBold = false, bool esPrimeraSeccion = false, esFilaDeTabla = false}) {

      return Padding(
        padding: esFilaDeTabla ? const EdgeInsets.all(1) : EdgeInsets.zero,
        child: Row(
          children: listaCadenas.asMap().entries.map((entry) {
        
            final cadena = entry.value;
            final indice = entry.key;
        
            return Expanded(
              flex: esPrimeraSeccion ? 1 : (indice == 3 ? 4 : (indice >= 2 && indice <= 7 ? 2 : 1)),
              child: Text(
                cadena,
                textAlign: esPrimeraSeccion ? (indice < 1 ? TextAlign.start : TextAlign.end) : (indice < 4 ? TextAlign.start : TextAlign.end),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: tamanoLetra,
                  fontWeight: esBold ? FontWeight.bold : FontWeight.normal,
                  color: Colors.white
                )
              ),
            );
            
          }).toList(),
        ),
      );

    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Column(
          children: [
            buildRow(["Fecha", widget.auditoriaBodega.auditoria!.fechaProgramada!], esPrimeraSeccion: true),
            buildRow(["Avance General", widget.auditoriaBodega.obtenerPorcentajeGeneralAvance!], esPrimeraSeccion: true),
            buildRow(["Error Unidad ABS", widget.auditoriaBodega.obtenerPorcentajeGeneralError!], esPrimeraSeccion: true),
            buildRow(["PTT Cantidad", widget.auditoriaBodega.ultimoIndicadorAvance!.obtenerCantidadPatentes!], esPrimeraSeccion: true),
            buildRow(["PTT Avance", widget.auditoriaBodega.ultimoIndicadorAvance!.obtenerAvancePatentes!], esPrimeraSeccion: true),
            const Divider(color: Colors.white),
            buildRow(["#", "PTT", "SKU", "Descripción", "ZMIG", "SEI", "Dif. U", "Val. A"], esBold: true, esFilaDeTabla: true),
            for (var detalle in widget.auditoriaBodega.obtenerDetallesAvance()!.asMap().entries)
              buildRow([(detalle.key + 1).toString(), detalle.value.obtenerPatente!, detalle.value.obtenerSku!, detalle.value.obtenerDescripcion!, detalle.value.obtenerConteoZmig!, detalle.value.obtenerConteoSei!, detalle.value.obtenerDiferenciaUnidades!, detalle.value.obtenerValorAjuste!], esFilaDeTabla: true),
            const Divider(color: Colors.white),
            buildRow(["Total", "", "", "", widget.auditoriaBodega.ultimoIndicadorAvance!.obtenerTotalZmig!, widget.auditoriaBodega.ultimoIndicadorAvance!.obtenerTotalSei!, widget.auditoriaBodega.ultimoIndicadorAvance!.obtenerTotalDiferenciaUnidades!, widget.auditoriaBodega.ultimoIndicadorAvance!.obtenerTotalValorAjuste!], esBold: true),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.format_size_rounded,
                    size: 10,
                  ),
                  Expanded(
                    child: Slider(
                      value: valorSlider,
                      min: 5,
                      max: 10,
                      divisions: 5,
                      label: valorSlider.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          valorSlider = value;
                        });
                      },
                      onChangeEnd: (value) {
                        setState(() {
                          tamanoLetra = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

  }

}

class ContenidoExcluyente extends StatefulWidget {

  final int auditoriaBodegaId;
  final String estadoExcluyente;
  
  const ContenidoExcluyente({
    super.key,
    required this.auditoriaBodegaId,
    required this.estadoExcluyente
  });

  @override
  State<ContenidoExcluyente> createState() => _ContenidoExcluyenteState();

}

class _ContenidoExcluyenteState extends State<ContenidoExcluyente> {

  late Future<Excluyente?> excluyente;

  double tamanoLetra = 8;
  double valorSlider = 8;

  @override
  void initState() {

    super.initState();

    final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

    excluyente = proveedorEstado.obtenerExcluyenteAuditoriaBodega(widget.auditoriaBodegaId);

  }

  @override
  Widget build(BuildContext context) {

    Widget buildRow(List<String> listaCadenas, {bool esBold = false, bool esExcluido = false, color = Colors.black, esFilaDeTabla = false, esIcono = false}) {

      return Padding(
        padding: esFilaDeTabla ? const EdgeInsets.all(1) : EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: esExcluido ? Colors.red.shade50 : Colors.transparent,
          ),
          child: Row(
            children: listaCadenas.asMap().entries.map((entry) {
          
              final cadena = entry.value;
              final indice = entry.key;
          
              return Expanded(
                flex: indice == 3 ? 4 : (indice >= 2 && indice <= 7 ? 2 : 1),
                child: indice == listaCadenas.length - 1 && esIcono ? Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.circle,
                      size: 5,
                      color: esExcluido ? Colors.red.shade300 : Tema.primaryLight,
                    ),
                  ),
                ) : Text(
                  cadena,
                  textAlign: indice < 4 ? TextAlign.start : TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: tamanoLetra,
                    fontWeight: esBold ? FontWeight.bold : FontWeight.normal,
                    color: color
                  )
                )
              );
              
            }).toList(),
          ),
        ),
      );

    }

    return FutureBuilder(
      future: excluyente,
      builder: (context, AsyncSnapshot<Excluyente?> snapshot) {
    
        if (snapshot.connectionState == ConnectionState.waiting) {
    
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    color: Tema.primary,
                    strokeWidth: 1,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  "Obteniendo Excluyente",
                  style: TextStyle(
                    fontSize: 9
                  ),
                )
              ],
            ),
          );
    
        } else if (snapshot.hasError) {
    
          return const Center(child: Text("Error"));
    
        } else if (!snapshot.hasData) {
    
          return const Center(child: Text("No Existe Excluyente"));
    
        } else {

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Excluyente - CE ${snapshot.data!.local!.numero}",
                          style: TextStyle(
                            fontSize: tamanoLetra,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${widget.estadoExcluyente} por ${snapshot.data!.resumenCierre!.usuario}",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: tamanoLetra,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Tema.primaryLight),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Error: ",
                          style: TextStyle(
                            color: Tema.primary,
                            fontSize: tamanoLetra,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text.rich(
                            style: TextStyle(
                              fontSize: tamanoLetra
                            ),
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Unidad ABS: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                TextSpan(
                                  text: snapshot.data!.obtenerTotalUnidadAbs
                                )
                              ]
                            )
                          ),
                          const SizedBox(width: 5),
                          Text.rich(
                            style: TextStyle(
                              fontSize: tamanoLetra
                            ),
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Valor ABS: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                TextSpan(
                                  text: snapshot.data!.obtenerTotalValorAbs,
                                )
                              ]
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Total Muestra: ",
                          style: TextStyle(
                            color: Tema.primary,
                            fontSize: tamanoLetra,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text.rich(
                            style: TextStyle(
                              fontSize: tamanoLetra
                            ),
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Unidad: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                TextSpan(
                                  text: snapshot.data!.generalConteo!.obtenerTotalMuestraUnidades,
                                )
                              ]
                            )
                          ),
                          const SizedBox(width: 5),
                          Text.rich(
                            style: TextStyle(
                              fontSize: tamanoLetra
                            ),
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Valor: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                TextSpan(
                                  text: snapshot.data!.generalConteo!.obtenerTotalMuestraValorizada,
                                )
                              ]
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Observación: ",
                          style: TextStyle(
                            color: Tema.primary,
                            fontSize: tamanoLetra,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              snapshot.data!.obtenerObservacion!,
                              style: TextStyle(
                                fontSize: tamanoLetra
                              ),
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                  Divider(color: Tema.primaryLight),
                  buildRow(["#", "PTT", "SKU", "Descripción", "ZMIG", "SEI", "Dif. U", "Excluido"], esBold: true, color: Tema.primary, esFilaDeTabla: true),
                  for (var detalleConteo in snapshot.data!.obtenerDetalleConteo!.asMap().entries)
                    buildRow([(detalleConteo.key + 1).toString(), detalleConteo.value.obtenerPatente!, detalleConteo.value.obtenerSku!, detalleConteo.value.obtenerDescripcion!, detalleConteo.value.obtenerConteoZmig!, detalleConteo.value.obtenerConteoSei!, detalleConteo.value.obtenerDiferenciaUnidades!, ""], esExcluido: detalleConteo.value.esExcluido!, esIcono: true, esFilaDeTabla: true),
                  Divider(color: Tema.primaryLight),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.format_size_rounded,
                          size: 10,
                        ),
                        Expanded(
                          child: Slider(
                            value: valorSlider,
                            min: 5,
                            max: 10,
                            divisions: 5,
                            label: valorSlider.round().toString(),
                            onChanged: (value) {
                              setState(() {
                                valorSlider = value;
                              });
                            },
                            onChangeEnd: (value) {
                              setState(() {
                                tamanoLetra = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
    
        }
    
      },
    );

  }

}

class BotonesDescargarArchivosBodega extends StatefulWidget {

  final AuditoriaBodega auditoriaBodega;

  const BotonesDescargarArchivosBodega({
    super.key,
    required this.auditoriaBodega,
  });

  @override
  State<BotonesDescargarArchivosBodega> createState() => _BotonesDescargarArchivosBodegaState();

}

class _BotonesDescargarArchivosBodegaState extends State<BotonesDescargarArchivosBodega> {

  double progreso = 0.0;
  bool descargaIniciada = false;
  String archivoDescargando = "";

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (descargaIniciada)
            Expanded(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Column(
                      children: [
                        ColoredBox(
                          color: Colors.black12,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.file_download_rounded,
                                  size: 10,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Descargando $archivoDescargando ${progreso.toStringAsFixed(0)} %",
                                  style: const TextStyle(fontSize: 9),
                                ),
                              ],
                            ),
                          ),
                        ),
                        LinearProgressIndicator(
                          value: progreso / 100,
                          color: Tema.primaryLight,
                          valueColor: const AlwaysStoppedAnimation(Colors.green),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (!descargaIniciada)
            InkWell(
              borderRadius: BorderRadius.circular(7),
              onTap: (){},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: ColoredBox(
                  color: widget.auditoriaBodega.obtenerPatente! ? Colors.green.shade100 : Colors.red.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          widget.auditoriaBodega.obtenerPatente! ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
                          size: 10,
                          color: widget.auditoriaBodega.obtenerPatente! ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "Patentes",
                          style: TextStyle(
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (!descargaIniciada)
            const SizedBox(width: 5),
          if (!descargaIniciada)
            InkWell(
              borderRadius: BorderRadius.circular(7),
              onTap: (){},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: ColoredBox(
                  color: widget.auditoriaBodega.obtenerZmig43! ? Colors.green.shade100 : Colors.red.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          widget.auditoriaBodega.obtenerZmig43! ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
                          size: 10,
                          color: widget.auditoriaBodega.obtenerZmig43! ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "ZMIG43",
                          style: TextStyle(
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (!descargaIniciada)
            const SizedBox(width: 5),
          if (!descargaIniciada)
            InkWell(
              borderRadius: BorderRadius.circular(7),
              onTap: (){},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: ColoredBox(
                  color: widget.auditoriaBodega.obtenerMuestra! ? Colors.green.shade100 : Colors.red.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          widget.auditoriaBodega.obtenerMuestra! ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
                          size: 10,
                          color: widget.auditoriaBodega.obtenerMuestra! ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "Muestra",
                          style: TextStyle(
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),      
        ],
      ),
    );

  }

}
