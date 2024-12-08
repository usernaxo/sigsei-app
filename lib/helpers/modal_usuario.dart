import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/helpers/modal_mensaje.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/providers/proveedor_estado.dart';
import 'package:sigsei/themes/tema.dart';

class ModalUsuario {

  final Usuario usuario;

  ModalUsuario({
    required this.usuario,
  });

  void show(BuildContext context) {

    showGeneralDialog(
      context: context,
      barrierLabel: "",
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {

        ProveedorEstado proveedorEstado = Provider.of<ProveedorEstado>(context);

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          title: Center(
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Tema.primary,
                shape: BoxShape.circle
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                foregroundColor: Tema.primary,
                child: const Icon(Icons.person_rounded),
              ),
            )
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${usuario.nombre1} ${usuario.apellidoPaterno}"
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    usuario.email,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.icon(
                    icon: proveedorEstado.estaCargando ? null : const Icon(
                      Icons.power_settings_new_rounded,
                      size: 15,
                    ),
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
                  )
                ],
              )
            ],
          )

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
