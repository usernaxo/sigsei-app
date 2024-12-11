import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigsei/models/agenda.dart';
import 'package:sigsei/models/modulo.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/themes/tema.dart';
import 'package:sigsei/widgets/pantalla_general/barra_usuario.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PantallaAgendas extends StatefulWidget {

  const PantallaAgendas({super.key});

  @override
  PantallaAgendasState createState() => PantallaAgendasState();

}

class PantallaAgendasState extends State<PantallaAgendas> {

  String fechaFormateada = "";
  DateTime fechaSeleccionada = DateTime.now();

  Color colorCompromiso = Colors.amber.shade100;

  bool colorDefecto = false;
  bool colorVerde = false;
  bool colorAzul = false;
  bool colorNaranja = false;
  bool colorAmarillo = true;

  late int horaSeleccionada = DateTime.now().hour;
  late int minutoSeleccionado = DateTime.now().minute;

  late FixedExtentScrollController controladorHora = FixedExtentScrollController();
  late FixedExtentScrollController controladorMinuto = FixedExtentScrollController();

  TextEditingController controladorDescripcion = TextEditingController();
  FocusNode focoCompromiso = FocusNode();

  List<Agenda> listaCompletaAgendas = [];
  List<Agenda> listaAgendas = [];

  @override
  void initState() {

    super.initState();

    fechaFormateada = DateFormat('EEEE d \'de\' MMMM \'de\' yyyy', 'es_ES').format(fechaSeleccionada);

    controladorHora = FixedExtentScrollController(initialItem: horaSeleccionada);
    controladorMinuto = FixedExtentScrollController(initialItem: minutoSeleccionado);

    obtenerListaAgendas();

  }

  String obtenerFechaFormateada() {

    String fechaConMayusculas = fechaFormateada.split(' ').map((palabra) {

      if (palabra.toLowerCase() == 'de') {

        return palabra;

      } else {

        return palabra.substring(0, 1).toUpperCase() + palabra.substring(1);

      }

    }).join(' ');

    return fechaConMayusculas;

  }

  Future<List<Agenda>> obtenerListaAgendas() async {

    final preferencias = await SharedPreferences.getInstance();
    
    List<String>? listaAgendasJson = preferencias.getStringList("listaAgendas");

    if (listaAgendasJson != null) {

      setState(() {

        listaCompletaAgendas = listaAgendasJson.map((agenda) => Agenda.fromJson(jsonDecode(agenda))).toList();

        listaAgendas = listaCompletaAgendas.where((agenda) {

          String fechaAgenda = agenda.fecha;
          String fechaFiltro = DateFormat("yyyy-MM-dd").format(fechaSeleccionada);

          return fechaAgenda == fechaFiltro;

        }).toList();

      });

    }

    return [];

  }

  Future<void> guardarListaAgenda() async {

    final preferencias = await SharedPreferences.getInstance();

    await preferencias.setStringList("listaAgendas", listaCompletaAgendas.map((agenda) => jsonEncode(agenda.toJson())).toList());

  }

  @override
  void dispose() {

    super.dispose();

    controladorHora.dispose();
    controladorMinuto.dispose();
    controladorDescripcion.dispose();
    
  }

