import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/helpers/modulo.dart';
import 'package:sigsei/models/indicador.dart';
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
                      child: formatearCelda("Estado\nReporte", Colors.white)
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
  bool filaExpandida = false;

  @override
  Widget build(BuildContext context) {

    Text formatearCelda(String? cadena, Color color, TextAlign alineacion) {

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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        margin: const EdgeInsets.all(3),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          showTrailingIcon: false,
          shape: const RoundedRectangleBorder(
            side: BorderSide.none
          ),
          title: Row(
            children: [
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.circle_rounded,
                  size: 10,
                  color: widget.indicador.avance!.estaCompletado() ? Colors.green : Colors.red,
                )
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.indicador.clientName!, Tema.primary, TextAlign.center)
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: ColoredBox(
                      color: mostrarAvance && filaExpandida ? Colors.green.shade100 : Colors.transparent,
                      child: formatearCelda(widget.indicador.storeNumber!, Colors.black, TextAlign.right),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      mostrarAvance = true;
                      mostrarResumen = false;
                    });
                  },
                )
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: ColoredBox(
                      color: mostrarResumen && filaExpandida ? Colors.deepPurple.shade100 : Colors.transparent,
                      child: formatearCelda(widget.indicador.storeName!, Colors.black, TextAlign.left),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      mostrarResumen = true;
                      mostrarAvance = false;
                    });
                  },
                )
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.indicador.obtenerAvgScores, formatearColor(widget.indicador.obtenerAvgScores, 5.9), TextAlign.center)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.indicador.obtenerSeiError, Colors.black, TextAlign.center)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.indicador.obtenerSeiStandard, Colors.black, TextAlign.center)
              ),
            ],
          ),
          children: [
            mostrarAvance ? ContenidoAvance(indicador: widget.indicador) : ContenidoResumen(indicador: widget.indicador)
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
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            buildRow(["Avance de Inventario", "Conteo", "Avance %"], esBold: true),
            buildRow(["Hora de Inicio Programada", indicador.avance!.horaInicioProgramada!, ""]),
            buildRow(["Hora de Comienzo", indicador.avance!.horaInicioReal!, ""]),
            buildRow(["Dotación", indicador.avance!.dotacionDiferencia!, ""]),
            buildRow(["Avance Patentes o TAG", "", indicador.avance!.obtenerPorAvanceAuditoria]),
            buildRow(["Avance Uni. Contadas", indicador.avance!.obtenerCantidadFisica, indicador.avance!.obtenerPorAvanceUnidades]),
            buildRow(["Stock Teórico", indicador.avance!.obtenerCantidadTeorica, indicador.avance!.obtenerPorAvance]),
            Divider(color: Colors.green.shade200),
            buildRow(["Auditoría", "", "Avance %"], esBold: true),
            buildRow(["Avance Items", "", indicador.avance!.obtenerPorAvanceUnidades]),
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
