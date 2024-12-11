import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/helpers/modal_fecha.dart';
import 'package:sigsei/models/modulo.dart';
import 'package:sigsei/models/indicador.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/providers/proveedor_estado.dart';
import 'package:sigsei/themes/tema.dart';
import 'package:sigsei/widgets/pantalla_general/barra_usuario.dart';
import 'package:sigsei/widgets/pantalla_indicadores/fila_indicador.dart';

class PantallaIndicadores extends StatefulWidget {

  const PantallaIndicadores({super.key});

  @override
  PantallaIndicadoresState createState() => PantallaIndicadoresState();

}

class PantallaIndicadoresState extends State<PantallaIndicadores> {

  late Future<List<Indicador>?> listaIndicadores;

  List<Indicador>? indicadores;
  
  String? formatoFecha;
  String fechaFormateada = "";
  String selectedItem = "Todos";

  bool indicadoresCargados = false;

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

    listaIndicadores = proveedorEstado.obtenerIndicadores(fechaFormateada, fechaFormateada);

  }

  String obtenerFechaFormateada() {

    String fechaConMayusculas = formatoFecha!.split(' ').map((palabra) {

      if (palabra.toLowerCase() == 'de') {

        return palabra;

      } else {

        return palabra.substring(0, 1).toUpperCase() + palabra.substring(1);

      }

    }).join(' ');

    return fechaConMayusculas;

  }

  Future<void> modalFecha() async {

    ModalFecha(
      context: context,
      tipoModalFecha: ModalFecha.simple,
      fechaInicio: DateTime.parse(fechaFormateada),
      fechaSeleccionada: (fechaInicio, fechaFin) {

        if (fechaInicio != null) {

          setState(() {

            String fecha = DateFormat("yyyy-MM-dd").format(fechaInicio);

            fechaFormateada = fecha;

            final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

            formatoFecha = DateFormat('EEEE d \'de\' MMMM \'de\' yyyy', 'es_ES').format(fechaInicio);

            listaIndicadores = proveedorEstado.obtenerIndicadores(fechaFormateada, fechaFormateada);

            indicadoresCargados = false;

          });

        }

      },
    ).show();

  }

  Text formatearCelda(String cadena) {

    return Text(
      cadena,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 9,
        color: Colors.white
      ),
    );

  }

      final List<String> items = [
      'Item1',
      'Item2',
      'Item3',
      'Item4',
    ];

    String? selectedValue = "Item1";

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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    child: Text.rich(
                      TextSpan(
                        text: "${modulo.titulo} - ",
                        children: [
                          TextSpan(
                            text: obtenerFechaFormateada(),
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                color: Tema.primaryLight
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Tema.primaryLight,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month_rounded,
                                    size: 15
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Fecha ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Tema.primary,
                                              fontSize: 11
                                            ),
                                          ),
                                          TextSpan(
                                            text: fechaFormateada,
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              )
                            ),
                            onTap: () => modalFecha(),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Tema.primaryLight,
                              borderRadius: BorderRadius.circular(7)
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isDense: true,
                                value: selectedItem,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black
                                ),
                                isExpanded: true,
                                icon: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: Tema.primary,
                                  size: 15,
                                ),
                                onChanged: (value) async {
                                  setState(() {
                                    selectedItem = value!;
                                  });
                                },
                                borderRadius: BorderRadius.circular(7),
                                items: <String>["Todos", "Diurnos", "Nocturnos"].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(
                                      children: [
                                        Icon(
                                          value == "Todos" ? Icons.fact_check_outlined : value == "Diurnos" ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                                          color: value == "Diurnos" ? Colors.amber : Tema.primary,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          value
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Tema.primary,
                  borderRadius: BorderRadius.circular(7)
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
                      child: formatearCelda("Código\nCECO")
                    ),
                    Expanded(
                      flex: 2,
                      child: formatearCelda("Nombre\nLocal")
                    ),
                    Expanded(
                      flex: 1,
                      child: formatearCelda("Nota\nProm.")
                    ),
                    Expanded(
                      flex: 1,
                      child: formatearCelda("Valor\nVaria.")
                    ),
                    Expanded(
                      flex: 1,
                      child: formatearCelda("Error\nSEI")
                    ),
                    Expanded(
                      flex: 1,
                      child: formatearCelda("Estándar\nSEI")
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: listaIndicadores,
              builder: (context, AsyncSnapshot<List<Indicador>?> snapshot) {
            
                if (snapshot.connectionState == ConnectionState.waiting && indicadoresCargados == false) {
            
                  indicadoresCargados = true;
            
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            color: Tema.primary,
                            strokeWidth: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text("Obteniendo Indicadores")
                      ],
                    ),
                  );
            
                } else if (snapshot.hasError) {
            
                  return const Center(child: Text("Error"));
            
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: Tema.primaryLight,
                          width: 1.5
                        )
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sentiment_dissatisfied_rounded,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Sin Indicadores de Inventarios para",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500
                            ),
                          ),
                          Text(
                            obtenerFechaFormateada(),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                  );
            
                } else {
            
                  indicadores = selectedItem == "Diurnos" ? snapshot.data!.where((i) => i.esDia!).toList() : selectedItem == "Nocturnos" ? snapshot.data!.where((i) => !i.esDia!).toList() : snapshot.data;
            
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);
                        final nuevaListaIndicadores = await proveedorEstado.obtenerIndicadores(fechaFormateada, fechaFormateada);
                        if (mounted) {
                          setState(() {
                            listaIndicadores = Future.value(nuevaListaIndicadores);
                          });
                        }
                      },
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 50),
                        children: indicadores!.map((indicador) {
                      
                          return FilaIndicador(indicador: indicador);
                      
                        }).toList(),
                      ),
                    )
                  );
            
                }
            
              },
            )
          ]
        ),
      )
    );

  }

}
