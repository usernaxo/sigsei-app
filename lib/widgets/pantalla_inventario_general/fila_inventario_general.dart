import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sigsei/models/inventario_general.dart';
import 'package:sigsei/themes/tema.dart';

class FilaInventarioGeneral extends StatefulWidget {

  final InventarioGeneral inventarioGeneral;

  const FilaInventarioGeneral({
    super.key,
    required this.inventarioGeneral
  });

  @override
  State<FilaInventarioGeneral> createState() => _FilaInventarioGeneralState();

}

class _FilaInventarioGeneralState extends State<FilaInventarioGeneral> {

  bool mostrarResumen = true;
  bool mostrarOperadores = false;
  bool mostrarUbicacion = false;
  bool filaExpandida = false;

  @override
  Widget build(BuildContext context) {

    Widget formatearCelda(String cadena, {alineacion = TextAlign.center, esBold = false, esDeficiente = false, color = Colors.black, backgroundColor = Colors.transparent, esColorida = false, double fontSize = 9}) {

      return esColorida ? Container(
        padding: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(2)
        ),
        child: Text(
          cadena,
          textAlign: alineacion,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: FontWeight.bold
          ),
        ),
      ) : Text(
        cadena,
        textAlign: alineacion,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize,
          color: esDeficiente ? Colors.red : color,
          fontWeight: esBold || esDeficiente ? FontWeight.bold : FontWeight.normal
        ),
      );

    }

    Widget estadoIndicador(bool estadoInventarioVerde) {

      return Icon(
        Icons.circle,
        size: 7,
        color: estadoInventarioVerde ? Colors.green : Colors.red,
      );

    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: Card(
            elevation: 0,
            color: widget.inventarioGeneral.esNoche! ? null : Colors.amber.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
              side: BorderSide(
                color: Tema.primaryLight
              )
            ),
            margin: const EdgeInsets.all(3),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              minTileHeight: 10,
              childrenPadding: EdgeInsets.zero,
              showTrailingIcon: false,
              title: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: formatearCelda(widget.inventarioGeneral.obtenerNombreCliente!, esBold: true, color: Tema.primary)
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda(widget.inventarioGeneral.localCeco!, alineacion:  TextAlign.right, esBold: true),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 2,
                    child: formatearCelda(widget.inventarioGeneral.localNombre!, alineacion:  TextAlign.left)
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda(widget.inventarioGeneral.obtenerDotacionTotal!)
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda(widget.inventarioGeneral.obtenerStockConteo!)
                  ),
                  Expanded(
                    flex: 1,
                    child: formatearCelda(widget.inventarioGeneral.obtenerEstadoNomina["estado"], backgroundColor: widget.inventarioGeneral.obtenerEstadoNomina["backgroundColor"], color: widget.inventarioGeneral.obtenerEstadoNomina["fontColor"], esColorida: true, esBold: true, fontSize: 7)
                  ),
                  Expanded(
                    flex: 1,
                    child: estadoIndicador(widget.inventarioGeneral.estadoInventarioVerde!)
                  ),
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
                            padding: const EdgeInsets.only(right: 5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(7),
                              child: Material(
                                color: mostrarResumen ? Colors.teal.shade50 : Colors.transparent,
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
                                        Icons.fact_check_outlined,
                                        size: 10,
                                        color: Colors.teal,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Inventario",
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
                                  mostrarResumen = true;
                                  mostrarOperadores = false;
                                  mostrarUbicacion = false;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(7),
                              onTap: () {
                                setState(() {
                                  mostrarOperadores = true;
                                  mostrarResumen = false;
                                  mostrarUbicacion = false;
                                });
                              },
                              child: Material(
                                color: mostrarOperadores ? Tema.secondaryLight : Colors.transparent,
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
                                        Icons.people_alt_rounded,
                                        size: 10,
                                        color: Colors.teal,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Operadores",
                                        style: TextStyle(
                                          fontSize: 9
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(7),
                              onTap: () {
                                setState(() {
                                  mostrarUbicacion = true;
                                  mostrarOperadores = false;
                                  mostrarResumen = false;
                                });
                              },
                              child: Material(
                                color: mostrarUbicacion ? Tema.secondaryLight : Colors.transparent,
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
                                        Icons.location_on_rounded,
                                        size: 10,
                                        color: Colors.teal,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Ubicación",
                                        style: TextStyle(
                                          fontSize: 9
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                if (mostrarResumen)
                  ContenidoResumenInventario(inventarioGeneral: widget.inventarioGeneral),
                if (mostrarOperadores)
                  ContenidoOperadores(inventarioGeneral: widget.inventarioGeneral),
                if (mostrarUbicacion)
                  ContenidoUbicacion(inventarioGeneral: widget.inventarioGeneral),
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
                    widget.inventarioGeneral.esNoche! ? "Nocturno" : "Diurno",
                    style: const TextStyle(
                      fontSize: 7,
                      color: Colors.grey
                    )
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    widget.inventarioGeneral.esNoche! ? Icons.nights_stay : Icons.wb_sunny_rounded,
                    size: 6,
                    color: widget.inventarioGeneral.esNoche! ? Colors.blue.shade300 : Colors.amber,
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

class ContenidoResumenInventario extends StatelessWidget {

  final InventarioGeneral inventarioGeneral;
  
  const ContenidoResumenInventario({
    super.key,
    required this.inventarioGeneral
  });

  @override
  Widget build(BuildContext context) {

    Widget buildRow(List<String> listaCadenas, {bool esBold = false, bool esDeficiente = false, Color color = Colors.black}) {

      return Row(
        children: listaCadenas.asMap().entries.map((entry) {

          final cadena = entry.value;
          final indice = entry.key;

          return Expanded(
            child: Text(
              cadena,
              textAlign: indice < 1 ? TextAlign.start : TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: esBold || esDeficiente ? FontWeight.bold : FontWeight.normal,
                color: esDeficiente ? Colors.red : color
              )
            ),
          );
          
        }).toList(),
      );

    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: Colors.teal.shade50,
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
              buildRow(["Inventario General - ${inventarioGeneral.obtenerNombreCliente} ${inventarioGeneral.obtenerCE}"], esBold: true),
              Divider(color: Colors.teal.shade100),
              buildRow(["Local", inventarioGeneral.obtenerNombreLocal!], esBold: true, color: Colors.teal),
              buildRow(["Líder", inventarioGeneral.obtenerLider!], esBold: true),
              buildRow(["Horario Líder", inventarioGeneral.obtenerHorarioLider!]),
              buildRow(["Horario Equipo", inventarioGeneral.obtenerHorarioEquipo!]),
              buildRow(["Egreso", inventarioGeneral.obtenerHoraEgreso!]),
              Divider(color: Colors.teal.shade100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text.rich(
                      style: const TextStyle(
                        fontSize: 9,
                      ),
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "PTT: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )
                          ),
                          TextSpan(
                            text: inventarioGeneral.obtenerPTT,
                          )
                        ]
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text.rich(
                      style: const TextStyle(
                        fontSize: 9
                      ),
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "PDA: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            )
                          ),
                          TextSpan(
                            text: inventarioGeneral.obtenerPDA,
                          )
                        ]
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text.rich(
                      style: const TextStyle(
                        fontSize: 9
                      ),
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Conteo: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            )
                          ),
                          TextSpan(
                            text: inventarioGeneral.obtenerStockConteo,
                          )
                        ]
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text.rich(
                      style: const TextStyle(
                        fontSize: 9
                      ),
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Teórico: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            )
                          ),
                          TextSpan(
                            text: inventarioGeneral.obtenerStockTeorico,
                          )
                        ]
                      ),
                    ),
                  )
                ],
              ),
              Divider(color: Colors.teal.shade100),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    decoration: BoxDecoration(
                      color: inventarioGeneral.obtenerEstadoMensajeInventario["backgroundColor"],
                      borderRadius: BorderRadius.circular(3)
                    ),
                    child: Text(
                      inventarioGeneral.obtenerEstadoMensajeInventario["valor"],
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        inventarioGeneral.obtenerMensajeInventario!,
                        style: const TextStyle(
                          fontSize: 9
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );

  }

}

