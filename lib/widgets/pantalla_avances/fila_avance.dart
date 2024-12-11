import 'package:flutter/material.dart';
import 'package:sigsei/models/avance.dart';
import 'package:sigsei/themes/tema.dart';

class FilaAvance extends StatefulWidget {

  final Avance avance;

  const FilaAvance({
    super.key,
    required this.avance
  });

  @override
  State<FilaAvance> createState() => _FilaAvanceState();

}

class _FilaAvanceState extends State<FilaAvance> with SingleTickerProviderStateMixin {

  late AnimationController controladorAnimacionEstadoEnLinea;
  late Animation<double> animacionOpacidadEstadoEnLinea;

  bool mostrarAvance = true;
  bool filaExpandida = false;

  @override
  void initState() {

    super.initState();

    controladorAnimacionEstadoEnLinea = AnimationController(duration: const Duration(milliseconds: 500), vsync: this)..repeat(reverse: true);

    animacionOpacidadEstadoEnLinea = Tween<double>(begin: 0.3, end: 1.0).animate(controladorAnimacionEstadoEnLinea);

  }

  @override
  void dispose() {

    controladorAnimacionEstadoEnLinea.dispose();

    super.dispose();

  }

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

    Widget estadoAvance(Avance avance) {

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.circle,
            size: 7,
            color: avance.obtenerHoraEstimadaCierre!.isEmpty ? Colors.red : Colors.green
          ),
          const SizedBox(width: 5),
          AnimatedBuilder(
            animation: controladorAnimacionEstadoEnLinea,
            builder: (context, child) {

              return Opacity(
                opacity: avance.estaEnLinea! ? animacionOpacidadEstadoEnLinea.value : 1.0,
                child: Text(
                  avance.estaEnLinea! ? "Online" : "Offline",
                  style: TextStyle(
                    color: avance.estaEnLinea! ? Colors.green : Colors.grey.shade500,
                    fontSize: 9
                  ),
                ),
              );

            },
          )
        ],
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
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Tema.primaryLight,
              width: 2
            ),
            borderRadius: BorderRadius.circular(7)
          ),
          title: Row(
            children: [
              Expanded(
                flex: 1,
                child: estadoAvance(widget.avance)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.avance.obtenerNombreCliente!, esBold: true, color: Tema.primary)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.avance.obtenerCodigoCeco!, alineacion:  TextAlign.right, esBold: true),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 2,
                child: formatearCelda(widget.avance.obtenerNombreLocal!, alineacion:  TextAlign.left)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.avance.obtenerHoraInicioReal!)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.avance.obtenerPorAvanceUnidades)
              ),
              Expanded(
                flex: 1,
                child: formatearCelda(widget.avance.obtenerDotacion!)
              )
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
                        color: mostrarAvance ? Colors.green.shade100 : Colors.transparent,
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
                    ),
                    onTap: () {
                      setState(() {
                        mostrarAvance = true;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (mostrarAvance)
              ContenidoAvance(avance: widget.avance),
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

  final Avance avance;
  
  const ContenidoAvance({
    super.key,
    required this.avance
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 9,
          fontWeight: esBold ? FontWeight.bold : FontWeight.normal,
        )
      );

    }

    Widget progresoAvance() {

      double? porcentajeAvance = double.tryParse(avance.obtenerPorAvanceUnidades.replaceAll("%", ""));

      if (porcentajeAvance != null) {

        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 5),
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
                    "${avance.obtenerPorAvanceUnidades.split(".")[0]} %",
                    style: const TextStyle(
                      fontSize: 10, 
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
          borderRadius: BorderRadius.circular(7),
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
                      Divider(color: Colors.green.shade200),
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
                      Divider(color: Colors.green.shade200),
                      formatearCadena(avance.horaInicioProgramada!),
                      formatearCadena(avance.horaInicioReal!),
                      formatearCadena(avance.dotacionDiferencia!),
                    ],
                  ),
                ),
                progresoAvance()
              ],
            ),
            Divider(color: Colors.green.shade200),
            buildRow(["Stock Teórico", avance.obtenerCantidadTeorica, "100.00 %"]),
            buildRow(["Avance Uni. Contadas", avance.obtenerCantidadFisica, avance.obtenerPorAvanceUnidades]),
            buildRow(["Avance Sala", "", avance.obtenerPorAvanceSala]),
            buildRow(["Avance Bodega", "", avance.obtenerPorAvanceBodega]),
            Divider(color: Colors.green.shade200),
            buildRow(["Auditoría", "", "Avance %"], esBold: true),
            buildRow(["Avance Items", "", avance.obtenerPorAvanceAuditoria]),
            buildRow(["Error", "", avance.obtenerPorNivelError]),
            Divider(color: Colors.green.shade200),
            buildRow(["Jefe Local", ""]),
            buildRow(["Líder SEI", avance.nombreLider!]),
          ],
        ),
      ),
    );

  }

}
