import 'package:flutter/material.dart';
import 'package:sigsei/themes/tema.dart';

class ModalMensaje {

  final String titulo;
  final int tipoMensaje;

  static const int exito = 0;
  static const int advertencia = 1;
  static const int error = 2;
  static const int cargando = 3;

  ModalMensaje({
    required this.titulo,
    required this.tipoMensaje
  });

  void mostrar(BuildContext context) {

    Widget? widget;
    bool cancelable = true;

    switch (tipoMensaje) {

      case exito:

        widget = const Icon(Icons.check_circle_rounded, color: Colors.green);

        break;
      
      case advertencia:

        widget = const Icon(Icons.warning_rounded, color: Colors.amber);

        break;
      
      case error:

        widget = const Icon(Icons.error_rounded, color: Colors.red);

        break;
      
      case cargando:

        widget = CircularProgressIndicator(color: Tema.primary, strokeWidth: 1.5);

        cancelable = false;
        
        break;
      
      default:

    }

    showGeneralDialog(
      context: context,
      barrierDismissible: cancelable,
      barrierLabel: "",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {

        return PopScope(
          canPop: cancelable,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            title: Center(
              child: SizedBox(
                height: 25,
                width: 25,
                child: widget
              )
            ),
            content: Text(titulo, textAlign: TextAlign.center)
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
