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
  bool mostrarConteo = false;
  bool mostrarDiferencias = false;
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

      return Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.circle,
                size: 7,
                color: avance.obtenerHoraEstimadaCierre!.isEmpty ? Tema.secondaryLight : Colors.green
              ),
              const SizedBox(width: 5),
              AnimatedBuilder(
                animation: controladorAnimacionEstadoEnLinea,
                builder: (context, child) {
          
                  return Opacity(
                    opacity: avance.estaEnLinea! ? animacionOpacidadEstadoEnLinea.value : 1.0,
                    child: Text(
                      avance.estaEnLinea! ? "On" : "Off",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: avance.estaEnLinea! ? Colors.green : Colors.grey.shade500,
                        fontSize: 9
                      ),
                    ),
                  );
          
                },
              )
            ],
          ),
        ),
      );

    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: Card(
            elevation: 0,
            color: widget.avance.esDiurna ? Colors.amber.shade50 : null,
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
                    flex: 2,
                    child: estadoAvance(widget.avance)
                  ),
                  Expanded(
                    flex: 2,
                    child: formatearCelda(widget.avance.obtenerNombreCliente!, esBold: true, color: Tema.primary)
                  ),
                  Expanded(
                    flex: 2,
                    child: formatearCelda(widget.avance.obtenerCodigoCeco!, alineacion:  TextAlign.right, esBold: true),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 3,
                    child: formatearCelda(widget.avance.obtenerNombreLocal!, alineacion:  TextAlign.left)
                  ),
                  Expanded(
                    flex: 2,
                    child: formatearCelda(widget.avance.obtenerHoraInicio!)
                  ),
                  Expanded(
                    flex: 2,
                    child: formatearCelda(widget.avance.obtenerHoraInicioReal!, esBold: true)
                  ),
                  Expanded(
                    flex: 2,
                    child: formatearCelda(widget.avance.obtenerPorAvanceUnidades)
                  ),
                  Expanded(
                    flex: 2,
                    child: formatearCelda(widget.avance.obtenerPorNivelError)
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
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(7),
                              child: Material(
                                color: mostrarAvance ? Colors.green.shade50 : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  side: BorderSide(
                                    color: Tema.secondaryLight,
                                    width: 1.5
                                  )
                                ),
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
                              onTap: () {
                                setState(() {
                                  mostrarAvance = true;
                                  mostrarConteo = false;
                                  mostrarDiferencias = false;
                                });
                              },
                            ),
                          ),
                          if (widget.avance.obtenerOperadorRendimiento!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(7),
                                child: Material(
                                  color: mostrarConteo ? Tema.secondaryLight : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    side: BorderSide(
                                      color: Tema.secondaryLight,
                                      width: 1.5
                                    )
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.numbers_rounded,
                                          size: 10,
                                          color: Colors.green,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Conteo",
                                          style: TextStyle(
                                            fontSize: 9
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    mostrarConteo = true;
                                    mostrarAvance = false;
                                    mostrarDiferencias = false;
                                  });
                                },
                              ),
                            ),
                          if (widget.avance.obtenerDiferencias!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(7),
                                child: Material(
                                  color: mostrarDiferencias ? Tema.secondaryLight : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    side: BorderSide(
                                      color: Tema.secondaryLight,
                                      width: 1.5
                                    )
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.swap_horiz_rounded,
                                          size: 10,
                                          color: Colors.green,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Diferencias",
                                          style: TextStyle(
                                            fontSize: 9
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    mostrarDiferencias = true;
                                    mostrarAvance = false;
                                    mostrarConteo = false;
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (mostrarAvance)
                  ContenidoAvance(avance: widget.avance),
                if (mostrarConteo)
                  ContenidoConteo(avance: widget.avance),
                if (mostrarDiferencias)
                  ContenidoDiferencias(avance: widget.avance),
              ],
              onExpansionChanged: (value) {

                setState(() {

                  filaExpandida = value;

                });
                
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
              side: BorderSide(
                color: Tema.primaryLight,
              )
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.avance.esDiurna ? "Diurno" : "Nocturno",
                    style: const TextStyle(
                      fontSize: 7,
                      color: Colors.grey
                    )
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    widget.avance.esDiurna ? Icons.wb_sunny_rounded : Icons.nights_stay,
                    size: 6,
                    color: widget.avance.esDiurna ? Colors.amber : Colors.blue.shade300,
                  )
                ],
              ),
            ),
          ),
        )
      ],
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
      child: Material(
        color: Colors.green.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
          side: BorderSide(
            color: Tema.secondaryLight,
            width: 1.5
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Avance de Inventario",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold
                      ),
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
              Divider(color: Colors.green.shade100),
              buildRow(["Hora de inicio programada", "", avance.obtenerHoraInicio!]),
              buildRow(["Hora de comienzo", "", avance.obtenerHoraInicioReal!]),
              buildRow(["Dotación total", "", avance.obtenerDotacion!]),
              Divider(color: Colors.green.shade100),
              buildRow(["Stock Teórico", avance.obtenerCantidadTeorica, "100.00 %"]),
              buildRow(["Avance Uni. Contadas", avance.obtenerCantidadFisica, avance.obtenerPorAvanceUnidades]),
              buildRow(["Avance Sala", "", avance.obtenerPorAvanceSala]),
              buildRow(["Avance Bodega", "", avance.obtenerPorAvanceBodega]),
              Divider(color: Colors.green.shade100),
              buildRow(["Auditoría", "", "Avance %"], esBold: true, color: Tema.primary),
              buildRow(["Avance Items", "", avance.obtenerPorAvanceAuditoria]),
              buildRow(["Error", "", avance.obtenerPorNivelError]),
              Divider(color: Colors.green.shade100),
              buildRow(["Líder SEI", avance.nombreLider!]),
            ],
          ),
        ),
      ),
    );

  }

}

