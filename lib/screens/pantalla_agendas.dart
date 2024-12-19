import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigsei/models/agenda.dart';
import 'package:sigsei/models/modulo.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/themes/tema.dart';
import 'package:sigsei/widgets/pantalla_general/barra_usuario.dart';
import 'package:sigsei/widgets/pantalla_general/menu_usuario.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PantallaAgendas extends StatefulWidget {

  const PantallaAgendas({super.key});

  @override
  PantallaAgendasState createState() => PantallaAgendasState();

}

class PantallaAgendasState extends State<PantallaAgendas> {

  final GlobalKey<ScaffoldState> clavePantallaAgendas = GlobalKey<ScaffoldState>();

  String fechaFormateada = "";
  DateTime fechaSeleccionada = DateTime.now();

  Color colorCompromiso = Colors.amber.shade50;

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

  late Future<List<Agenda>?> futureAgendas;
  List<Agenda> agendas = [];

  bool agendasCargadas = false;

  @override
  void initState() {

    super.initState();

    fechaFormateada = DateFormat('EEEE d \'de\' MMMM \'de\' yyyy', 'es_ES').format(fechaSeleccionada);

    controladorHora = FixedExtentScrollController(initialItem: horaSeleccionada);
    controladorMinuto = FixedExtentScrollController(initialItem: minutoSeleccionado);

    futureAgendas = obtenerAgendas();

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

  Future<List<Agenda>> obtenerAgendas() async {

    if (!agendasCargadas) {

      await Future.delayed(const Duration(seconds: 1));

    }

    final preferencias = await SharedPreferences.getInstance();

    final agendasJson = preferencias.getStringList("listaAgendas") ?? [];

    setState(() {

      agendas = agendasJson.map((agenda) => Agenda.fromJson(jsonDecode(agenda))).toList();

    });

    agendasCargadas = true;

    return agendas.where((a) => a.fecha == DateFormat("yyyy-MM-dd").format(fechaSeleccionada)).toList();

  }

  Future<void> guardarAgendas() async {

    final preferencias = await SharedPreferences.getInstance();

    final agendasJson = agendas.map((agenda) => jsonEncode(agenda.toJson())).toList();

    preferencias.setStringList("listaAgendas", agendasJson);

  }

  Future<void> agregarAgenda(Agenda agenda) async {

    agendas.add(agenda);

    await guardarAgendas();

    setState(() {

      futureAgendas = obtenerAgendas();

    });

  }

  Future<void> eliminarAgenda(Agenda agenda) async {

    agendas.remove(agenda);

    await guardarAgendas();

    setState(() {

      futureAgendas = obtenerAgendas();

    });

  }

  @override
  void dispose() {

    super.dispose();

    controladorHora.dispose();
    controladorMinuto.dispose();
    controladorDescripcion.dispose();
    
  }

  Widget agregarColor({required Color iconColor, required Color selectedColor, required bool isSelected, required VoidCallback onTap}) {

    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Tema.primary : Tema.primaryLight,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.circle,
          color: iconColor,
          size: 15,
        ),
      ),
    );

  }

  Widget crearHorarioAgenda(List<Agenda> agendas, String titulo, String rangoHorario, IconData icono, Color colorIcono) {

    int itemsCount = agendas.length < 4 ? 4 : agendas.length;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
      ),
      width: double.infinity,
      height: 170,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Icon(icono, color: colorIcono, size: 15),
                  const SizedBox(width: 5),
                  Text(titulo, style: TextStyle(color: Tema.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 5),
                  Text(rangoHorario, style: TextStyle(color: Tema.secondaryLight, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 5),
                  Expanded(child: Divider(color: Tema.primaryLight))
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: itemsCount,
                itemBuilder: (context, index) {

                  if (index < agendas.length) {

                    final agenda = agendas[index];

                    return Card(
                      elevation: 0,
                      color: agenda.color,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: SizedBox(
                          width: 120,
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
                                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
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
                                              eliminarAgenda(agenda);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(color: Color.alphaBlend(Colors.black.withOpacity(0.1), agenda.color)),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(agenda.descripcion, style: const TextStyle(fontSize: 10)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {

                    return Card(
                      elevation: 0,
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      child: DottedBorder(
                        color: Tema.secondaryLight,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(7),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: SizedBox(
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Compromiso", style: TextStyle(color: Tema.secondaryLight, fontSize: 10)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );

                  }

                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    final argumentos = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Modulo modulo = argumentos["modulo"];
    Usuario usuario = argumentos["usuario"];

    return Scaffold(
      key: clavePantallaAgendas,
      resizeToAvoidBottomInset: false,
      drawer: MenuUsuario(usuario: usuario),
      body: SafeArea(
        child: Column(
          children: [
            BarraUsuario(usuario: usuario, claveMenu: clavePantallaAgendas, botonRetroceso: true),
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
                color: Tema.secondaryLight
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
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: SfDateRangePicker(
                              showActionButtons: false,
                              showNavigationArrow: true,
                              backgroundColor: Tema.primaryLight,
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
                                specialDates: agendas.map((agenda) => DateTime.parse(agenda.fecha)).toList(),
                              ),
                              initialSelectedDate: DateTime.now(),
                              onSelectionChanged: (fecha) {
                                
                                setState(() {
                                
                                  fechaSeleccionada = fecha.value;
                                  fechaFormateada = DateFormat('EEEE d \'de\' MMMM \'de\' yyyy', 'es_ES').format(fechaSeleccionada);
                            
                                  futureAgendas = obtenerAgendas();
                                
                                });
                                
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3, right: 0, top: 5, bottom: 5),
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
                                          "Hora: ",
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
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Row(
                                        children: [
                                          Expanded(
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
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5),
                                            child: Text(
                                              ':',
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Stack(
                                  children: [
                                    TextFormField(
                                      controller: controladorDescripcion,
                                      textCapitalization: TextCapitalization.sentences,
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
                                            agregarColor(iconColor: Colors.green.shade100, selectedColor: Colors.green.shade50, isSelected: colorVerde,
                                              onTap: () {
                                                setState(() {
                                                  colorCompromiso = Colors.green.shade50;
                                                  colorDefecto = false;
                                                  colorVerde = true;
                                                  colorAzul = false;
                                                  colorNaranja = false;
                                                  colorAmarillo = false;
                                                });
                                              },
                                            ),
                                            agregarColor(iconColor: Colors.blue.shade100, selectedColor: Colors.blue.shade50, isSelected: colorAzul,
                                              onTap: () {
                                                setState(() {
                                                  colorCompromiso = Colors.blue.shade50;
                                                  colorDefecto = false;
                                                  colorVerde = false;
                                                  colorAzul = true;
                                                  colorNaranja = false;
                                                  colorAmarillo = false;
                                                });
                                              },
                                            ),
                                            agregarColor(iconColor: Colors.deepOrange.shade100, selectedColor: Colors.deepOrange.shade50, isSelected: colorNaranja,
                                              onTap: () {
                                                setState(() {
                                                  colorCompromiso = Colors.deepOrange.shade50;
                                                  colorDefecto = false;
                                                  colorVerde = false;
                                                  colorAzul = false;
                                                  colorNaranja = true;
                                                  colorAmarillo = false;
                                                });
                                              },
                                            ),
                                            agregarColor(iconColor: Colors.amber.shade100, selectedColor: Colors.amber.shade50, isSelected: colorAmarillo,
                                              onTap: () {
                                                setState(() {
                                                  colorCompromiso = Colors.amber.shade50;
                                                  colorDefecto = false;
                                                  colorVerde = false;
                                                  colorAzul = false;
                                                  colorNaranja = false;
                                                  colorAmarillo = true;
                                                });
                                              },
                                            ),
                                            agregarColor(iconColor: Colors.grey.shade300, selectedColor: Tema.primaryLight, isSelected: colorDefecto,
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
                                            ),
                                            const Spacer(),
                                            InkWell(
                                              borderRadius: BorderRadius.circular(100),
                                              onTap: () {
                                
                                                if (controladorDescripcion.value.text.toString().trim().isNotEmpty) {
                                
                                                  setState(() {
                                
                                                    final nuevaAgenda = Agenda(
                                                      id: DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                                                      fecha: DateFormat("yyyy-MM-dd").format(fechaSeleccionada),
                                                      hora: DateFormat("HH:mm").format(DateTime(fechaSeleccionada.year, fechaSeleccionada.month, fechaSeleccionada.day, horaSeleccionada, minutoSeleccionado)),
                                                      descripcion: controladorDescripcion.value.text.toString().trim(),
                                                      color: colorCompromiso,
                                                    );

                                                    agregarAgenda(nuevaAgenda);
                                
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
                  Expanded(
                    child: Text(
                      "Compromisos Programados",
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                color: Tema.secondaryLight
              )
            ),
            FutureBuilder(
              future: futureAgendas,
              builder: (context, snapshot) {
                
                if (snapshot.connectionState == ConnectionState.waiting) {

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
                        const Text("Obteniendo Compromisos")
                      ],
                    ),
                  );

                } else if (snapshot.hasError) {

                  return const Center(child: Text("Error"));

                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {

                  return Center(
                    child: Padding(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sentiment_dissatisfied_rounded,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "No hay compromisos programados para",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500
                              ),
                            ),
                            Text(
                              obtenerFechaFormateada(),
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
                    ),
                  );

                } else {

                  final agendas = snapshot.data!;

                  final agendasManana = agendas.where((agenda) {
                    DateTime hora = DateFormat("HH:mm").parse(agenda.hora);
                    return hora.isAfter(DateFormat("HH:mm").parse("00:00").subtract(const Duration(seconds: 1))) && hora.isBefore(DateFormat("HH:mm").parse("12:00"));
                  }).toList();

                  final agendasTarde = agendas.where((agenda) {
                    DateTime hora = DateFormat("HH:mm").parse(agenda.hora);
                    return hora.isAfter(DateFormat("HH:mm").parse("11:59")) && hora.isBefore(DateFormat("HH:mm").parse("20:00"));
                  }).toList();

                  final agendasNoche = agendas.where((agenda) {
                    DateTime hora = DateFormat("HH:mm").parse(agenda.hora);
                    return hora.isAfter(DateFormat("HH:mm").parse("19:59")) && hora.isBefore(DateFormat("HH:mm").parse("23:59"));
                  }).toList();

                  return Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            crearHorarioAgenda(agendasManana, "Mañana", "00:00 - 11:59", Icons.cloud_rounded, Tema.secondaryLight),
                            crearHorarioAgenda(agendasTarde, "Tarde", "12:00 - 19:59", Icons.wb_sunny_rounded, Colors.amber.shade300),
                            crearHorarioAgenda(agendasNoche, "Noche", "20:00 - 23:59", Icons.nightlight_round_rounded, Colors.blue.shade300),
                          ],
                        ),
                      ),
                    ),
                  );

                }

              },
            ),
          ]
        ),
      )
    );

  }

}
