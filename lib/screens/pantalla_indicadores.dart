import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/helpers/modulo.dart';
import 'package:sigsei/models/indicador.dart';
import 'package:sigsei/models/titular.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/providers/proveedor_estado.dart';
import 'package:sigsei/themes/tema.dart';
import 'package:sigsei/widgets/barra_usuario.dart';

class PantallaIndicadores extends StatefulWidget {

  const PantallaIndicadores({super.key});

  @override
  PantallaIndicadoresState createState() => PantallaIndicadoresState();

}

class PantallaIndicadoresState extends State<PantallaIndicadores> {

  late Future<List<Indicador>?> listaIndicadores;

  TextEditingController controladorFecha = TextEditingController();

  String formatoFecha = DateFormat('EEEE d \'de\' MMMM \'de\' yyyy', 'es_ES').format(DateTime.now());

  @override
  void initState() {

    super.initState();

    final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

    String fechaActualFormateada = DateFormat("yyyy-MM-dd").format(DateTime.now());

    listaIndicadores = proveedorEstado.obtenerIndicadores(fechaActualFormateada, fechaActualFormateada);

    controladorFecha.text = fechaActualFormateada;

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

        controladorFecha.text = "${fechaInicial.toLocal()}".split(" ")[0];

        String fechaSeleccionada = controladorFecha.text;

        final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

        formatoFecha = DateFormat('EEEE d \'de\' MMMM \'de\' yyyy', 'es_ES').format(fechaInicial);

        listaIndicadores = proveedorEstado.obtenerIndicadores(fechaSeleccionada, fechaSeleccionada);

      });

    }

  }

  Text formatearCelda(String cadena, Color color) {

    return Text(
      cadena,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 11,
        color: color
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Icon(modulo.icono)
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "${modulo.titulo} ",
                        children: [
                          TextSpan(
                            text: formatoFecha,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold
                            )
                          )
                        ]
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controladorFecha,
                            readOnly: true,
                            style: const TextStyle(
                              fontSize: 14
                            ),
                            decoration: InputDecoration(
                              labelText: "Seleccione Fecha",
                              prefixIcon: const Icon(Icons.calendar_month_rounded),
                              prefixIconColor: Tema.primary
                            ),
                            onTap: () => modalFecha(context),
                          ),
                        ),
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
                      child: formatearCelda("Estado\nAvance", Colors.white)
                    ),
                    Expanded(
                      flex: 1,
                      child: formatearCelda("Nombre\nCliente", Colors.white)
                    ),
                    Expanded(
                      flex: 1,
                      child: formatearCelda("Código\nEmpresa", Colors.white)
                    ),
                    Expanded(
                      flex: 2,
                      child: formatearCelda("Nombre\nLocal", Colors.white)
                    ),
                    Expanded(
                      flex: 1,
                      child: formatearCelda("Nota\nPromedio", Colors.white)
                    ),
                    Expanded(
                      flex: 1,
                      child: formatearCelda("Error\nSEI %", Colors.white)
                    ),
                    Expanded(
                      flex: 1,
                      child: formatearCelda("Estándar\nSEI %", Colors.white)
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: listaIndicadores,
                builder: (context, AsyncSnapshot<List<Indicador>?> snapshot) {

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

                        return FilaIndicador(indicador: indicador);

                      }).toList(),
                    );

                  }

                },

              )
            )
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
  bool filaExpandida = false;

  @override
  Widget build(BuildContext context) {

    Text formatearCelda(String? cadena, Color color, TextAlign alineacion, {esBold = false}) {

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
          fontSize: 11,
          color: color,
          fontWeight: esBold ? FontWeight.bold : FontWeight.normal
        ),
      );

    }

    Color formatearColor(dynamic valor, double limite) {

      final valorNumerico = double.tryParse(valor.toString().replaceAll(',', '.'));

      if (valorNumerico != null && valorNumerico <= limite) {

        return Colors.red;

      }

      return Colors.black;

    }
    
    Widget progresoAvance(String porcentaje) {

      double? porcentajeAvance = double.tryParse(porcentaje.replaceAll("%", ""));

      if (porcentajeAvance != null) {

        return LinearProgressIndicator(
          value: porcentajeAvance / 100,
          backgroundColor: Colors.red,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          borderRadius: BorderRadius.circular(10),
        );

      }
      
      return LinearProgressIndicator(
        value: 0,
        backgroundColor: Colors.red,
        borderRadius: BorderRadius.circular(10),
      );

    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        margin: const EdgeInsets.all(3),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          childrenPadding: EdgeInsets.zero,
          showTrailingIcon: false,
          shape: const RoundedRectangleBorder(
            side: BorderSide.none
          ),
          title: Row(
            children: [
              Expanded(
                flex: 1,
                child: progresoAvance(widget.indicador.avance!.obtenerPorAvanceUnidades)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.indicador.clientName!, Tema.primary, TextAlign.center, esBold: true)
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: !filaExpandida ? null : () {
                    setState(() {
                      mostrarAvance = true;
                      mostrarTitulares = false;
                      mostrarResumen = false;
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: ColoredBox(
                      color: mostrarAvance && filaExpandida ? Colors.green.shade100 : Colors.transparent,
                      child: formatearCelda(widget.indicador.storeNumber!, Colors.black, TextAlign.right),
                    ),
                  ),
                )
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: !filaExpandida ? null : () {
                    setState(() {
                      mostrarResumen = true;
                      mostrarAvance = false;
                      mostrarTitulares = false;
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: ColoredBox(
                      color: mostrarResumen && filaExpandida ? Colors.deepPurple.shade100 : Colors.transparent,
                      child: formatearCelda(widget.indicador.storeName!, Colors.black, TextAlign.left),
                    ),
                  ),
                )
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.indicador.obtenerAvgScores, formatearColor(widget.indicador.obtenerAvgScores, 5.9), TextAlign.center)
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: (widget.indicador.obtenerTitulares!.isEmpty) ? null : !filaExpandida ? null : () {
                    setState(() {
                      mostrarTitulares = true;
                      mostrarResumen = false;
                      mostrarAvance = false;
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ColoredBox(
                      color: mostrarTitulares && filaExpandida ? Colors.black26 : Colors.transparent,
                      child: formatearCelda(widget.indicador.obtenerSeiError, Colors.black, TextAlign.center)
                    ),
                  ),
                )
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.indicador.obtenerSeiStandard, Colors.black, TextAlign.center)
              ),
            ],
          ),
          children: [
            if (mostrarAvance)
              ContenidoAvance(indicador: widget.indicador),
            if (mostrarResumen)
              ContenidoResumen(indicador: widget.indicador),
            if (mostrarTitulares)
              ContenidoTitulares(indicador: widget.indicador)
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
                fontSize: 11,
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
            buildRow(["Avance Patentes o TAG", "", indicador.avance!.obtenerPorAvance]),
            buildRow(["Avance Uni. Contadas", indicador.avance!.obtenerCantidadFisica, indicador.avance!.obtenerPorAvanceUnidades]),
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

    Widget buildRow(List<String> listaCadenas, {bool esBold = false}) {

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
                fontSize: 11,
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
          color: Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            buildRow(["Resumen de Inventario", "Conteo", "Porcentaje %"], esBold: true),
            buildRow(["Horas IG", indicador.obtenerIgHours!, ""]),
            buildRow(["Conteo de Unidades", indicador.obtenerUnitsCounted!, ""]),
            buildRow(["Unidades Informadas", indicador.obtenerStockTeorico, ""]),
            buildRow(["Diferencia Uni. Informadas", indicador.obtenerDiffCounted!, ""]),
            Divider(color: Colors.deepPurple.shade200),
            buildRow(["Nota Promedio", indicador.obtenerAvgScores!, ""]),
            buildRow(["Error SEI", "", indicador.obtenerSeiError!]),
            buildRow(["Estándar SEI", "", indicador.obtenerSeiStandard!]),
            buildRow(["Varianza", "", indicador.obtenerVariance!]),
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
                fontSize: 11,
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
