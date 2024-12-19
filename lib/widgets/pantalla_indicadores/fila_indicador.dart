import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/helpers/indicador_deficiente.dart';
import 'package:sigsei/helpers/snackbar_mensaje.dart';
import 'package:sigsei/models/indicador.dart';
import 'package:sigsei/providers/proveedor_estado.dart';
import 'package:sigsei/themes/tema.dart';

class FilaIndicador extends StatefulWidget {

  final Indicador indicador;

  const FilaIndicador({
    super.key,
    required this.indicador
  });

  @override
  State<FilaIndicador> createState() => _FilaIndicadorState();

}

class _FilaIndicadorState extends State<FilaIndicador> {

  bool mostrarAvance = false;
  bool mostrarResumen = true;
  bool mostrarOperadores = false;
  bool mostrarEstadoAmarillo = false;
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

    bool indicadorRojo(Indicador indicador) {

      String horasIg = indicador.obtenerIgHours!;
      String notaPromedio = indicador.obtenerAvgScores!;
      String errorSei = indicador.obtenerSeiError!;
      String estandarSei = indicador.obtenerSeiStandard!;
      String varianza = indicador.obtenerVarianza!;

      if (IndicadorDeficiente.esHorasIgDeficiente(horasIg) || IndicadorDeficiente.esNotaPromedioDeficiente(notaPromedio) || IndicadorDeficiente.esErrorSeiDeficiente(errorSei) || IndicadorDeficiente.esEstandarSeiDeficiente(estandarSei) || IndicadorDeficiente.esVarianzaDeficiente(varianza)) {

        return true;

      }

      return false;

    }

    bool indicadorAmarillo(Indicador indicador) {

      if (indicador.indicator == null || indicador.leader!.toLowerCase().contains("suspendido")) {

        return true;

      }

      return false;

    }

