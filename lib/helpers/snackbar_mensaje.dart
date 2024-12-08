import 'package:flutter/material.dart';
import 'package:sigsei/themes/tema.dart';

class SnackbarMensaje {

  static void mostrarMensaje(BuildContext context, String mensaje) {

    if (context.mounted) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Tema.primary,
          content: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
                size: 10,
              ),
              const SizedBox(width: 5),
              Text(
                mensaje,
                style: const TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
      );

    }

  }

}
