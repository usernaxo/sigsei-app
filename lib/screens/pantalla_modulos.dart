import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/helpers/indicador_deficiente.dart';
import 'package:sigsei/models/avance.dart';
import 'package:sigsei/models/modulo.dart';
import 'package:sigsei/models/indicador.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/providers/proveedor_estado.dart';
import 'package:sigsei/routes/rutas.dart';
import 'package:sigsei/themes/tema.dart';
import 'package:sigsei/widgets/pantalla_general/barra_usuario.dart';
import 'package:sigsei/widgets/pantalla_general/menu_usuario.dart';

class PantallaModulos extends StatefulWidget {
  
  const PantallaModulos({super.key});

  @override
  State<PantallaModulos> createState() => _PantallaModulosState();

}

class _PantallaModulosState extends State<PantallaModulos> {

  final GlobalKey<ScaffoldState> clavePantallaModulos = GlobalKey<ScaffoldState>();

  late Future<List<Indicador>?> listaIndicadores;
  late Future<List<Avance>?> listaAvances;
  late Future<Usuario?> usuario;

  @override
  void initState() {

    super.initState();

    listaIndicadores = obtenerIndicadores();
    listaAvances = obtenerAvances();
    usuario = obtenerDatos();

  }

  Future<Usuario?> obtenerDatos() async {

    const almacenamiento = FlutterSecureStorage();

    String? usuario = await almacenamiento.read(key: "usuario");

    if (usuario != null) {

      return Usuario.fromJson(usuario);

    }

    return null;

  }

  Future<List<Indicador>?> obtenerIndicadores() async {

    final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

    DateTime fechaActual = DateTime.now();
    
    String fechaFormateada;

    if (fechaActual.weekday == DateTime.monday && fechaActual.hour < 16) {

      fechaFormateada = DateFormat("yyyy-MM-dd").format(fechaActual.subtract(const Duration(days: 3)));

    } else if (fechaActual.weekday == DateTime.saturday) {

      fechaFormateada = DateFormat("yyyy-MM-dd").format(fechaActual.subtract(const Duration(days: 1)));

    } else if (fechaActual.weekday == DateTime.sunday) {

      fechaFormateada = DateFormat("yyyy-MM-dd").format(fechaActual.subtract(const Duration(days: 2)));

    } else {

      if (fechaActual.hour >= 16) {

        fechaFormateada = DateFormat("yyyy-MM-dd").format(fechaActual);

      } else {

        fechaFormateada = DateFormat("yyyy-MM-dd").format(fechaActual.subtract(const Duration(days: 1)));

      }

    }

    return await proveedorEstado.obtenerIndicadores(fechaFormateada, fechaFormateada);

  }

  Future<List<Avance>?> obtenerAvances() async {

    final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

    DateTime fechaActual = DateTime.now();
    
    String fechaFormateada;

    if (fechaActual.weekday == DateTime.saturday) {

      fechaFormateada = DateFormat("yyyy-MM-dd").format(fechaActual.subtract(const Duration(days: 1)));

    } else if (fechaActual.weekday == DateTime.sunday) {

      fechaFormateada = DateFormat("yyyy-MM-dd").format(fechaActual.subtract(const Duration(days: 2)));

    } else {

      fechaFormateada = DateFormat("yyyy-MM-dd").format(fechaActual);

    }

    return await proveedorEstado.obtenerAvances(fechaFormateada, fechaFormateada);

  }

