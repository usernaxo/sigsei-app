import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/helpers/indicador_deficiente.dart';
import 'package:sigsei/helpers/modulo.dart';
import 'package:sigsei/models/auditoria_bodega.dart';
import 'package:sigsei/models/auditoria_smu.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/providers/proveedor_estado.dart';
import 'package:sigsei/themes/tema.dart';
import 'package:sigsei/widgets/barra_usuario.dart';

class PantallaAuditoriasSmu extends StatefulWidget {

  const PantallaAuditoriasSmu({super.key});

  @override
  PantallaAuditoriasSmuState createState() => PantallaAuditoriasSmuState();

}

class PantallaAuditoriasSmuState extends State<PantallaAuditoriasSmu> {

  bool mostrarAuditoriasSmu = true;
  bool mostrarAuditoriasBodega = false;

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [         
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(7),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: ColoredBox(
                            color: mostrarAuditoriasSmu ? Tema.primary : Colors.black12,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
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
                                  Text(
                                    "Ver Auditorias SMU",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: mostrarAuditoriasSmu ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                    child: InkWell(
                      borderRadius: BorderRadius.circular(7),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: ColoredBox(
                          color: mostrarAuditoriasBodega ? Tema.primary : Colors.black12,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
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
                                Text(
                                  "Ver Auditorias Bodega",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: mostrarAuditoriasBodega ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  @override
  void initState() {

    super.initState();

    final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

    DateTime fechaActual = DateTime.now();

    fechaInicioFormateada = DateFormat("yyyy-MM-dd").format(DateTime(fechaActual.year, fechaActual.month, 1));
    fechaFinFormateada = DateFormat("yyyy-MM-dd").format(DateTime(fechaActual.year, fechaActual.month + 1, 1).subtract(const Duration(days: 1)));

    listaAuditoriasSmu = proveedorEstado.obtenerAuditoriasSmu(fechaInicioFormateada, fechaFinFormateada);

  }

  Future<void> modalRangoFechas(BuildContext context) async {

    DateTime fechaActual = DateTime.now();

    final DateTimeRange? rangoSeleccionado = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime(fechaActual.year, fechaActual.month, 1),
        end: DateTime(fechaActual.year, fechaActual.month + 1, 1).subtract(const Duration(days: 1)),
      ),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      saveText: "Aplicar Fechas",
      helpText: "Seleccionar Fechas",
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width - 80,
                  maxHeight: MediaQuery.sizeOf(context).height - 100
                ),
              child: child
            )
            )
          ],
        );
      },
    );

    if (rangoSeleccionado != null) {

      setState(() {

        String fechaInicio = DateFormat("yyyy-MM-dd").format(rangoSeleccionado.start);
        String fechaFin = DateFormat("yyyy-MM-dd").format(rangoSeleccionado.end);

        fechaInicioFormateada = fechaInicio;
        fechaFinFormateada = fechaFin;

        final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

        listaAuditoriasSmu = proveedorEstado.obtenerAuditoriasSmu(fechaInicio, fechaFin);

      });

    }

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
          fontSize: 10,
          color: Colors.white
        ),
      );

    }

    return Expanded(
      child: Column(
        children: [
          Padding(
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
                                        text: "Desde ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Tema.primary,
                                          fontSize: 12
                                        ),
                                      ),
                                      TextSpan(
                                        text: fechaInicioFormateada,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " Hasta ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Tema.primary,
                                          fontSize: 12
                                        ),
                                      ),
                                      TextSpan(
                                        text: fechaFinFormateada,
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
                          onTap: () => modalRangoFechas(context),
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
                    child: formatearCelda("Estado")
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda("Número")
                  ),
                  Expanded(
                    flex: 2,
                    child: formatearCelda("Local")
                  ),
                  Expanded(
                    flex: 2,
                    child: formatearCelda("Auditor")
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
          Expanded(
            child: FutureBuilder(
                future: listaAuditoriasSmu,
                builder: (context, AsyncSnapshot<List<AuditoriaSmu>?> snapshot) {
                
                  if (snapshot.connectionState == ConnectionState.waiting) {
                
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Tema.primary
                        ),
                        const SizedBox(height: 20),
                        const Text("Obteniendo Auditorias SMU")
                      ],
                    );
                
                  } else if (snapshot.hasError) {
                
                    return const Center(child: Text("Error"));
                
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                
                    return const Center(child: Text("No Existen Auditorias SMU"));
                
                  } else {
                
                    return ListView(
                      padding: const EdgeInsets.only(bottom: 50),
                      children: snapshot.data!.map((auditoriaSmu) {
                
                        return FilaAuditoriaSmu(auditoriaSmu: auditoriaSmu);
                
                      }).toList(),
                    );
                
                  }
                
                },
              ),
          )
          
          
        ]
      ),
    );

  }

}

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

    Widget estadoIndicador(AuditoriaSmu auditoriaSmu) {

      return Icon(
        Icons.circle,
        size: 10,
        color: auditoriaSmu.obtenerHoraInicio != "-" || auditoriaSmu.obtenerHoraInicio!.isEmpty ? Colors.pink : Tema.primaryLight,
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
                child: estadoIndicador(widget.auditoriaSmu)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.auditoriaSmu.obtenerNumero, esBold: true, color: Tema.primary)
              ),
              Expanded(
                flex: 2,
                child: formatearCelda(widget.auditoriaSmu.obtenerNombre, alineacion: TextAlign.start)
              ),
              Expanded(
                flex: 2,
                child: formatearCelda(widget.auditoriaSmu.obtenerAuditor, alineacion: TextAlign.start)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.auditoriaSmu.obtenerPorcentajeConteo, esDeficiente: IndicadorDeficiente.esConteoDeficiente(widget.auditoriaSmu.obtenerPorcentajeConteo!))
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.auditoriaSmu.obtenerPorcentajeChecklist, esDeficiente: IndicadorDeficiente.esChecklistDeficiente(widget.auditoriaSmu.obtenerPorcentajeChecklist!))
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
                        color: mostrarResumenAuditoria ? Colors.blue.shade100 : Colors.transparent,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.assessment_outlined,
                                size: 11,
                                color: Colors.blue,
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
                        mostrarResumenAuditoria = true;
                      });
                    },
                  ),
                ],
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
                fontSize: 10,
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
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            buildRow(["Auditoría - N° ${auditoriaSmu.obtenerNumero}", DateFormat("EEEE d MMM yyyy", "es_ES").format(DateTime.parse(auditoriaSmu.obtenerFecha!))], esBold: true),
            Divider(color: Colors.blue.shade200),
            buildRow(["Local", auditoriaSmu.obtenerNombre!], colorPrimario: true, esBold: true),
            buildRow(["Auditor", auditoriaSmu.obtenerAuditor!]),
            buildRow(["Región", auditoriaSmu.obtenerRegion!]),
            buildRow(["Comuna", auditoriaSmu.obtenerComuna!]),
            buildRow(["Dirección", auditoriaSmu.obtenerDireccion!]),
            Divider(color: Colors.blue.shade200),
            buildRow(["Hora Inicio", auditoriaSmu.obtenerHoraInicio!]),
            buildRow(["Hora Termino", auditoriaSmu.obtenerHoraTermino!]),
            buildRow(["Tiempo Proceso", auditoriaSmu.obtenerTiempoProceso!]),
            Divider(color: Colors.blue.shade200),
            buildRow(["Conteo", auditoriaSmu.obtenerPorcentajeConteo!], esBold: true, esDeficiente: IndicadorDeficiente.esConteoDeficiente(auditoriaSmu.obtenerPorcentajeConteo!)),
            buildRow(["Checklist", auditoriaSmu.obtenerPorcentajeChecklist!], esBold: true, esDeficiente: IndicadorDeficiente.esChecklistDeficiente(auditoriaSmu.obtenerPorcentajeChecklist!)),
          ],
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
  Color colorBarraProgreso = Tema.primary;

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
          if (!descargaIniciada && widget.auditoriaSmu.obtenerMm60!)
            InkWell(
              borderRadius: BorderRadius.circular(7),
              onTap: () async {
                
                descargaIniciada = true;
                archivoDescargando = "MM60";
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
                          "MM60",
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (!descargaIniciada && widget.auditoriaSmu.obtenerZmig43!)
            const SizedBox(width: 5),
          if (!descargaIniciada && widget.auditoriaSmu.obtenerZmig43!)
            InkWell(
              borderRadius: BorderRadius.circular(7),
              onTap: () async {
                
                descargaIniciada = true;
                archivoDescargando = "ZMIG43";
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
                          "ZMIG43",
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

  @override
  void initState() {

    super.initState();

    final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

    DateTime fechaActual = DateTime.now();

    fechaInicioFormateada = DateFormat("yyyy-MM-dd").format(fechaActual.subtract(const Duration(days: 1)));
    fechaFinFormateada = DateFormat("yyyy-MM-dd").format(DateTime(fechaActual.year, fechaActual.month + 1, 1).subtract(const Duration(days: 1)));

    listaAuditoriasBodega = proveedorEstado.obtenerAuditoriasBodega(fechaInicioFormateada, fechaFinFormateada);

  }

  Future<void> modalRangoFechas(BuildContext context) async {

    DateTime fechaActual = DateTime.now();

    final DateTimeRange? rangoSeleccionado = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: fechaActual.subtract(const Duration(days: 1)),
        end: DateTime(fechaActual.year, fechaActual.month + 1, 1).subtract(const Duration(days: 1)),
      ),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      saveText: "Aplicar Fechas",
      helpText: "Seleccionar Fechas",
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width - 80,
                  maxHeight: MediaQuery.sizeOf(context).height - 100
                ),
                child: child
              )
            )
          ],
        );
      },
    );

    if (rangoSeleccionado != null) {

      setState(() {

        String fechaInicio = DateFormat("yyyy-MM-dd").format(rangoSeleccionado.start);
        String fechaFin = DateFormat("yyyy-MM-dd").format(rangoSeleccionado.end);

        fechaInicioFormateada = fechaInicio;
        fechaFinFormateada = fechaFin;

        final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

        listaAuditoriasBodega = proveedorEstado.obtenerAuditoriasBodega(fechaInicio, fechaFin);

      });

    }

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
          fontSize: 10,
          color: Colors.white
        ),
      );

    }

    return Expanded(
      child: Column(
        children: [
          Padding(
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
                                        text: "Desde ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Tema.primary,
                                          fontSize: 12
                                        ),
                                      ),
                                      TextSpan(
                                        text: fechaInicioFormateada,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " Hasta ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Tema.primary,
                                          fontSize: 12
                                        ),
                                      ),
                                      TextSpan(
                                        text: fechaFinFormateada,
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
                          onTap: () => modalRangoFechas(context),
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
                    child: formatearCelda("Estado")
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda("Número")
                  ),
                  Expanded(
                    flex: 2,
                    child: formatearCelda("Local")
                  ),
                  Expanded(
                    flex: 2,
                    child: formatearCelda("Auditor")
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
          Expanded(
            child: FutureBuilder(
                future: listaAuditoriasBodega,
                builder: (context, AsyncSnapshot<List<AuditoriaBodega>?> snapshot) {
                
                  if (snapshot.connectionState == ConnectionState.waiting) {
                
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Tema.primary
                        ),
                        const SizedBox(height: 20),
                        const Text("Obteniendo Auditorias Bodega")
                      ],
                    );
                
                  } else if (snapshot.hasError) {
                
                    return const Center(child: Text("Error"));
                
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                
                    return const Center(child: Text("No Existen Auditorias Bodega"));
                
                  } else {
                
                    return ListView(
                      padding: const EdgeInsets.only(bottom: 50),
                      children: snapshot.data!.map((auditoriaBodega) {
                
                        return FilaAuditoriaBodega(auditoriaBodega: auditoriaBodega);
                
                      }).toList(),
                    );
                
                  }
                
                },
              ),
          )
        ]
      ),
    );

  }

}

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

  bool mostrarResumenAuditoriaBodega = true;
  bool mostrarAvanceAuditoriaBodega = false;
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

    Widget estadoAuditoriaBodega(AuditoriaBodega auditoriaBodega) {

      return Icon(
        Icons.circle,
        size: 10,
        color: auditoriaBodega.obtenerHoraCierre!.isNotEmpty ? Colors.pink : Tema.primaryLight,
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
                child: estadoAuditoriaBodega(widget.auditoriaBodega)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.auditoriaBodega.obtenerNumero, esBold: true, color: Tema.primary)
              ),
              Expanded(
                flex: 2,
                child: formatearCelda(widget.auditoriaBodega.obtenerNombre, alineacion: TextAlign.start)
              ),
              Expanded(
                flex: 2,
                child: formatearCelda(widget.auditoriaBodega.obtenerAuditor, alineacion: TextAlign.start)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.auditoriaBodega.obtenerPorcentajeGeneralAvance)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.auditoriaBodega.obtenerPorcentajeGeneralError, esDeficiente: IndicadorDeficiente.esErrorAbsDeficiente(widget.auditoriaBodega.obtenerPorcentajeGeneralError!))
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
                        color: mostrarResumenAuditoriaBodega ? Colors.blue.shade100 : Colors.transparent,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.assessment_outlined,
                                size: 11,
                                color: Colors.blue,
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
                        mostrarResumenAuditoriaBodega = true;
                        mostrarAvanceAuditoriaBodega = false;
                      });
                    },
                  ),
                  if (widget.auditoriaBodega.obtenerUltimoIndicadorAvance() != null)
                    InkWell(
                      borderRadius: BorderRadius.circular(7),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: ColoredBox(
                          color: mostrarAvanceAuditoriaBodega ? Colors.black12 : Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.timeline_rounded,
                                  size: 11,
                                  color: Tema.primary,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
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
                          mostrarAvanceAuditoriaBodega = true;
                          mostrarResumenAuditoriaBodega = false;
                        });
                      },
                    ),
                ],
              ),
            ),
            if (mostrarResumenAuditoriaBodega)
              ContenidoResumenAuditoriaBodega(auditoriaBodega: widget.auditoriaBodega),
            if (mostrarAvanceAuditoriaBodega)
              ContenidoAvanceAuditoriaBodega(auditoriaBodega: widget.auditoriaBodega),
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