    Widget estadoIndicador(Indicador indicador) {

      return Icon(
        Icons.circle,
        size: 7,
        color: indicadorAmarillo(indicador) ? Colors.yellow : (indicadorRojo(indicador) ? Colors.red : Colors.green),
      );

    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: Card(
            elevation: 0,
            color: widget.indicador.obtenerEsDia! ? Colors.amber.shade50 : null,
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
                    child: estadoIndicador(widget.indicador)
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda(widget.indicador.obtenerNombreCliente!, esBold: true, color: Tema.primary)
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda(widget.indicador.obtenerCE!, alineacion:  TextAlign.right, esBold: true),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 2,
                    child: formatearCelda(widget.indicador.obtenerNombreLocalCorto!, alineacion:  TextAlign.left)
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda(widget.indicador.obtenerAvgScores!, esDeficiente: IndicadorDeficiente.esNotaPromedioDeficiente(widget.indicador.obtenerAvgScores!))
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda(widget.indicador.obtenerVarianza!, esDeficiente: IndicadorDeficiente.esVarianzaDeficiente(widget.indicador.obtenerVarianza!))
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda(widget.indicador.obtenerSeiError!, esDeficiente: IndicadorDeficiente.esErrorSeiDeficiente(widget.indicador.obtenerSeiError!))
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda(widget.indicador.obtenerSeiStandard!, esDeficiente: IndicadorDeficiente.esEstandarSeiDeficiente(widget.indicador.obtenerSeiStandard!))
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
                          if (indicadorAmarillo(widget.indicador))
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(7),
                                onTap: () {
                                  setState(() {
                                    mostrarEstadoAmarillo = true;
                                    mostrarOperadores = false;
                                    mostrarAvance = false;
                                    mostrarResumen = false;
                                  });
                                },
                                child: Material(
                                  color: mostrarEstadoAmarillo ? Colors.amber.shade50 : Colors.transparent,
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
                                          Icons.warning_rounded,
                                          size: 10,
                                          color: mostrarEstadoAmarillo ? Colors.amber.shade400 : Colors.amber,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          "Estado",
                                          style: TextStyle(
                                            fontSize: 9
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(7),
                              child: Material(
                                color: mostrarResumen ? Colors.blue.shade50 : Colors.transparent,
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
                                        Icons.inventory_rounded,
                                        size: 10,
                                        color: Colors.blue,
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
                                  mostrarResumen = true;
                                  mostrarAvance = false;
                                  mostrarOperadores = false;
                                  mostrarEstadoAmarillo = false;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(7),
                              child: Material(
                                color: mostrarAvance ? Colors.green.shade50 : Colors.transparent,
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
                                        Icons.timeline_rounded,
                                        size: 10,
                                        color: Colors.green,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Avance",
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
                                  mostrarAvance = true;
                                  mostrarResumen = false;
                                  mostrarOperadores = false;
                                  mostrarEstadoAmarillo = false;
                                });
                              },
                            ),
                          ),
                          if (widget.indicador.obtenerTitulares!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(7),
                                onTap: () {
                                  setState(() {
                                    mostrarOperadores = true;
                                    mostrarAvance = false;
                                    mostrarResumen = false;
                                    mostrarEstadoAmarillo = false;
                                  });
                                },
                                child: Material(
                                  color: mostrarOperadores ? Tema.secondaryLight : Colors.transparent,
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
                                          Icons.people_alt_rounded,
                                          size: 10,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Operadores",
                                          style: TextStyle(
                                            fontSize: 9
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
                    ),
                  ),
                ),
                if (mostrarAvance)
                  ContenidoAvance(indicador: widget.indicador),
                if (mostrarResumen)
                  ContenidoResumen(indicador: widget.indicador),
                if (mostrarOperadores)
                  ContenidoOperadores(indicador: widget.indicador),
                if (mostrarEstadoAmarillo)
                  ContenidoEstadoAmarillo(indicador: widget.indicador),
                if (widget.indicador.obtenerTitulares!.isNotEmpty)
                  BotonesDescargarArchivos(indicador: widget.indicador),
              ],
              onExpansionChanged: (value) {

                setState(() {

                  filaExpandida = value;

                });
                
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
              side: BorderSide(
                color: Tema.primaryLight,
              )
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.indicador.obtenerEsDia! ? "Diurno" : "Nocturno",
                    style: const TextStyle(
                      fontSize: 7,
                      color: Colors.grey
                    )
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    widget.indicador.obtenerEsDia! ? Icons.wb_sunny_rounded : Icons.nights_stay,
                    size: 6,
                    color: widget.indicador.obtenerEsDia! ? Colors.amber : Colors.blue.shade300,
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );

  }

}

class ContenidoResumen extends StatelessWidget {

  final Indicador indicador;
  
  const ContenidoResumen({
    super.key,
    required this.indicador
  });

