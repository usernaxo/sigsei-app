import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/helpers/modal_fecha.dart';
import 'package:sigsei/models/modulo.dart';
import 'package:sigsei/models/inventario_general.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/providers/proveedor_estado.dart';
import 'package:sigsei/themes/tema.dart';
import 'package:sigsei/widgets/pantalla_general/barra_usuario.dart';
import 'package:sigsei/widgets/pantalla_general/menu_usuario.dart';
import 'package:sigsei/widgets/pantalla_inventario_general/fila_inventario_general.dart';

class PantallaInventarioGeneral extends StatefulWidget {

  const PantallaInventarioGeneral({super.key});

  @override
  PantallaInventarioGeneralState createState() => PantallaInventarioGeneralState();

}

class PantallaInventarioGeneralState extends State<PantallaInventarioGeneral> {

  final GlobalKey<ScaffoldState> clavePantallaInventarioGeneral = GlobalKey<ScaffoldState>();
  final GlobalKey claveMenuFiltro = GlobalKey();

  late Future<List<InventarioGeneral>?> listaInventarioGeneral;

  List<InventarioGeneral>? inventarios;
  List<String> filtros = ["Todos", "Diurnos", "Nocturnos"];

  Size? tamanoMenuFiltro;
  
  String fechaInicioFormateada = "";
  String fechaFinFormateada = "";
  String filtroSeleccionado = "Todos";

  bool menuFiltroAbierto = false;
  bool inventariosGeneralesCargados = false;

