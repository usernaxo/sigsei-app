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

      double? porcentajeAvance = double.tryParse(avance.obtenerPorAvanceUnidades.replaceAll("%", ""));

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
                const Text(
                  "Avance de Inventario",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold
                  ),
                ),
                progresoAvance(),
                Text(
                  avance.obtenerPorAvanceUnidades,
                  style:  TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Tema.primary
                  ),
                )
              ],
            ),
            Divider(color: Colors.green.shade200),
            buildRow(["Hora de inicio programada", "", avance.obtenerHoraInicio!]),
            buildRow(["Hora de comienzo", "", avance.obtenerHoraInicioReal!]),
            buildRow(["Dotación total", "", avance.obtenerDotacion!]),
            Divider(color: Colors.green.shade200),
            buildRow(["Stock Teórico", avance.obtenerCantidadTeorica, "100.00 %"]),
            buildRow(["Avance Uni. Contadas", avance.obtenerCantidadFisica, avance.obtenerPorAvanceUnidades]),
            buildRow(["Avance Sala", "", avance.obtenerPorAvanceSala]),
            buildRow(["Avance Bodega", "", avance.obtenerPorAvanceBodega]),
            Divider(color: Colors.green.shade200),
            buildRow(["Auditoría", "", "Avance %"], esBold: true, color: Tema.primary),
            buildRow(["Avance Items", "", avance.obtenerPorAvanceAuditoria]),
            buildRow(["Error", "", avance.obtenerPorNivelError]),
            Divider(color: Colors.green.shade200),
            buildRow(["Líder SEI", avance.nombreLider!]),
          ],
        ),
      ),
    );

  }

}
