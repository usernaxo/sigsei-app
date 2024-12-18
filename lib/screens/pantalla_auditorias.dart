import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/helpers/modal_fecha.dart';
import 'package:sigsei/models/modulo.dart';
import 'package:sigsei/models/auditoria_bodega.dart';
import 'package:sigsei/models/auditoria_smu.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/providers/proveedor_estado.dart';
import 'package:sigsei/themes/tema.dart';
import 'package:sigsei/widgets/pantalla_auditorias/fila_auditoria_bodega.dart';
import 'package:sigsei/widgets/pantalla_auditorias/fila_auditoria_smu.dart';
import 'package:sigsei/widgets/pantalla_general/barra_usuario.dart';
import 'package:sigsei/widgets/pantalla_general/menu_usuario.dart';

class PantallaAuditorias extends StatefulWidget {

  const PantallaAuditorias({super.key});

  @override
  PantallaAuditoriasState createState() => PantallaAuditoriasState();

}

class PantallaAuditoriasState extends State<PantallaAuditorias> {

  final GlobalKey<ScaffoldState> clavePantallaAuditorias = GlobalKey<ScaffoldState>();

  bool mostrarAuditoriasSmu = false;
  bool mostrarAuditoriasBodega = true;

  @override
  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    final argumentos = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Modulo modulo = argumentos["modulo"];
    Usuario usuario = argumentos["usuario"];

    return Scaffold(
      key: clavePantallaAuditorias,
      drawer: MenuUsuario(usuario: usuario),
      body: SafeArea(
        child: Column(
          children: [
            BarraUsuario(usuario: usuario, claveMenu: clavePantallaAuditorias, botonRetroceso: true),
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
                color: Tema.secondaryLight
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: [         
                  Expanded(
                    child: Material(
                      color: mostrarAuditoriasSmu ? Tema.primary : Tema.primaryLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                        side: BorderSide(
                          color: Tema.secondaryLight,
                          width: 1.5
                        )
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(7),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.content_paste_search_rounded,
                                size: 11,
                                color: mostrarAuditoriasSmu ? Colors.white : Tema.primary,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  "Ver Auditorias SMU",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: mostrarAuditoriasSmu ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            mostrarAuditoriasSmu = true;
                            mostrarAuditoriasBodega = false;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Material(
                      color: mostrarAuditoriasBodega ? Tema.primary : Tema.primaryLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                        side: BorderSide(
                          color: Tema.secondaryLight,
                          width: 1.5
                        )
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(7),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.content_paste_search_rounded,
                                size: 11,
                                color: mostrarAuditoriasBodega ? Colors.white : Tema.primary,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  "Ver Auditorias Bodega",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: mostrarAuditoriasBodega ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            mostrarAuditoriasBodega = true;
                            mostrarAuditoriasSmu = false;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (mostrarAuditoriasSmu)
              const AuditoriasSmu(),
            if (mostrarAuditoriasBodega)
              const AuditoriasBodega()
          ]
        ),
      )
    );

  }

}

class AuditoriasSmu extends StatefulWidget {

  const AuditoriasSmu({
    super.key,
  });

  @override
  State<AuditoriasSmu> createState() => _AuditoriasSmuState();

}

class _AuditoriasSmuState extends State<AuditoriasSmu> {

  late Future<List<AuditoriaSmu>?> listaAuditoriasSmu;

  String fechaInicioFormateada = "";
  String fechaFinFormateada = "";

  bool auditoriasSmuCargadas = false;

  @override
  void initState() {

    super.initState();

    final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

    DateTime fechaActual = DateTime.now();

    fechaInicioFormateada = DateFormat("yyyy-MM-dd").format(DateTime(fechaActual.year, fechaActual.month, 1));
    fechaFinFormateada = DateFormat("yyyy-MM-dd").format(DateTime(fechaActual.year, fechaActual.month + 1, 1).subtract(const Duration(days: 1)));

    listaAuditoriasSmu = proveedorEstado.obtenerAuditoriasSmu(fechaInicioFormateada, fechaFinFormateada);

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

            listaAuditoriasSmu = proveedorEstado.obtenerAuditoriasSmu(fechaDesde, fechaHasta);

            auditoriasSmuCargadas = false;

          });

        }

      },
    ).show();

  }

  @override
  Widget build(BuildContext context) {

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

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
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
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Tema.primary,
                borderRadius: BorderRadius.circular(7)
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: formatearCelda("Estado")
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda("Número")
                  ),
                  Expanded(
                    flex: 2,
                    child: formatearCelda("Nombre Local")
                  ),
                  Expanded(
                    flex: 2,
                    child: formatearCelda("Nombre Auditor")
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda("Conteo")
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda("Checklist")
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: listaAuditoriasSmu,
            builder: (context, AsyncSnapshot<List<AuditoriaSmu>?> snapshot) {
            
              if (snapshot.connectionState == ConnectionState.waiting || auditoriasSmuCargadas == false) {
          
                auditoriasSmuCargadas = true;
          
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
                      const Text(
                        "Obteniendo Auditorias SMU",
                        textAlign: TextAlign.center
                      )
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
                          "Sin Auditorías SMU Programadas",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500
                          ),
                        ),
                        Text(
                          "Desde $fechaInicioFormateada Hasta $fechaFinFormateada",
                          textAlign: TextAlign.center,
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
            
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);
                      final nuevaListaAuditoriasSmu = await proveedorEstado.obtenerAuditoriasSmu(fechaInicioFormateada, fechaFinFormateada);
                      if (mounted) {
                        setState(() {
                          listaAuditoriasSmu = Future.value(nuevaListaAuditoriasSmu);
                        });
                      }
                    },
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 50),
                      children: snapshot.data!.map((auditoriaSmu) {
                                    
                        return FilaAuditoriaSmu(auditoriaSmu: auditoriaSmu);
                                    
                      }).toList(),
                    ),
                  ),
                );
            
              }
            
            },
          )
        ]
      ),
    );

  }

}