  @override
  Widget build(BuildContext context) {

    Widget buildRow(List<String> listaCadenas, {bool esBold = false, bool esDeficiente = false, Color color = Colors.black, bool colorHorasIg = false}) {

      return Row(
        children: listaCadenas.asMap().entries.map((entry) {

          final cadena = entry.value;
          final indice = entry.key;

          return Expanded(
            child: Text(
              cadena,
              textAlign: indice < 1 ? TextAlign.start : TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: esBold || esDeficiente ? FontWeight.bold : FontWeight.normal,
                color: colorHorasIg && esDeficiente ? Tema.primary : (esDeficiente ? Colors.red : color)
              )
            ),
          );
          
        }).toList(),
      );

    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: Colors.blue.shade50,
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
              buildRow(["Resumen de Inventario - ${indicador.obtenerNombreCliente} ${indicador.obtenerCE}"], esBold: true),
              Divider(color: Colors.blue.shade100),
              buildRow(["Local", indicador.obtenerNombreLocal!], esBold: true, color: Colors.blue),
              buildRow(["Horas IG", indicador.obtenerIgHours!], esDeficiente: IndicadorDeficiente.esHorasIgDeficiente(indicador.obtenerIgHours!), colorHorasIg: true),
              buildRow(["Conteo de Unidades", indicador.obtenerUnitsCounted!]),
              buildRow(["Unidades Informadas", indicador.obtenerStockTeorico!]),
              buildRow(["Diferencia Uni. Informadas", indicador.obtenerDiffCounted!]),
              Divider(color: Colors.blue.shade100),
              buildRow(["Nota Promedio", indicador.obtenerAvgScores!], esDeficiente: IndicadorDeficiente.esNotaPromedioDeficiente(indicador.obtenerAvgScores!)),
              buildRow(["Nota Conteo", indicador.obtenerNotaConteo!]),
              buildRow(["Error SEI", indicador.obtenerSeiError!], esDeficiente: IndicadorDeficiente.esErrorSeiDeficiente(indicador.obtenerSeiError!)),
              buildRow(["Estándar SEI", indicador.obtenerSeiStandard!], esDeficiente: IndicadorDeficiente.esEstandarSeiDeficiente(indicador.obtenerSeiStandard!)),
              buildRow(["Varianza", indicador.obtenerVarianza!], esDeficiente: IndicadorDeficiente.esVarianzaDeficiente(indicador.obtenerVarianza!)),
              const SizedBox(height: 10),
              buildRow(["Diferencia Neta \$", indicador.obtenerDiffNeto!]),
              Divider(color: Colors.blue.shade100),
              buildRow(["Supervisor", indicador.leader!], esBold: true),
            ],
          ),
        ),
      ),
    );

  }

}

class ContenidoAvance extends StatelessWidget {

  final Indicador indicador;
  
  const ContenidoAvance({
    super.key,
    required this.indicador
  });

  @override
  Widget build(BuildContext context) {

    Widget buildRow(List<String> listaCadenas, {bool esBold = false, Color color = Colors.black}) {

      return Row(
        children: listaCadenas.asMap().entries.map((entry) {

          final cadena = entry.value;
          final indice = entry.key;

          return Expanded(
            flex: indice == 0 ? 2 : 1,
            child: Text(
              cadena,
              textAlign: indice == 0 ? TextAlign.start : TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: esBold ? FontWeight.bold : FontWeight.normal,
                color: color
              )
            ),
          );
          
        }).toList(),
      );

    }

    Widget progresoAvance() {

      double? porcentajeAvance = double.tryParse(indicador.avance!.obtenerPorAvanceUnidades.replaceAll("%", ""));

      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: LinearProgressIndicator(
            value: porcentajeAvance != null ? porcentajeAvance / 100 : 0,
            valueColor: const AlwaysStoppedAnimation(Colors.green),
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      );
      
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: Colors.green.shade50,
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
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Avance de Inventario",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  progresoAvance(),
                  Text(
                    indicador.avance!.obtenerPorAvanceUnidades,
                    style:  TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Tema.primary
                    ),
                  )
                ],
              ),
              Divider(color: Colors.green.shade100),
              buildRow(["Hora de inicio programada", "", indicador.avance!.obtenerHoraInicio!]),
              buildRow(["Hora de comienzo", "", indicador.avance!.obtenerHoraInicioReal!]),
              buildRow(["Dotación total", "", indicador.avance!.obtenerDotacion!]),
              Divider(color: Colors.green.shade100),
              buildRow(["Stock Teórico", indicador.avance!.obtenerCantidadTeorica, "100.00 %"]),
              buildRow(["Avance Uni. Contadas", indicador.avance!.obtenerCantidadFisica, indicador.avance!.obtenerPorAvanceUnidades]),
              buildRow(["Avance Sala", "", indicador.avance!.obtenerPorAvanceSala]),
              buildRow(["Avance Bodega", "", indicador.avance!.obtenerPorAvanceBodega]),
              Divider(color: Colors.green.shade100),
              buildRow(["Auditoría", "", "Avance %"], esBold: true, color: Tema.primary),
              buildRow(["Avance Items", "", indicador.avance!.obtenerPorAvanceAuditoria]),
              buildRow(["Error", "", indicador.avance!.obtenerPorNivelError]),
              Divider(color: Colors.green.shade100),
              buildRow(["Jefe Local", indicador.obtenerTooltipJl!]),
              buildRow(["Líder SEI", indicador.avance!.nombreLider!]),
            ],
          ),
        ),
      ),
    );

  }

}

