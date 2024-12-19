import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/helpers/modal_mensaje.dart';
import 'package:sigsei/models/modulo.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/providers/proveedor_estado.dart';
import 'package:sigsei/routes/rutas.dart';
import 'package:sigsei/themes/tema.dart';

class MenuUsuario extends StatelessWidget {

  final Usuario usuario;

  final modulo = Modulo(
    titulo: "Mi Agenda",
    ruta: "pantalla_agendas",
    icono: Icons.calendar_month_rounded
  );

  MenuUsuario({
    super.key, 
    required this.usuario
  });

  @override
  Widget build(BuildContext context) {

    ProveedorEstado proveedorEstado = Provider.of<ProveedorEstado>(context);

    var rutaActual = ModalRoute.of(context);

    Widget construirFila(List<String> listaCadenas) {

      return Row(
        children: listaCadenas.asMap().entries.map((entry) {

          final cadena = entry.value;
          final indice = entry.key;

          return indice == 0 ? Text(
            cadena,
            style: TextStyle(
              color: Tema.primary,
              fontWeight: FontWeight.bold,
              fontSize: 10
            ),
          ) : Expanded(
            child: Text(
              cadena,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10
              ),
            ),
          );
          
        }).toList(),
      );

    }

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Tema.primary,
            ),
            child: Column(
              children: [
                Expanded(
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    foregroundColor: Tema.primary,
                    child: const Icon(
                      Icons.person_rounded,
                      size: 25,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Text(
                          usuario.obtenerNombre!,
                          style: const TextStyle(
                            color: Colors.white,
                    
                            fontSize: 12
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          usuario.obtenerEmail!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ]
                    ),
                  )
                )
              ]
            )
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                if (rutaActual!.settings.name != "pantalla_usuario")
                  Card(
                    elevation: 0,
                    margin: const EdgeInsets.all(3),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: () {

                        final WidgetBuilder? builder = Rutas.rutas["pantalla_usuario"];

                        Navigator.of(context).push(
                          PageRouteBuilder(
                            settings: RouteSettings(name: "pantalla_usuario", arguments: {
                              "modulo" : modulo,
                              "usuario" : usuario
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
            
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.badge_outlined,
                              size: 15,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Mis datos",
                              style: TextStyle(
                                fontSize: 10
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (rutaActual.settings.name != "pantalla_agendas")
                  Card(
                    elevation: 0,
                    margin: const EdgeInsets.all(3),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: () {
                        
                        final WidgetBuilder? builder = Rutas.rutas["pantalla_agendas"];

                        Navigator.of(context).push(
                          PageRouteBuilder(
                            settings: RouteSettings(name: "pantalla_agendas", arguments: {
                              "modulo" : modulo,
                              "usuario" : usuario
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
            
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              size: 15,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Mi agenda",
                              style: TextStyle(
                                fontSize: 10
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: FilledButton.icon(
              label: proveedorEstado.estaCargando ? const Text("Cerrando...") : const Text("Cerrar Sesión"),
              onPressed: proveedorEstado.estaCargando ? null : () async {
                              
                ModalMensaje(titulo: "Cerrando Sesión", tipoMensaje: ModalMensaje.cargando).mostrar(context);
                              
                int respuestaCerrarSesion = await proveedorEstado.cerrarSesion();
                
                if (respuestaCerrarSesion == 200) {
                              
                  const almacenamiento = FlutterSecureStorage();
                              
                  await almacenamiento.deleteAll();
                              
                  Navigator.pushNamedAndRemoveUntil(context, "pantalla_acceso", (route) => false);
                              
                } else {
                              
                  ModalMensaje(titulo: "Error Cerrar Sesión", tipoMensaje: ModalMensaje.advertencia).mostrar(context);

                }

              },
            ),
          )
        ],
      ),
    );

  }

}
