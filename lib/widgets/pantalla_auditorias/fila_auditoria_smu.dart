import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sigsei/helpers/indicador_deficiente.dart';
import 'package:sigsei/models/auditoria_smu.dart';
import 'package:sigsei/themes/tema.dart';

class FilaAuditoriaSmu extends StatefulWidget {

  final AuditoriaSmu auditoriaSmu;

  const FilaAuditoriaSmu({
    super.key,
    required this.auditoriaSmu
  });

  @override
  State<FilaAuditoriaSmu> createState() => _FilaAuditoriaSmuState();

}

class _FilaAuditoriaSmuState extends State<FilaAuditoriaSmu> {

  bool mostrarResumenAuditoria = true;
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

    Widget estadoIndicador(AuditoriaSmu auditoriaSmu) {

      return Icon(
        Icons.circle,
        size: 7,
        color: auditoriaSmu.obtenerHoraInicio != "-" || auditoriaSmu.obtenerHoraInicio!.isEmpty ? Colors.green : Tema.primaryLight,
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
                child: estadoIndicador(widget.auditoriaSmu)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.auditoriaSmu.obtenerNumero!, esBold: true, color: Tema.primary)
              ),
              Expanded(
                flex: 2,
                child: formatearCelda(widget.auditoriaSmu.obtenerNombreCorto!, alineacion: TextAlign.start)
              ),
              Expanded(
                flex: 2,
                child: formatearCelda(widget.auditoriaSmu.obtenerAuditorCorto!, alineacion: TextAlign.start)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.auditoriaSmu.obtenerPorcentajeConteo!, esDeficiente: IndicadorDeficiente.esConteoDeficiente(widget.auditoriaSmu.obtenerPorcentajeConteo!))
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.auditoriaSmu.obtenerPorcentajeChecklist!, esDeficiente: IndicadorDeficiente.esChecklistDeficiente(widget.auditoriaSmu.obtenerPorcentajeChecklist!))
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(7),
                          child: Material(
                            color: mostrarResumenAuditoria ? Colors.deepPurple.shade50 : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                              side: BorderSide(
                                color: Tema.secondaryLight,
                                width: 1.5
                              )
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.assessment_outlined,
                                    size: 10,
                                    color: Colors.deepPurple,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Resumen",
                                    style: TextStyle( 
                                      fontSize: 9
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              mostrarResumenAuditoria = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (mostrarResumenAuditoria)
              ContenidoResumenAuditoria(auditoriaSmu: widget.auditoriaSmu),
            BotonesDescargarArchivosSmu(auditoriaSmu: widget.auditoriaSmu),
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

class ContenidoResumenAuditoria extends StatelessWidget {

  final AuditoriaSmu auditoriaSmu;
  
  const ContenidoResumenAuditoria({
    super.key,
    required this.auditoriaSmu
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
                color: colorPrimario ? Colors.deepPurple : (esDeficiente ? Colors.red : Colors.black)
              )
            ),
          );
          
        }).toList(),
      );

    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: Colors.deepPurple.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
          side: BorderSide(
            color: Tema.secondaryLight,
            width: 1.5
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              buildRow(["Auditoría - N° ${auditoriaSmu.obtenerNumero}", DateFormat("EEEE d MMM yyyy", "es_ES").format(DateTime.parse(auditoriaSmu.obtenerFecha!))], esBold: true),
              Divider(color: Colors.deepPurple.shade100),
              buildRow(["Local", auditoriaSmu.obtenerNombre!], colorPrimario: true, esBold: true),
              buildRow(["Auditor", auditoriaSmu.obtenerAuditor!]),
              buildRow(["Región", auditoriaSmu.obtenerRegion!]),
              buildRow(["Comuna", auditoriaSmu.obtenerComuna!]),
              buildRow(["Dirección", auditoriaSmu.obtenerDireccion!]),
              Divider(color: Colors.deepPurple.shade100),
              buildRow(["Hora Inicio", auditoriaSmu.obtenerHoraInicio!]),
              buildRow(["Hora Termino", auditoriaSmu.obtenerHoraTermino!]),
              buildRow(["Tiempo Proceso", auditoriaSmu.obtenerTiempoProceso!]),
              Divider(color: Colors.deepPurple.shade100),
              buildRow(["Conteo", auditoriaSmu.obtenerPorcentajeConteo!], esBold: true, esDeficiente: IndicadorDeficiente.esConteoDeficiente(auditoriaSmu.obtenerPorcentajeConteo!)),
              buildRow(["Checklist", auditoriaSmu.obtenerPorcentajeChecklist!], esBold: true, esDeficiente: IndicadorDeficiente.esChecklistDeficiente(auditoriaSmu.obtenerPorcentajeChecklist!)),
            ],
          ),
        ),
      ),
    );

  }

}

class BotonesDescargarArchivosSmu extends StatefulWidget {

  final AuditoriaSmu auditoriaSmu;

  const BotonesDescargarArchivosSmu({
    super.key,
    required this.auditoriaSmu,
  });

  @override
  State<BotonesDescargarArchivosSmu> createState() => _BotonesDescargarArchivosSmuState();

}

class _BotonesDescargarArchivosSmuState extends State<BotonesDescargarArchivosSmu> {

  double progreso = 0.0;
  bool descargaIniciada = false;
  String archivoDescargando = "";

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Align(
        alignment: Alignment.centerRight,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
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
                  child: Material(
                    color: widget.auditoriaSmu.obtenerMm60! ? Colors.green.shade50 : Colors.red.shade50,                    
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                      side: BorderSide(
                        color: Tema.secondaryLight,
                        width: 1.5
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            widget.auditoriaSmu.obtenerMm60! ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
                            size: 10,
                            color: widget.auditoriaSmu.obtenerMm60! ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "MM60",
                            style: TextStyle(
                              fontSize: 9,
                            ),
                          ),
                        ],
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
                  child: Material(
                    color: widget.auditoriaSmu.obtenerZmig43! ? Colors.green.shade50 : Colors.red.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                      side: BorderSide(
                        color: Tema.secondaryLight,
                        width: 1.5
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            widget.auditoriaSmu.obtenerZmig43! ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
                            size: 10,
                            color: widget.auditoriaSmu.obtenerZmig43! ? Colors.green : Colors.red,
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
            ],
          ),
        ),
      ),
    );

  }

}