class ContenidoOperadores extends StatelessWidget {

  final Indicador indicador;
  
  const ContenidoOperadores({
    super.key,
    required this.indicador
  });

  @override
  Widget build(BuildContext context) {

    Widget buildRow(List<String> listaCadenas, {bool esBold = false, bool esLider = false}) {

      return Row(
        children: listaCadenas.asMap().entries.map((entry) {

          final cadena = entry.value;
          final indice = entry.key;

          final alineacion = (indice == 0) ? TextAlign.start : TextAlign.center;

          return Expanded(
            flex: indice == 0 || indice == 1 ? 2 : 1,
            child: Text(
              cadena,
              textAlign: alineacion,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                color: esLider ? Colors.blue.shade300 : Colors.white,
                fontWeight: esBold ? FontWeight.bold : FontWeight.normal,
              )
            ),
          );
          
        }).toList(),
      );

    }

    if (indicador.obtenerTitulares!.isNotEmpty) {

      int? conteoLider = int.tryParse(indicador.obtenerLider!.obtenerConteo!.replaceAll(".", ""));
      int? conteoLiderError = int.tryParse(indicador.obtenerLider!.obtenerCantidadError!);
      int? unidadesContadas = int.tryParse(indicador.obtenerUnitsCounted!.replaceAll(".", ""));

      int conteoTotal = 0;
      int conteoOtros = 0;

      int conteoTotalError = 0;

      for (Titular titular in indicador.obtenerTitulares!) {

        int? conteoTitular = int.tryParse(titular.obtenerConteo!.replaceAll(".", ""));
        int? conteoTitularError = int.tryParse(titular.obtenerCantError!);

        if (conteoTitular != null) {

          conteoTotal = conteoTotal + conteoTitular;
          conteoTotalError = conteoTotalError + conteoTitularError!;

        }

      }

      if (conteoLider != null) {

        conteoTotal = conteoTotal + conteoLider;

      }

      if (conteoLiderError != null) {

        conteoTotalError = conteoTotalError + conteoLiderError;

      }

      if (unidadesContadas != null) {

        conteoOtros = unidadesContadas - conteoTotal;

      }

      return Padding(
        padding: const EdgeInsets.all(10),
        child: Material(
          color: Colors.black87,
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
                buildRow(["Operadores - ${indicador.obtenerNombreCliente} ${indicador.obtenerCE}"], esBold: true),
                const Divider(color: Colors.white),
                buildRow(["Nombre", "Cantidad Error", "Error", "Conteo", "EXP"], esBold: true),
                if (indicador.obtenerLider != null)
                  buildRow([indicador.obtenerLider!.obtenerTitular!, indicador.obtenerLider!.obtenerCantidadError!, indicador.obtenerLider!.obtenerError!, indicador.obtenerLider!.obtenerConteo!, ""], esLider: true),
                for (Titular titular in indicador.obtenerTitulares!)
                  buildRow([titular.obtenerTitular!, titular.obtenerCantError!, titular.obtenerError!, titular.obtenerConteo!, titular.obtenerExp!]),
                const Divider(color: Colors.white),
                buildRow(["Otros", "-", "-", NumberFormat("#,###", "es_ES").format(int.parse(conteoOtros.toString())), "-"], esBold: true),
                buildRow(["Totales", conteoTotalError.toString(), "-", indicador.obtenerUnitsCounted!, "-"], esBold: true)
              ],
            ),
          ),
        ),
      );

    }

    return Container();

  }

}

class ContenidoEstadoAmarillo extends StatelessWidget {

  final Indicador indicador;
  
