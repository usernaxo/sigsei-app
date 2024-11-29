import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/helpers/indicador_deficiente.dart';
import 'package:sigsei/helpers/modulo.dart';
import 'package:sigsei/models/indicador.dart';
import 'package:sigsei/models/inventario_general.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/providers/proveedor_estado.dart';
import 'package:sigsei/themes/tema.dart';
import 'package:sigsei/widgets/barra_usuario.dart';

class PantallaInventarioGeneral extends StatefulWidget {

  const PantallaInventarioGeneral({super.key});

  @override
  PantallaInventarioGeneralState createState() => PantallaInventarioGeneralState();

}

class PantallaInventarioGeneralState extends State<PantallaInventarioGeneral> {

  late Future<List<InventarioGeneral>?> listaInventarioGeneral;
  
  String? formatoFecha;
  String fechaFormateada = "";

  @override
  void initState() {

    super.initState();

    final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

    DateTime fechaActual = DateTime.now();

    if (fechaActual.weekday == DateTime.monday && fechaActual.hour < 16) {

      fechaFormateada = DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(const Duration(days: 3)));
      formatoFecha = DateFormat('EEEE d \'de\' MMMM \'de\' yyyy', 'es_ES').format(DateTime.now().subtract(const Duration(days: 3)));

    } else {

      if (fechaActual.hour >= 16) {

        fechaFormateada = DateFormat("yyyy-MM-dd").format(DateTime.now());
        formatoFecha = DateFormat('EEEE d \'de\' MMMM \'de\' yyyy', 'es_ES').format(DateTime.now());

      } else {

        fechaFormateada = DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(const Duration(days: 1)));
        formatoFecha = DateFormat('EEEE d \'de\' MMMM \'de\' yyyy', 'es_ES').format(DateTime.now().subtract(const Duration(days: 1)));

      }

    }

    listaInventarioGeneral = proveedorEstado.obtenerInventarioGeneral("2024-11-20", "2024-11-25");

  }

  Future<void> modalFecha(BuildContext context) async {

    final DateTime? fechaInicial = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101)
    );

    if (fechaInicial != null && fechaInicial != DateTime.now()) {

      setState(() {

        fechaFormateada = "${fechaInicial.toLocal()}".split(" ")[0];

        final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

        formatoFecha = DateFormat('EEEE d \'de\' MMMM \'de\' yyyy', 'es_ES').format(fechaInicial);

        listaInventarioGeneral = proveedorEstado.obtenerInventarioGeneral("2024-11-20", "2024-11-25");

      });

    }

  }

  Text formatearCelda(String cadena) {

    return Text(
      cadena,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 10,
        color: Colors.white
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    final argumentos = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Modulo modulo = argumentos["modulo"];
    Usuario usuario = argumentos["usuario"];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BarraUsuario(usuario: usuario, botonRetroceso: true),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(
                      modulo.icono,
                      size: 15,
                    )
                  ),
                  Expanded(
                    child: Text(
                      modulo.titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ),
            /*Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Tema.primaryLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month_rounded,
                                    size: 15
                                  ),
                                  const SizedBox(width: 5),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Fecha ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Tema.primary,
                                            fontSize: 12
                                          ),
                                        ),
                                        TextSpan(
                                          text: fechaFormateada,
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ),
                            onTap: () => modalFecha(context),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Tema.primary,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: formatearCelda("Estado\nIndicador")
                    ),
                    Expanded(
                      flex: 1,
                      child: formatearCelda("Nombre\nCliente")
                    ),
                    Expanded(
                      flex: 1,
                      child: formatearCelda("Código\nEmpresa")
                    ),
                    Expanded(
                      flex: 2,
                      child: formatearCelda("Nombre\nLocal")
                    ),
                    Expanded(
                      flex: 1,
                      child: formatearCelda("Nota\nPromedio")
                    ),
                    Expanded(
                      flex: 1,
                      child: formatearCelda("Error\nSEI %")
                    ),
                    Expanded(
                      flex: 1,
                      child: formatearCelda("Estándar\nSEI %")
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: listaInventarioGeneral,
                builder: (context, AsyncSnapshot<List<InventarioGeneral>?> snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Tema.primary
                        ),
                        const SizedBox(height: 20),
                        const Text("Obteniendo Indicadores")
                      ],
                    );

                  } else if (snapshot.hasError) {

                    return const Center(child: Text("Error"));

                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {

                    return const Center(child: Text("No Existen Indicadores"));

                  } else {

                    return ListView(
                      padding: const EdgeInsets.only(bottom: 50),
                      children: snapshot.data!.map((indicador) {

                        return Container();

                      }).toList(),
                    );

                  }

                },
              )
            )*/
          ]
        ),
      )
    );

  }

}

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
  bool mostrarTitulares = false;
  bool mostrarEstadoAmarillo = false;
  bool filaExpandida = false;

  @override
  Widget build(BuildContext context) {

    Text formatearCelda(String? cadena, {alineacion = TextAlign.center, esBold = false, esDeficiente = false, color = Colors.black}) {

      String cadenaSinEspacios = cadena!.replaceAll(" ", "");

      int limiteCaracteres = 14;

      if (cadenaSinEspacios.length > limiteCaracteres) {
        
        int contadorCaracteres = 0;
        int indice = 0;

        while (contadorCaracteres < limiteCaracteres && indice < cadena.length) {

          if (cadena[indice] != " ") {

            contadorCaracteres++;

          }

          indice++;

        }

        cadena = "${cadena.substring(0, indice)}...";

      }

      return Text(
        cadena,
        textAlign: alineacion,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 10,
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
      String varianza = indicador.obtenerVariance!;

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
        size: 10,
        color: indicadorAmarillo(indicador) ? Colors.yellow : (indicadorRojo(indicador) ? Colors.red : Colors.green),
      );

    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Tema.primaryLight
          )
        ),
        margin: const EdgeInsets.all(3),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          childrenPadding: EdgeInsets.zero,
          showTrailingIcon: false,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Tema.primaryLight,
              width: 2
            ),
            borderRadius: BorderRadius.circular(10)
          ),
          title: Row(
            children: [
              Expanded(
                flex: 1,
                child: estadoIndicador(widget.indicador)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.indicador.clientName!, esBold: true, color: Tema.primary)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.indicador.storeNumber!, alineacion:  TextAlign.right),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: formatearCelda(widget.indicador.storeName!, alineacion:  TextAlign.left)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.indicador.obtenerAvgScores, esDeficiente: IndicadorDeficiente.esNotaPromedioDeficiente(widget.indicador.obtenerAvgScores!))
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.indicador.obtenerSeiError, esDeficiente: IndicadorDeficiente.esErrorSeiDeficiente(widget.indicador.obtenerSeiError!))
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.indicador.obtenerSeiStandard, esDeficiente: IndicadorDeficiente.esEstandarSeiDeficiente(widget.indicador.obtenerSeiStandard!))
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  if (indicadorAmarillo(widget.indicador))
                    InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: () {
                        setState(() {
                          mostrarEstadoAmarillo = true;
                          mostrarTitulares = false;
                          mostrarAvance = false;
                          mostrarResumen = false;
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: ColoredBox(
                          color: mostrarEstadoAmarillo ? Colors.amber.shade100 : Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  size: 11,
                                  color: mostrarEstadoAmarillo ? Colors.amber.shade400 : Colors.amber,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "Estado",
                                  style: TextStyle(
                                    fontSize: 11
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  InkWell(
                    borderRadius: BorderRadius.circular(7),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: ColoredBox(
                        color: mostrarAvance ? Colors.green.shade100 : Colors.transparent,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.timeline_rounded,
                                size: 11,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Avance",
                                style: TextStyle(
                                  fontSize: 11
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        mostrarAvance = true;
                        mostrarResumen = false;
                        mostrarTitulares = false;
                        mostrarEstadoAmarillo = false;
                      });
                    },
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(7),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: ColoredBox(
                        color: mostrarResumen ? Colors.deepPurple.shade100 : Colors.transparent,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.assessment_outlined,
                                size: 11,
                                color: Colors.deepPurple,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Resumen",
                                style: TextStyle(
                                  fontSize: 11
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
                        mostrarAvance = false;
                        mostrarTitulares = false;
                        mostrarEstadoAmarillo = false;
                      });
                    },
                  ),
                  if (widget.indicador.obtenerTitulares!.isNotEmpty)
                    InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: () {
                        setState(() {
                          mostrarTitulares = true;
                          mostrarAvance = false;
                          mostrarResumen = false;
                          mostrarEstadoAmarillo = false;
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: ColoredBox(
                          color: mostrarTitulares ? Colors.black12 : Colors.transparent,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.people_alt_rounded,
                                  size: 11,
                                  color: Colors.teal,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Operadores",
                                  style: TextStyle(
                                    fontSize: 11
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
            if (mostrarAvance)
              ContenidoAvance(indicador: widget.indicador),
            if (mostrarResumen)
              ContenidoResumen(indicador: widget.indicador),
            if (mostrarTitulares)
              ContenidoTitulares(indicador: widget.indicador),
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

    Widget buildRow(List<String> listaCadenas, {bool esBold = false}) {

      return Row(
        children: listaCadenas.asMap().entries.map((entry) {

          final cadena = entry.value;
          final indice = entry.key;

          return Expanded(
            flex: indice == 0 ? 2 : 1,
            child: Text(
              cadena,
              textAlign: indice == 0 ? TextAlign.start : TextAlign.end,
              style: TextStyle(
                fontSize: 10,
                fontWeight: esBold ? FontWeight.bold : FontWeight.normal,
              )
            ),
          );
          
        }).toList(),
      );

    }

    Text formatearCadena(String cadena, {bool esBold = false}) {

      return Text(
        cadena,
        style: TextStyle(
          fontSize: 11,
          fontWeight: esBold ? FontWeight.bold : FontWeight.normal,
        )
      );

    }

    Widget progresoAvance() {

      double? porcentajeAvance = double.tryParse(indicador.avance!.obtenerPorAvanceUnidades.replaceAll("%", ""));

      if (porcentajeAvance != null) {

        return Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: porcentajeAvance / 100,
                    valueColor: const AlwaysStoppedAnimation(Colors.green),
                    backgroundColor: Colors.red,
                  ),
                  Text(
                    "${indicador.avance!.obtenerPorAvanceUnidades.split(".")[0]} %",
                    style: const TextStyle(
                      fontSize: 11, 
                      fontWeight: FontWeight.bold, 
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      }

      return Container();
      
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formatearCadena("Avance de Inventario", esBold: true),
                      formatearCadena("Hora de Inicio Programada"),
                      formatearCadena("Hora de Comienzo"),
                      formatearCadena("Dotación"),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      formatearCadena("Conteo", esBold: true),
                      formatearCadena(indicador.avance!.horaInicioProgramada!),
                      formatearCadena(indicador.avance!.horaInicioReal!),
                      formatearCadena(indicador.avance!.dotacionDiferencia!),
                    ],
                  ),
                ),
                progresoAvance()
              ],
            ),
            Divider(color: Colors.green.shade200),
            buildRow(["Avance Uni. Contadas", indicador.avance!.obtenerCantidadFisica, indicador.avance!.obtenerPorAvanceUnidades]),
            buildRow(["Avance Sala", "", indicador.avance!.obtenerPorAvanceSala]),
            buildRow(["Avance Bodega", "", indicador.avance!.obtenerPorAvanceBodega]),
            buildRow(["Stock Teórico", indicador.avance!.obtenerCantidadTeorica, "100.00 %"]),
            Divider(color: Colors.green.shade200),
            buildRow(["Auditoría", "", "Avance %"], esBold: true),
            buildRow(["Avance Items", "", indicador.avance!.obtenerPorAvanceAuditoria]),
            buildRow(["Error", "", indicador.avance!.obtenerPorNivelError]),
            Divider(color: Colors.green.shade200),
            buildRow(["Jefe Local", indicador.obtenerTooltipJl!, ""]),
            buildRow(["Líder SEI", indicador.avance!.nombreLider!, ""]),
          ],
        ),
      ),
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

    Widget buildRow(List<String> listaCadenas, {bool esBold = false, bool esDeficiente = false}) {

      return Row(
        children: listaCadenas.asMap().entries.map((entry) {

          final cadena = entry.value;
          final indice = entry.key;

          final alineacion = (indice >= listaCadenas.length - 2) ? TextAlign.end : TextAlign.start;

          return Expanded(
            child: Text(
              cadena,
              textAlign: alineacion,
              style: TextStyle(
                fontSize: 10,
                fontWeight: esBold || esDeficiente ? FontWeight.bold : FontWeight.normal,
                color: esDeficiente ? Colors.red : Colors.black
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
          color: Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            buildRow(["Resumen de Inventario", "Conteo", "Porcentaje %"], esBold: true),
            buildRow(["Horas IG", indicador.obtenerIgHours!, ""], esDeficiente: IndicadorDeficiente.esHorasIgDeficiente(indicador.obtenerIgHours!)),
            buildRow(["Conteo de Unidades", indicador.obtenerUnitsCounted!, ""]),
            buildRow(["Unidades Informadas", indicador.obtenerStockTeorico, ""]),
            buildRow(["Diferencia Uni. Informadas", indicador.obtenerDiffCounted!, ""]),
            Divider(color: Colors.deepPurple.shade200),
            buildRow(["Nota Promedio", indicador.obtenerAvgScores!, ""], esDeficiente: IndicadorDeficiente.esNotaPromedioDeficiente(indicador.obtenerAvgScores!)),
            buildRow(["Error SEI", "", indicador.obtenerSeiError!], esDeficiente: IndicadorDeficiente.esErrorSeiDeficiente(indicador.obtenerSeiError!)),
            buildRow(["Estándar SEI", "", indicador.obtenerSeiStandard!], esDeficiente: IndicadorDeficiente.esEstandarSeiDeficiente(indicador.obtenerSeiStandard!)),
            buildRow(["Varianza", "", indicador.obtenerVariance!], esDeficiente: IndicadorDeficiente.esVarianzaDeficiente(indicador.obtenerVariance!)),
            const SizedBox(height: 10),
            buildRow(["Diferencia Neta \$", indicador.obtenerDiffNeto!, ""]),
            Divider(color: Colors.deepPurple.shade200),
            buildRow(["Supervisor", indicador.leader!, ""], esBold: true),
          ],
        ),
      ),
    );

  }

}

class ContenidoTitulares extends StatelessWidget {

  final Indicador indicador;
  
  const ContenidoTitulares({
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
              style: TextStyle(
                fontSize: 10,
                color: esLider ? Colors.teal.shade300 : Colors.white,
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
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
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
                fontSize: 10,
                fontWeight: esBold ? FontWeight.bold : FontWeight.normal,
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
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
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
  Color colorBarraProgreso = Tema.primary;

  @override
  Widget build(BuildContext context) {

    final proveedorEstado = Provider.of<ProveedorEstado>(context);

    void descargarArchivo(int idArchivo, String tipoArchivo) async {

      while (true) {

        var status = await Permission.storage.status;

        if (status.isGranted) {

          String resultadoDescargarArchivo = await proveedorEstado.descargarArchivoConProgreso(
            idArchivo,
            tipoArchivo,
            (progresoDescarga) {
              setState(() {
                progreso = progresoDescarga;
              });
            },
          );

          if (mounted) {

            setState(() {
              descargaIniciada = false;
              archivoDescargando = "";
              colorBarraProgreso = Tema.primary;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Tema.primary,
                content: Row(
                  children: [
                    const Icon(
                      Icons.download_done_rounded,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      resultadoDescargarArchivo,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
            );

          }

          return;

        }

        await Permission.storage.request();

        status = await Permission.storage.status;

        if (status.isPermanentlyDenied) {

          if (mounted) {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Tema.primary,
                content: const Row(
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: Colors.white,
                      size: 12,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Habilite permisos de almacenamiento",
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
            );

          }

          return;

        }

      }

    }

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
                                Icon(
                                  Icons.file_download_rounded,
                                  size: 11,
                                  color: colorBarraProgreso,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Descargando $archivoDescargando ${progreso.toStringAsFixed(0)} %",
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                        LinearProgressIndicator(
                          value: progreso / 100,
                          color: Tema.primaryLight,
                          valueColor: AlwaysStoppedAnimation(colorBarraProgreso),
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
              onTap: () async {
                descargarArchivo(widget.indicador.indicator!.idFile!, "descargar-acta");
                descargaIniciada = true;
                archivoDescargando = "Acta";
                colorBarraProgreso = Tema.primary;
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: ColoredBox(
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.file_download_rounded,
                          size: 11,
                          color: Tema.primary,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "Acta PDF",
                          style: TextStyle(fontSize: 11),
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
                descargarArchivo(widget.indicador.indicator!.idFile!, "descargar-checklist");
                descargaIniciada = true;
                archivoDescargando = "Checklist";
                colorBarraProgreso = Colors.teal;
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: const ColoredBox(
                  color: Colors.black12,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.file_download_rounded,
                          size: 11,
                          color: Colors.teal,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Checklist",
                          style: TextStyle(fontSize: 11),
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
                descargarArchivo(widget.indicador.indicator!.idFile!, "descargar");
                descargaIniciada = true;
                archivoDescargando = "ZIP";
                colorBarraProgreso = Colors.green;
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: const ColoredBox(
                  color: Colors.black12,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.file_download_rounded,
                          size: 11,
                          color: Colors.green,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "ZIP",
                          style: TextStyle(fontSize: 11),
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
