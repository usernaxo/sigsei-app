import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/helpers/modal_fecha.dart';
import 'package:sigsei/models/avance.dart';
import 'package:sigsei/models/modulo.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/providers/proveedor_estado.dart';
import 'package:sigsei/themes/tema.dart';
import 'package:sigsei/widgets/pantalla_avances/fila_avance.dart';
import 'package:sigsei/widgets/pantalla_general/barra_usuario.dart';

class PantallaAvances extends StatefulWidget {

  const PantallaAvances({super.key});

  @override
  PantallaAvancesState createState() => PantallaAvancesState();

}

class PantallaAvancesState extends State<PantallaAvances> {

  late Future<List<Avance>?> listaAvances;
  
  String? formatoFecha;
  String fechaFormateada = "";
  String selectedItem = "Todos";

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

    listaAvances = proveedorEstado.obtenerAvances(fechaFormateada, fechaFormateada);

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

  Future<void> modalFecha1() async {

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

            listaAvances = proveedorEstado.obtenerAvances(fechaFormateada, fechaFormateada);

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
                            onTap: () => modalFecha1(),
                          ),
                        ),
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
                      child: formatearCelda("Estado\nAvance")
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
                      child: formatearCelda("Hora\nInicio")
                    ),
                    Expanded(
                      flex: 1,
                      child: formatearCelda("Dotación\nTotal")
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: listaAvances,
                builder: (context, AsyncSnapshot<List<Avance>?> snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {

                    return Column(
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
                        const Text("Obteniendo Avances")
                      ],
                    );

                  } else if (snapshot.hasError) {

                    return const Center(child: Text("Error"));

                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {

                    return const Center(child: Text("Sin Avances"));

                  } else {

                    return RefreshIndicator(
                      onRefresh: () async {
                        final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);
                        final nuevaListaAvances = await proveedorEstado.obtenerAvances(fechaFormateada, fechaFormateada);
                        if (mounted) {
                          setState(() {
                            listaAvances = Future.value(nuevaListaAvances);
                          });
                        }
                      },
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 50),
                        children: snapshot.data!.map((avance) {
                      
                          return FilaAvance(avance: avance);
                      
                        }).toList(),
                      ),
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