  @override
  Widget build(BuildContext context) {

    final argumentos = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Modulo modulo = argumentos["modulo"];
    Usuario usuario = argumentos["usuario"];

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  Text(
                    "${modulo.titulo} - ",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Expanded(
                    child: Text(
                      obtenerFechaFormateada(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    )
                  )

                ]
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
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 200
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                          side: BorderSide(
                            color: Tema.primaryLight,
                            width: 1.5
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SfDateRangePicker(
                            showActionButtons: false,
                            showNavigationArrow: true,
                            backgroundColor: Colors.white,
                            selectionMode: DateRangePickerSelectionMode.single,
                            minDate: DateTime(2000),
                            maxDate: DateTime(2101),
                            headerStyle: const DateRangePickerHeaderStyle(
                              backgroundColor: Colors.white,
                              textAlign: TextAlign.center,
                              textStyle: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            monthCellStyle: DateRangePickerMonthCellStyle(
                              textStyle: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                              specialDatesDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber.shade100
                              ),
                              todayTextStyle: const TextStyle(
                                fontSize: 10
                              )
                            ),
                            selectionTextStyle: const TextStyle(
                              fontSize: 10
                            ),
                            rangeTextStyle: const TextStyle(
                              fontSize: 10
                            ),
                            monthViewSettings: DateRangePickerMonthViewSettings(
                              enableSwipeSelection: false,
                              specialDates: listaCompletaAgendas.map((agenda) => DateTime.parse(agenda.fecha)).toList(),
                            ),
                            initialSelectedDate: DateTime.now(),
                            onSelectionChanged: (fecha) {
                              
                              setState(() {
                              
                                fechaSeleccionada = fecha.value;
                                fechaFormateada = DateFormat('EEEE d \'de\' MMMM \'de\' yyyy', 'es_ES').format(fechaSeleccionada);

                                obtenerListaAgendas();
                              
                              });
                              
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                              child: Row(
                                children: [
                                  Container(
                                    height: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Tema.primaryLight,
                                      borderRadius: BorderRadius.circular(7)
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time_rounded,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Asignar Hora: ",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Tema.primary,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          border: Border.all(
                                            color: Tema.primaryLight,
                                            width: 1.5
                                          )
                                        ),
                                        height: double.infinity,
                                        child: ListWheelScrollView.useDelegate(
                                          controller: controladorHora,
                                          itemExtent: 12,
                                          physics: const FixedExtentScrollPhysics(),
                                          onSelectedItemChanged: (value) {
                                            setState(() {
                                              horaSeleccionada = value;
                                            });
                                          },
                                          childDelegate: ListWheelChildBuilderDelegate(
                                            builder: (context, index) {
                                              return Center(
                                                child: Text(
                                                  index.toString().padLeft(2, '0'),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: horaSeleccionada == index ? FontWeight.bold : FontWeight.normal,
                                                    color: horaSeleccionada == index ? Colors.black : Colors.grey,
                                                  ),
                                                ),
                                              );
                                            },
                                            childCount: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    ':',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          border: Border.all(
                                            color: Tema.primaryLight,
                                            width: 1.5
                                          )
                                        ),
                                        height: double.infinity,
                                        child: ListWheelScrollView.useDelegate(
                                          controller: controladorMinuto,
                                          itemExtent: 12,
                                          physics: const FixedExtentScrollPhysics(),
                                          onSelectedItemChanged: (value) {
                                            setState(() {
                                              minutoSeleccionado = value;
                                            });
                                          },
                                          childDelegate: ListWheelChildBuilderDelegate(
                                            builder: (context, index) {
                                              return Center(
                                                child: Text(
                                                  index.toString().padLeft(2, '0'),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: minutoSeleccionado == index ? FontWeight.bold : FontWeight.normal,
                                                    color: minutoSeleccionado == index ? Colors.black : Colors.grey,
                                                  ),
                                                ),
                                              );
                                            },
                                            childCount: 60,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Expanded(
                              child: Stack(
                                children: [
                                  TextFormField(
                                    controller: controladorDescripcion,
                                    focusNode: focoCompromiso,
                                    maxLines: 50,
                                    style: const TextStyle(
                                      fontSize: 10
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Agregar compromiso",
                                      hoverColor: Colors.black,
                                      fillColor: colorCompromiso,
                                      hintStyle: const TextStyle(
                                        fontSize: 10
                                      )
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            borderRadius: BorderRadius.circular(100),
                                            onTap: () {
                                              setState(() {
                                                colorCompromiso = Colors.green.shade100;
                                                colorDefecto = false;
                                                colorVerde = true;
                                                colorAzul = false;
                                                colorNaranja = false;
                                                colorAmarillo = false;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: colorVerde ? Tema.primary : Tema.primaryLight,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.circle,
                                                color: Colors.green.shade100,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            borderRadius: BorderRadius.circular(100),
                                            onTap: () {
                                              setState(() {
                                                colorCompromiso = Colors.blue.shade100;
                                                colorDefecto = false;
                                                colorVerde = false;
                                                colorAzul = true;
                                                colorNaranja = false;
                                                colorAmarillo = false;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: colorAzul ? Tema.primary : Tema.primaryLight,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.circle,
                                                color: Colors.blue.shade100,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            borderRadius: BorderRadius.circular(100),
                                            onTap: () {
                                              setState(() {
                                                colorCompromiso = Colors.deepOrange.shade100;
                                                colorDefecto = false;
                                                colorVerde = false;
                                                colorAzul = false;
                                                colorNaranja = true;
                                                colorAmarillo = false;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: colorNaranja ? Tema.primary : Tema.primaryLight,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.circle,
                                                color: Colors.deepOrange.shade100,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            borderRadius: BorderRadius.circular(100),
                                            onTap: () {
                                              setState(() {
                                                colorCompromiso = Colors.amber.shade100;
                                                colorDefecto = false;
                                                colorVerde = false;
                                                colorAzul = false;
                                                colorNaranja = false;
                                                colorAmarillo = true;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: colorAmarillo ? Tema.primary : Tema.primaryLight,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.circle,
                                                color: Colors.amber.shade100,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            borderRadius: BorderRadius.circular(100),
                                            onTap: () {
                                              setState(() {
                                                colorCompromiso = Tema.primaryLight;
                                                colorDefecto = true;
                                                colorVerde = false;
                                                colorAzul = false;
                                                colorNaranja = false;
                                                colorAmarillo = false;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: colorDefecto ? Tema.primary : Tema.primaryLight,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.circle,
                                                color: Colors.grey.shade300,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            borderRadius: BorderRadius.circular(100),
                                            onTap: () {
                              
                                              if (controladorDescripcion.value.text.toString().trim().isNotEmpty) {
                              
                                                setState(() {
                              
                                                  final nuevaAgenda = Agenda(
                                                    fecha: DateFormat("yyyy-MM-dd").format(fechaSeleccionada),
                                                    hora: "$horaSeleccionada:$minutoSeleccionado",
                                                    descripcion: controladorDescripcion.value.text.toString().trim(),
                                                    color: colorCompromiso,
                                                  );
                              
                                                  listaCompletaAgendas.add(nuevaAgenda);

                                                  guardarListaAgenda();
                              
                                                  controladorDescripcion.clear();
                                                  focoCompromiso.unfocus();
                              
                                                });
                              
                                              } else {
                              
                                                return;
                              
                                              }
                              
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Tema.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.add_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Row(
                children: [
                  Icon(
                    Icons.sentiment_satisfied_alt_rounded,
                    size: 15,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Compromisos Programados"
                  )
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                color: Tema.primaryLight
              )
            ),
            if (listaCompletaAgendas.where((agenda) => DateFormat("yyyy-MM-dd").format(DateTime.parse(agenda.fecha)) == DateFormat("yyyy-MM-dd").format(fechaSeleccionada)).toList().isEmpty)
              Center(
                child: Padding(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sentiment_dissatisfied_rounded,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "No hay compromisos programados para",
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
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: GridView.builder(
                  itemCount: listaCompletaAgendas.where((agenda) => DateFormat("yyyy-MM-dd").format(DateTime.parse(agenda.fecha)) == DateFormat("yyyy-MM-dd").format(fechaSeleccionada)).toList().length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (context, index) {

                    final agenda = listaCompletaAgendas.where((agenda) => DateFormat("yyyy-MM-dd").format(DateTime.parse(agenda.fecha)) == DateFormat("yyyy-MM-dd").format(fechaSeleccionada)).toList()[index];

                    return Card(
                      elevation: 0,
                      color: agenda.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "A las ${agenda.hora}",
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold
                                          ),
                                        )
                                      ),
                                      InkWell(
                                        borderRadius: BorderRadius.circular(100),
                                        child: const Icon(
                                          Icons.remove_circle_outline_rounded,
                                          size: 12,
                                          color: Colors.red,
                                        ),
                                        onTap: () {

                                          setState(() {

                                            listaCompletaAgendas.remove(agenda);

                                            guardarListaAgenda();

                                          });
                                          
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Divider(color: Color.alphaBlend(Colors.black.withOpacity(0.1), agenda.color)),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    agenda.descripcion,
                                    style: const TextStyle(
                                      fontSize: 10
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ),
                    );
                  },
                ),
              ),
            )
          ]
        ),
      )
    );

  }

}