class ContenidoOperadores extends StatefulWidget {

  final InventarioGeneral inventarioGeneral;
  
  const ContenidoOperadores({
    super.key,
    required this.inventarioGeneral,
  });

  @override
  State<ContenidoOperadores> createState() => _ContenidoOperadoresState();

}

class _ContenidoOperadoresState extends State<ContenidoOperadores> {

  double tamanoLetra = 8;
  double valorSlider = 8;

  @override
  Widget build(BuildContext context) {

    Widget buildRow(List<String> listaCadenas, {bool esBold = false, color = Colors.white, esFilaDeTabla = false, esBaja = false, esIcono = false, estadoColor = Colors.white}) {

      return Padding(
        padding: esFilaDeTabla ? const EdgeInsets.all(1) : EdgeInsets.zero,
        child: Row(
          children: listaCadenas.asMap().entries.map((entry) {
        
            final cadena = entry.value;
            final indice = entry.key;
        
            return Expanded(
              flex: indice == 1 ? 5 : (indice == 0 ? 1 : 2),
              child: indice == listaCadenas.length - 1 && esIcono && !esBaja ? Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.circle,
                    size: 5,
                    color: estadoColor,
                  ),
                ),
              ) : (esBaja && indice == listaCadenas.length - 1 ? Container(
                margin: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  color: Colors.red.shade900,
                  borderRadius: BorderRadius.circular(2)
                ),
                child: Text(
                  "Baja",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: tamanoLetra,
                    color: color
                  )
                ),
              ) : Text(
                cadena,
                textAlign: indice < 3 ? TextAlign.start : TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: tamanoLetra,
                  fontWeight: esBold ? FontWeight.bold : FontWeight.normal,
                  color: esBaja && indice < 3 ? Colors.red : color
                )
              ))
            );
            
          }).toList(),
        ),
      );

    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: Colors.black,
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
              buildRow(["Operadores - ${widget.inventarioGeneral.obtenerNombreCliente} ${widget.inventarioGeneral.obtenerCE}"], esBold: true),
              const Divider(color: Colors.white),
              buildRow(["#", "Operador", "Comuna", "Exp", "Error", "U. Sug", "U. Real", "Estado"], esBold: true, esFilaDeTabla: true),
              for (var operador in widget.inventarioGeneral.obtenerTitulares.asMap().entries)
                buildRow([(operador.key + 1).toString(), operador.value["operador"].obtenerNombreCorto, operador.value["operador"].obtenerComuna, operador.value["operador"].obtenerExp, operador.value["operador"].obtenerError, operador.value["operador"].obtenerUnidadesSugeridas, operador.value["operador"].obtenerUnidadesReal, ""], esBaja: operador.value["baja"], esIcono: true, esFilaDeTabla: true, estadoColor: operador.value["colorEstadoOperador"]),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.format_size_rounded,
                      color: Colors.teal.shade300,
                      size: 10,
                    ),
                    Expanded(
                      child: Slider(
                        activeColor: Colors.teal.shade300,
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

class ContenidoUbicacion extends StatefulWidget {

  final InventarioGeneral inventarioGeneral;
  
  const ContenidoUbicacion({
    super.key,
    required this.inventarioGeneral,
  });

  @override
  State<ContenidoUbicacion> createState() => _ContenidoUbicacionState();

}

class _ContenidoUbicacionState extends State<ContenidoUbicacion> {

  double tamanoLetra = 8;
  double valorSlider = 8;

  @override
  Widget build(BuildContext context) {

    Widget buildRow(List<String> listaCadenas, {bool esBold = false, bool esDeficiente = false, Color color = Colors.black}) {

      return Row(
        children: listaCadenas.asMap().entries.map((entry) {

          final cadena = entry.value;
          final indice = entry.key;

          return Expanded(
            child: Text(
              cadena,
              textAlign: indice < 1 ? TextAlign.start : TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: esBold || esDeficiente ? FontWeight.bold : FontWeight.normal,
                color: esDeficiente ? Colors.red : color
              )
            ),
          );
          
        }).toList(),
      );

    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: Colors.black12,
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
                  Expanded(
                    child: Text(
                      "Ubicación - CE ${widget.inventarioGeneral.obtenerCE}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.inventarioGeneral.obtenerComuna!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ],
                    ),
                  )
                ]
              ),
              Divider(color: Tema.primaryLight),
              buildRow(["Local", widget.inventarioGeneral.obtenerNombreLocal!], esBold: true, color: Colors.teal),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Dirección",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.inventarioGeneral.obtenerDireccion!,
                          style: const TextStyle(
                            fontSize: 9
                          ),
                        ),
                      ),
                    )
                  ),
                ],
              ),
              Divider(color: Tema.primaryLight),
              if (widget.inventarioGeneral.obtenerLocalLatitud != null && widget.inventarioGeneral.obtenerLocalLongitud != null )
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: SizedBox(
                          height: 200,
                          child: FlutterMap(
                            options: MapOptions(
                              initialZoom: 17,
                              initialCenter: LatLng(widget.inventarioGeneral.obtenerLocalLatitud!, widget.inventarioGeneral.obtenerLocalLongitud!)
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: "https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=Yt61zaGS6opKxBDWQvi2",
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: LatLng(widget.inventarioGeneral.obtenerLocalLatitud!, widget.inventarioGeneral.obtenerLocalLongitud!),
                                    child: const Icon(
                                      Icons.location_on_rounded,
                                      color: Colors.teal,
                                      size: 30,
                                    ),
                                    rotate: true
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );

  }

}