  @override
  void initState() {

    super.initState();

    final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

    DateTime fechaActual = DateTime.now();

    fechaInicioFormateada = DateFormat("yyyy-MM-dd").format(fechaActual);
    fechaFinFormateada = DateFormat("yyyy-MM-dd").format(fechaActual);

    if (fechaActual.weekday == DateTime.monday) {

      fechaInicioFormateada = DateFormat("yyyy-MM-dd").format(fechaActual.subtract(const Duration(days: 3)));
      fechaFinFormateada = DateFormat("yyyy-MM-dd").format(fechaActual.subtract(const Duration(days: 3)));

    } else if (fechaActual.weekday == DateTime.saturday) {

      fechaInicioFormateada = DateFormat("yyyy-MM-dd").format(fechaActual.subtract(const Duration(days: 1)));
      fechaFinFormateada = DateFormat("yyyy-MM-dd").format(fechaActual.subtract(const Duration(days: 1)));

    } else if (fechaActual.weekday == DateTime.sunday) {

      fechaInicioFormateada = DateFormat("yyyy-MM-dd").format(fechaActual.subtract(const Duration(days: 2)));
      fechaFinFormateada = DateFormat("yyyy-MM-dd").format(fechaActual.subtract(const Duration(days: 2)));

    } else {

      fechaInicioFormateada = DateFormat("yyyy-MM-dd").format(fechaActual);
      fechaFinFormateada = DateFormat("yyyy-MM-dd").format(fechaActual);

    }

    listaInventarioGeneral = proveedorEstado.obtenerInventarioGeneral(fechaInicioFormateada, fechaFinFormateada);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      obtenerTamanoMenuFiltro();

    });

  }

  Future<void> modalRangoFechas() async {

    ModalFecha(
      context: context,
      tipoModalFecha: ModalFecha.rango,
      fechaInicio: DateTime.parse(fechaInicioFormateada),
      fechaFin: DateTime.parse(fechaFinFormateada),
      fechaSeleccionada: (fechaInicio, fechaFin) {

        if (fechaInicio != null && fechaFin != null) {

          setState(() {

            String fechaDesde = DateFormat("yyyy-MM-dd").format(fechaInicio);
            String fechaHasta = DateFormat("yyyy-MM-dd").format(fechaFin);

            fechaInicioFormateada = fechaDesde;
            fechaFinFormateada = fechaHasta;

            final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

            listaInventarioGeneral = proveedorEstado.obtenerInventarioGeneral(fechaDesde, fechaHasta);

            inventariosGeneralesCargados = false;

          });

        }

      },
    ).show();

  }

  void obtenerTamanoMenuFiltro() {

    final context = claveMenuFiltro.currentContext;

    if (context != null) {

      final tamano = context.size;

      setState(() {

        tamanoMenuFiltro = tamano;

      });

    }

  }

  @override
  Widget build(BuildContext context) {

    final argumentos = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Modulo modulo = argumentos["modulo"];
    Usuario usuario = argumentos["usuario"];

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

    return Scaffold(
      key: clavePantallaInventarioGeneral,
      drawer: MenuUsuario(usuario: usuario),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                BarraUsuario(usuario: usuario, claveMenu: clavePantallaInventarioGeneral, botonRetroceso: true),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    color: Tema.secondaryLight,
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Material(
                                color: Tema.primaryLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  side: BorderSide(
                                    color: Tema.secondaryLight,
                                    width: 1.5
                                  )
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(7),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                                                  text: "Desde ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Tema.primary,
                                                    fontSize: 11
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: fechaInicioFormateada,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: " Hasta ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Tema.primary,
                                                    fontSize: 11
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: fechaFinFormateada,
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
                                  onTap: () => modalRangoFechas(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              key: claveMenuFiltro,
                              child: Material(
                                color: Tema.primaryLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  side: BorderSide(
                                    color: Tema.secondaryLight,
                                    width: 1.5
                                  )
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(7),
                                  onTap: () {
                                                              
                                    setState(() {
                                                              
                                      menuFiltroAbierto = !menuFiltroAbierto;
                                                              
                                    });
                                                              
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          filtroSeleccionado == "Todos" ? Icons.fact_check_outlined : filtroSeleccionado == "Diurnos" ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                                          color: filtroSeleccionado == "Diurnos" ? Colors.amber : Tema.primary,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          filtroSeleccionado,
                                          style: const TextStyle(
                                            fontSize: 11
                                          ),
                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.arrow_drop_down_rounded,
                                          color: Tema.primary,
                                          size: 15,
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Tema.primary,
                      borderRadius: BorderRadius.circular(7)
                    ),
                    child: Row(
                      children: [
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
                          child: formatearCelda("Dotación\nTotal")
                        ),
                        Expanded(
                          flex: 1,
                          child: formatearCelda("Stock\nConteo")
                        ),
                        Expanded(
                          flex: 1,
                          child: formatearCelda("Estado\nNómina")
                        ),
                        Expanded(
                          flex: 1,
                          child: formatearCelda("Estado\nReporte")
                        ),
                      ],
                    ),
                  ),
                ),
                FutureBuilder(
                  future: listaInventarioGeneral,
                  builder: (context, AsyncSnapshot<List<InventarioGeneral>?> snapshot) {
                
                    if (snapshot.connectionState == ConnectionState.waiting || inventariosGeneralesCargados == false) {
                
                      inventariosGeneralesCargados = true;
                
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
                            const Text("Obteniendo Inventarios")
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
                            color: Tema.primaryLight,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: Tema.secondaryLight,
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
                                "Sin Inventarios Programados",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500
                                ),
                              ),
                              Text(
                                "Desde $fechaInicioFormateada Hasta $fechaFinFormateada",
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
                
                      inventarios = filtroSeleccionado == "Diurnos" ? snapshot.data!.where((i) => !i.esNoche!).toList() : filtroSeleccionado == "Nocturnos" ? snapshot.data!.where((i) => i.esNoche!).toList() : snapshot.data;

                      if (inventarios!.isEmpty) {

                        return Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Tema.primaryLight,
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: Tema.secondaryLight,
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
                                  "Sin Inventarios $filtroSeleccionado",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade500
                                  ),
                                ),
                                Text(
                                  "Desde $fechaInicioFormateada Hasta $fechaFinFormateada",
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

                      }

                      return Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);
                            final nuevaListaInventarioGeneral = await proveedorEstado.obtenerInventarioGeneral(fechaInicioFormateada, fechaFinFormateada);
                            if (mounted) {
                              setState(() {
                                listaInventarioGeneral = Future.value(nuevaListaInventarioGeneral);
                              });
                            }
                          },
                          child: ListView(
                            padding: const EdgeInsets.only(bottom: 50),
                            children: inventarios!.map((inventarioGeneral) {
                          
                              return FilaInventarioGeneral(inventarioGeneral: inventarioGeneral);
                          
                            }).toList(),
                          ),
                        ),
                      );
                
                    }
                
                  },
                )
              ]
            ),
            if (menuFiltroAbierto)
              Positioned(
                top: (claveMenuFiltro.currentContext?.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dy + 5,
                left: (claveMenuFiltro.currentContext?.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dx,
                child: Container(
                  width: tamanoMenuFiltro?.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: Tema.primaryLight,
                      width: 1.5
                    )
                  ),
                  child: Column(
                    children: filtros.map((filtro) {
                      return Material(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(
                                  filtro == "Todos" ? Icons.fact_check_outlined : filtro == "Diurnos" ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                                  color: filtro == "Diurnos" ? Colors.amber : Tema.primary,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  filtro,
                                  style: const TextStyle(
                                    fontSize: 11
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                        
                            setState(() {
                        
                              filtroSeleccionado = filtro;
                              menuFiltroAbierto = false;
                        
                            });
                        
                          },
                        ),
                      );
                    }).toList(),
                  )
                ),
              ),
          ],
        ),
      )
    );

  }

}