class ContenidoConteo extends StatefulWidget {

  final Avance avance;
  
  const ContenidoConteo({
    super.key,
    required this.avance
  });

  @override
  State<ContenidoConteo> createState() => _ContenidoConteoState();

}

class _ContenidoConteoState extends State<ContenidoConteo> {

  double tamanoLetra = 8;
  double valorSlider = 8;

  @override
  Widget build(BuildContext context) {

    Widget buildRow(List<String> listaCadenas, {bool esBold = false, bool esPrimeraSeccion = false, esFilaDeTabla = false}) {

      return Padding(
        padding: esFilaDeTabla ? const EdgeInsets.all(1) : EdgeInsets.zero,
        child: Row(
          children: listaCadenas.asMap().entries.map((entry) {
        
            final cadena = entry.value;
            final indice = entry.key;
        
            return Expanded(
              flex: esPrimeraSeccion ? 1 : (indice == 0 ? 1 : (indice == 1 ? 10 : 5)),
              child: Text(
                cadena,
                textAlign: esPrimeraSeccion ? (indice < 1 ? TextAlign.start : TextAlign.end) : (indice < 2 ? TextAlign.start : TextAlign.end),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: tamanoLetra,
                  fontWeight: esBold ? FontWeight.bold : FontWeight.normal,
                  color: Colors.white
                )
              ),
            );
            
          }).toList(),
        ),
      );

    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
          side: BorderSide(
            color: Tema.secondaryLight,
            width: 1.5
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              buildRow(["Conteo Unidades - ${widget.avance.obtenerNombreCliente} ${widget.avance.obtenerCodigoCeco}"], esBold: true, esPrimeraSeccion: true),
              const Divider(color: Colors.white),
              buildRow(["#", "Auditor", "Conteo"], esBold: true, esFilaDeTabla: true),
              for (var operador in widget.avance.obtenerOperadorRendimiento!.asMap().entries)
                buildRow([(operador.key + 1).toString(), operador.value.obtenerNombre!, operador.value.obtenerCantidad!], esFilaDeTabla: true),
              const Divider(color: Colors.white),
              buildRow(["Totales", widget.avance.obtenerOperadorRendimientoTotales!], esBold: true, esPrimeraSeccion: true),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.format_size_rounded,
                      color: Colors.green.shade300,
                      size: 10,
                    ),
                    Expanded(
                      child: Slider(
                        activeColor: Colors.green.shade300,
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
      ),
    );

  }

}

class ContenidoDiferencias extends StatefulWidget {

  final Avance avance;
  
  const ContenidoDiferencias({
    super.key,
    required this.avance
  });

  @override
  State<ContenidoDiferencias> createState() => _ContenidoDiferenciasState();

}

class _ContenidoDiferenciasState extends State<ContenidoDiferencias> {

  double tamanoLetra = 8;
  double valorSlider = 8;

  @override
  Widget build(BuildContext context) {

    Widget buildRow(List<String> listaCadenas, {bool esBold = false, bool esPrimeraSeccion = false, esFilaDeTabla = false}) {

      return Padding(
        padding: esFilaDeTabla ? const EdgeInsets.all(1) : EdgeInsets.zero,
        child: Row(
          children: listaCadenas.asMap().entries.map((entry) {
        
            final cadena = entry.value;
            final indice = entry.key;

            return Expanded(
              flex: esPrimeraSeccion ? 1 : (indice == 0 ? 1 : (indice == 4 || indice == 5 || indice == 6 ? 2 : (indice == 1 ? 2 : 3))),
              child: Text(
                cadena,
                textAlign: esPrimeraSeccion ? (indice < 1 ? TextAlign.start : TextAlign.end) : (indice < 4 ? TextAlign.start : TextAlign.end),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: tamanoLetra,
                  fontWeight: esBold ? FontWeight.bold : FontWeight.normal,
                  color: Colors.white
                )
              ),
            );
            
          }).toList(),
        ),
      );

    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
          side: BorderSide(
            color: Tema.secondaryLight,
            width: 1.5
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              buildRow(["Diferencias - ${widget.avance.obtenerNombreCliente} ${widget.avance.obtenerCodigoCeco}"], esPrimeraSeccion: true, esBold: true),
              const Divider(color: Colors.white),
              buildRow(["#", "SKU", "Barra", "Producto", "Físico", "Teórico", "Dif. U", "Dif. V"], esBold: true, esFilaDeTabla: true),
              for (var diferencia in widget.avance.obtenerDiferencias!.asMap().entries)
                buildRow([(diferencia.key + 1).toString(), diferencia.value.obtenerSku!, diferencia.value.obtenerBarra!, diferencia.value.obtenerProducto!, diferencia.value.obtenerFisico!, diferencia.value.obtenerTeorico!, diferencia.value.obtenerDiferencia!, "\$ ${diferencia.value.obtenerDiferenciaValorizada!}"], esFilaDeTabla: true),
              const Divider(color: Colors.white),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.format_size_rounded,
                      color: Colors.green.shade300,
                      size: 10,
                    ),
                    Expanded(
                      child: Slider(
                        activeColor: Colors.green.shade300,
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
      ),
    );

  }

}