class AuditoriasBodega extends StatefulWidget {

  const AuditoriasBodega({
    super.key,
  });

  @override
  State<AuditoriasBodega> createState() => _AuditoriasBodegaState();

}

class _AuditoriasBodegaState extends State<AuditoriasBodega> {

  late Future<List<AuditoriaBodega>?> listaAuditoriasBodega;

  String fechaInicioFormateada = "";
  String fechaFinFormateada = "";

  bool auditoriasBodegaCargadas = false;

  @override
  void initState() {

    super.initState();

    final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

    DateTime fechaActual = DateTime.now();

    fechaInicioFormateada = DateFormat("yyyy-MM-dd").format(fechaActual);
    fechaFinFormateada = DateFormat("yyyy-MM-dd").format(fechaActual);

    listaAuditoriasBodega = proveedorEstado.obtenerAuditoriasBodega(fechaInicioFormateada, fechaFinFormateada);

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

            listaAuditoriasBodega = proveedorEstado.obtenerAuditoriasBodega(fechaDesde, fechaHasta);

            auditoriasBodegaCargadas = false;

          });

        }

      },
    ).show();

  }

  @override
  Widget build(BuildContext context) {

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

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
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
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Tema.primary,
                borderRadius: BorderRadius.circular(7)
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: formatearCelda("Estado")
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda("Número")
                  ),
                  Expanded(
                    flex: 2,
                    child: formatearCelda("Nombre Local")
                  ),
                  Expanded(
                    flex: 2,
                    child: formatearCelda("Nombre Auditor")
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda("Avance")
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda("Error")
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder(
              future: listaAuditoriasBodega,
              builder: (context, AsyncSnapshot<List<AuditoriaBodega>?> snapshot) {
              
                if (snapshot.connectionState == ConnectionState.waiting || auditoriasBodegaCargadas == false) {
          
                  auditoriasBodegaCargadas = true;
          
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
                        const Text(
                          "Obteniendo Auditorias Bodega",
                          textAlign: TextAlign.center,
                        )
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
                            "Sin Auditorías Bodega Programadas",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500
                            ),
                          ),
                          Text(
                            "Desde $fechaInicioFormateada Hasta $fechaFinFormateada",
                            textAlign: TextAlign.center,
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
                  
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);
                        final nuevaListaAuditoriasBodega = await proveedorEstado.obtenerAuditoriasBodega(fechaInicioFormateada, fechaFinFormateada);
                        if (mounted) {
                          setState(() {
                            listaAuditoriasBodega = Future.value(nuevaListaAuditoriasBodega);
                          });
                        }
                      },
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 50),
                        children: snapshot.data!.map((auditoriaBodega) {
                                      
                          return FilaAuditoriaBodega(auditoriaBodega: auditoriaBodega);
                                      
                        }).toList(),
                      ),
                    ),
                  );
              
                }
              
              },
            )
        ]
      ),
    );

  }

}