  @override
  Widget build(BuildContext context) {
    
    List<Modulo> modulos = [
      Modulo(
        titulo: "Avance de Inventarios",
        ruta: "pantalla_avances",
        icono: Icons.timeline_rounded
      ),
      Modulo(
        titulo: "Indicadores de Inventarios",
        ruta: "pantalla_indicadores",
        icono: Icons.inventory_rounded
      ),
      Modulo(
        titulo: "Programación Auditorias SMU",
        ruta: "pantalla_auditorias_smu",
        icono: Icons.content_paste_search_rounded
      ),
      Modulo(
        titulo: "Programación Semanal IG",
        ruta: "pantalla_inventario_general",
        icono: Icons.fact_check_outlined
      ),
    ];

    bool indicadorRojo(Indicador indicador) {

      String horasIg = indicador.obtenerIgHours!;
      String notaPromedio = indicador.obtenerAvgScores!;
      String errorSei = indicador.obtenerSeiError!;
      String estandarSei = indicador.obtenerSeiStandard!;
      String varianza = indicador.obtenerVarianza!;

      if (IndicadorDeficiente.esHorasIgDeficiente(horasIg) || IndicadorDeficiente.esNotaPromedioDeficiente(notaPromedio) || IndicadorDeficiente.esErrorSeiDeficiente(errorSei) || IndicadorDeficiente.esEstandarSeiDeficiente(estandarSei) || IndicadorDeficiente.esVarianzaDeficiente(varianza) || indicador.indicator == null) {

        return true;

      }

      return false;

    }

    Widget estadoIndicador(List<Indicador> indicadores) {

      bool indicadoresVacios = indicadores.every((indicador) => indicador.indicator == null);

      if (indicadoresVacios) {

        return const Icon(
          Icons.circle,
          size: 10,
          color: Colors.yellow,
        );

      } else {

        bool existenIndicadoresDeficientes = false;

        for (Indicador indicador in indicadores) {

          if (indicadorRojo(indicador)) {

            existenIndicadoresDeficientes = true;

            break;

          }

        }

        return Icon(

          Icons.circle,
          size: 10,
          color: existenIndicadoresDeficientes ? Colors.red : Colors.green,

        );

      }
      
    }

    Widget estadoAvance(List<Avance> avances) {

      bool avancesOkay = avances.every((avance) => avance.obtenerHoraEstimadaCierre!.isNotEmpty);

      if (avancesOkay) {

        return const Icon(
          Icons.circle,
          size: 10,
          color: Colors.green,
        );

      } else {

        return const Icon(
          Icons.circle,
          size: 10,
          color: Colors.red,
        );

      }
      
    }

    return Scaffold(
      key: clavePantallaModulos,
      drawer: FutureBuilder(
        future: usuario,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5
                ),
              )
            );

          } else if (snapshot.hasError) {

            return const Center(child: Text("Error"));

          } else if (snapshot.hasData) {

            final usuarioData = snapshot.data;

            return MenuUsuario(usuario: usuarioData!);

          }

          return Container();

        }
      ),
      body: FutureBuilder(
        future: Future.wait([usuario, listaIndicadores, listaAvances]),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5
                ),
              )
            );

          } else if (snapshot.hasError) {

            return const Center(child: Text("Error"));

          } else if (snapshot.hasData) {

            final usuarioData = snapshot.data?[0] as Usuario;
            final indicadoresData = snapshot.data?[1] as List<Indicador>;
            final avancesData = snapshot.data?[2] as List<Avance>;

            return Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipPath(
                    clipper: CurvaFondoInferior(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      color: Tema.primary,
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      BarraUsuario(usuario: usuarioData, claveMenu: clavePantallaModulos, botonRetroceso: false),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.arrow_drop_down_rounded),
                                const Text.rich(
                                  TextSpan(
                                    text: "Gestión Operacional ",
                                    children: [
                                      TextSpan(
                                        text: "SIG",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold
                                        )
                                      )
                                    ]
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                    child: Divider(color: Tema.secondaryLight)
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: modulos.length,
                            itemBuilder: (context, index) {

                              return Card(
                                elevation: 0,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                  trailing: index == 0 ? estadoAvance(avancesData) : (index == 1 ? estadoIndicador(indicadoresData) : null),
                                  title: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        child: Icon(
                                          modulos[index].icono,
                                          size: 15,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          modulos[index].titulo,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {

                                    final WidgetBuilder? builder = Rutas.rutas[modulos[index].ruta];

                                    Navigator.of(context).push(
                                      
                                      PageRouteBuilder(
                                        settings: RouteSettings(name: modulos[index].ruta, arguments: {
                                          "modulo" : modulos[index],
                                          "usuario" : usuarioData
                                        }),
                                        pageBuilder: (context, animation, secondaryAnimation) {

                                          return builder!(context);

                                        },
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {

                                          const begin = Offset(1, 0);
                                          const end = Offset.zero;
                                          const curve = Curves.decelerate;

                                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                          var offsetAnimation = animation.drive(tween);

                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );

                                        },
                                      )
                                    );
                              
                                  }

                                ),
                              );
                
                            },
                          ),
                        ),
                      )
                    ]
                  ),
                ),
              ]
            );

          }

          return Container();

        },
      )
    );

  }

}

class CurvaFondoInferior extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {

    Path path = Path();

    path.moveTo(size.width, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.9,
      0,
      size.height * 0.7,
    );
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    return path;

  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

}