class ContenidoResumenAuditoriaBodega extends StatelessWidget {

  final AuditoriaBodega auditoriaBodega;
  
  const ContenidoResumenAuditoriaBodega({
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
                fontSize: 10,
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
          borderRadius: BorderRadius.circular(10),
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

class ContenidoAvanceAuditoriaBodega extends StatefulWidget {

  final AuditoriaBodega auditoriaBodega;
  
  const ContenidoAvanceAuditoriaBodega({
    super.key,
    required this.auditoriaBodega
  });

  @override
  State<ContenidoAvanceAuditoriaBodega> createState() => _ContenidoAvanceAuditoriaBodegaState();
}

class _ContenidoAvanceAuditoriaBodegaState extends State<ContenidoAvanceAuditoriaBodega> {

  double tamanoLetra = 8;
  double valorSlider = 8;

  @override
  Widget build(BuildContext context) {

    Widget buildRow(List<String> listaCadenas, {bool esBold = false, bool esDeficiente = false, bool esPrimeraSeccion = false}) {

      return Row(
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
                fontWeight: esBold || esDeficiente ? FontWeight.bold : FontWeight.normal,
                color: esDeficiente ? Colors.red : Colors.white
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
          color: Colors.black87,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            buildRow(["Fecha", widget.auditoriaBodega.auditoria!.fechaProgramada!], esPrimeraSeccion: true),
            buildRow(["Avance General", widget.auditoriaBodega.obtenerPorcentajeGeneralAvance!], esPrimeraSeccion: true),
            buildRow(["Error Unidad ABS", widget.auditoriaBodega.obtenerPorcentajeGeneralError!], esPrimeraSeccion: true),
            buildRow(["PTT Cantidad", widget.auditoriaBodega.ultimoIndicadorAvance!.obtenerCantidadPatentes!], esPrimeraSeccion: true),
            buildRow(["PTT Avance", widget.auditoriaBodega.ultimoIndicadorAvance!.obtenerAvancePatentes!], esPrimeraSeccion: true),
            const Divider(color: Colors.white),
            buildRow(["#", "PTT", "SKU", "Descripción", "ZMIG", "SEI", "Dif. U", "Val. A"], esBold: true),
            for (var detalle in widget.auditoriaBodega.obtenerDetallesAvance()!.asMap().entries)
              buildRow([(detalle.key + 1).toString(), detalle.value.patente!, detalle.value.sku!, detalle.value.descripcion!, detalle.value.conteoZmig.toString(), detalle.value.conteoSei.toString(), detalle.value.difUnd.toString(), detalle.value.valorAjuste.toString()]),
            const Divider(color: Colors.white),
            buildRow(["Total", "", "", "", widget.auditoriaBodega.ultimoIndicadorAvance!.obtenerTotalZmig!, widget.auditoriaBodega.ultimoIndicadorAvance!.obtenerTotalSei!, widget.auditoriaBodega.ultimoIndicadorAvance!.obtenerTotalDiferenciaUnidades!, widget.auditoriaBodega.ultimoIndicadorAvance!.obtenerTotalValorAjuste!], esBold: true),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
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
  Color colorBarraProgreso = Tema.primary;

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
          if (!descargaIniciada && widget.auditoriaBodega.obtenerPatente!)
            InkWell(
              borderRadius: BorderRadius.circular(7),
              onTap: () async {
                
                descargaIniciada = true;
                archivoDescargando = "Patentes";
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
                          "Patentes",
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (!descargaIniciada && widget.auditoriaBodega.obtenerZmig43!)
            const SizedBox(width: 5),
          if (!descargaIniciada && widget.auditoriaBodega.obtenerZmig43!)
            InkWell(
              borderRadius: BorderRadius.circular(7),
              onTap: () async {
                
                descargaIniciada = true;
                archivoDescargando = "ZMIG43";
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
                          "ZMIG43",
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (!descargaIniciada && widget.auditoriaBodega.obtenerMuestra!)
            const SizedBox(width: 5),
          if (!descargaIniciada && widget.auditoriaBodega.obtenerMuestra!)
            InkWell(
              borderRadius: BorderRadius.circular(7),
              onTap: () async {
                
                descargaIniciada = true;
                archivoDescargando = "Muestra";
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
                          "Muestra",
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