  const ContenidoEstadoAmarillo({
    super.key,
    required this.indicador
  });

  @override
  Widget build(BuildContext context) {

    Widget buildRow(List<String> listaCadenas, {bool esBold = false}) {

      return Row(
        children: listaCadenas.asMap().entries.map((entry) {

          final cadena = entry.value;
          final indice = entry.key;

          return Expanded(
            child: Text(
              cadena,
              textAlign: indice == 0 ? TextAlign.start : TextAlign.end,
              style: TextStyle(
                fontSize: 9,
                fontWeight: esBold ? FontWeight.bold : FontWeight.normal,
              )
            ),
          );
          
        }).toList(),
      );

    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: Colors.amber.shade50,
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
              buildRow(["Indicador", "Estado"], esBold: true),
              if (indicador.indicator == null)
                buildRow(["Archivo ZIP", "Archivo no cargado"]),
              if (indicador.leader!.toLowerCase().contains("suspendido"))
                buildRow(["Supervisor", "Supervisor suspendido"]),
            ],
          ),
        ),
      ),
    );

  }

}

class BotonesDescargarArchivos extends StatefulWidget {

  final Indicador indicador;

  const BotonesDescargarArchivos({
    super.key,
    required this.indicador,
  });

  @override
  State<BotonesDescargarArchivos> createState() => _BotonesDescargarArchivosState();

}

class _BotonesDescargarArchivosState extends State<BotonesDescargarArchivos> {

  double progreso = 0.0;
  bool descargaIniciada = false;
  String archivoDescargando = "";

  @override
  Widget build(BuildContext context) {

    final proveedorEstado = Provider.of<ProveedorEstado>(context);

    void resetearBarraProgreso() {

      setState(() {
        progreso = 0.0;
        descargaIniciada = false;
        archivoDescargando = "";
      });

    }

    void descargarArchivo(int idArchivo, String tipoArchivo) async {

      String resultadoDescargarArchivo = "";

      try {

        resultadoDescargarArchivo = await proveedorEstado.descargarArchivoConProgreso(
          idArchivo,
          tipoArchivo,
          (progresoDescarga) {
            setState(() {
              progreso = progresoDescarga;
            });
          },
        );

      } finally {

        if (mounted) {

          resetearBarraProgreso();

          SnackbarMensaje.mostrarMensaje(context, "Archivo Guardado: $resultadoDescargarArchivo");

        }

      }

    }

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        children: [
          if (descargaIniciada)
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Column(
                    children: [
                      ColoredBox(
                        color: Tema.secondaryLight,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.file_download_rounded,
                                size: 10,
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
                        color: Colors.red,
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation(Tema.primary),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          Align(
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!descargaIniciada)
                    InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: () async {
                        setState(() {
                          descargarArchivo(widget.indicador.indicator!.idFile!, "descargar-acta");
                          descargaIniciada = true;
                          archivoDescargando = "Acta";
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: ColoredBox(
                          color: Tema.secondaryLight,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.file_download_rounded,
                                  size: 10,
                                  color: Tema.primary,
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  "Acta PDF",
                                  style: TextStyle(fontSize: 9),
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
                      onTap: () async {
                        setState(() {
                          descargarArchivo(widget.indicador.indicator!.idFile!, "descargar-checklist");
                          descargaIniciada = true;
                          archivoDescargando = "Checklist";
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: ColoredBox(
                          color: Tema.secondaryLight,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.file_download_rounded,
                                  size: 10,
                                  color: Colors.teal,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Checklist",
                                  style: TextStyle(fontSize: 9),
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
                      onTap: () async {
                        setState(() {
                          descargarArchivo(widget.indicador.indicator!.idFile!, "descargar");
                          descargaIniciada = true;
                          archivoDescargando = "ZIP";
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: ColoredBox(
                          color: Tema.secondaryLight,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.file_download_rounded,
                                  size: 10,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "ZIP",
                                  style: TextStyle(fontSize: 9),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      )
    );

  }

}
