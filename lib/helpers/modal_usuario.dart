import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/helpers/modal_mensaje.dart';
import 'package:sigsei/models/modulo.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/providers/proveedor_estado.dart';
import 'package:sigsei/themes/tema.dart';

class ModalUsuario {

  final Usuario usuario;

  ModalUsuario({
    required this.usuario,
  });

  Widget construirFila(List<String> listaCadenas) {

    return Row(
      children: listaCadenas.asMap().entries.map((entry) {

        final cadena = entry.value;
        final indice = entry.key;

        return indice == 0 ? Text(
          cadena,
          style: TextStyle(
            color: Tema.primary,
            fontSize: 9,
            fontWeight: FontWeight.bold
          ),
        ) : Expanded(
          child: Text(
            cadena,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9
            ),
          ),
        );
        
      }).toList(),
    );

  }

  void show(BuildContext context) {

    var rutaActual = ModalRoute.of(context);

    showGeneralDialog(
      context: context,
      barrierLabel: "",
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {

        ProveedorEstado proveedorEstado = Provider.of<ProveedorEstado>(context);

        final modulo = Modulo(
          titulo: "Mi Agenda",
          ruta: "pantalla_agendas",
          icono: Icons.calendar_month_rounded
        );

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.8,
              maxHeight: MediaQuery.sizeOf(context).height * 0.6,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(7),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${usuario.nombre1} ${usuario.apellidoPaterno}",
                                  style: TextStyle(
                                    color: Tema.primary,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  usuario.email,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                              
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Tema.primary,
                              shape: BoxShape.circle
                            ),
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              foregroundColor: Tema.primary,
                              child: const Icon(
                                Icons.person_rounded,
                                size: 17,
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(color: Tema.primaryLight),
                      Column(
                        children: [
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                              side: BorderSide(
                                color: Tema.primaryLight
                              )
                            ),
                            margin: const EdgeInsets.all(3),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                              minTileHeight: 10,
                              childrenPadding: EdgeInsets.zero,
                              trailing: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Tema.primaryLight,
                                  width: 2
                                ),
                                borderRadius: BorderRadius.circular(7)
                              ),
                              title: const Row(
                                children: [
                                  Icon(
                                    Icons.badge_outlined,
                                    size: 15,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Mis datos de usuario",
                                    style: TextStyle(
                                      fontSize: 9
                                    ),
                                  )
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      Divider(color: Tema.primaryLight),
                                      construirFila(["Nombre: ", usuario.obtenerNombre!]),
                                      construirFila(["Fecha Nacimiento: ", usuario.obtenerFechaNacimiento!]),
                                      construirFila(["Email: ", usuario.obtenerEmail!]),
                                      construirFila(["Teléfono: ", usuario.obtenerTelefono!]),
                                      Divider(color: Tema.primaryLight)
                                    ],
                                  )
                                ),
                              ],
                            ),
                          ),
                          if (rutaActual!.settings.name != "pantalla_agendas")
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                                side: BorderSide(
                                  color: Tema.primaryLight,
                                ),
                              ),
                              margin: const EdgeInsets.all(3),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(7),
                                onTap: () {

                                  Navigator.pop(context);

                                  Navigator.pushNamed(context, "pantalla_agendas", arguments: {
                                    "modulo" : modulo,
                                    "usuario" : usuario
                                  });

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
                                        style: TextStyle(fontSize: 9),
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
                      Divider(color: Tema.primaryLight),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              label: proveedorEstado.estaCargando ? const Text("Cerrando...") : const Text("Cerrar Sesión"),
                              onPressed: proveedorEstado.estaCargando ? null : () async {
                                              
                                ModalMensaje(titulo: "Cerrando Sesión", tipoMensaje: ModalMensaje.cargando).mostrar(context);
                                              
                                int respuestaCerrarSesion = await proveedorEstado.cerrarSesion();
                                
                                if (respuestaCerrarSesion == 200) {
                                              
                                  const almacenamiento = FlutterSecureStorage();
                                              
                                  await almacenamiento.deleteAll();
                                              
                                  Navigator.pushReplacementNamed(context, "pantalla_acceso");
                                              
                                } else {
                                              
                                  ModalMensaje(titulo: "Error Cerrar Sesión", tipoMensaje: ModalMensaje.advertencia).mostrar(context);
                                              
                                }
                                              
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

      },
      transitionBuilder: (context, a1, a2, child) {

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1).animate(a1),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(a1),
            child: child,
          ),
        );

      },

    );

  }

}
