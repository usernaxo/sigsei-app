import 'package:flutter/material.dart';
import 'package:sigsei/helpers/modal_usuario.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/themes/tema.dart';

class BarraUsuario extends StatelessWidget {

  final Usuario usuario;
  final bool botonRetroceso;
  
  const BarraUsuario({
    super.key,
    required this.usuario,
    required this.botonRetroceso
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Tema.primary,
          borderRadius: BorderRadius.circular(7)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (botonRetroceso)
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Tema.primary,
                      ),
                    ),
                  ),
                Image.asset(
                  width: 80,
                  "assets/images/sei.png",
                  color: Colors.white,
                ),
                const Row(
                  children: [
                    Text(
                      "Consultores",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Text(
                  usuario.nombre1,
                  style: const TextStyle(
                    color: Colors.white
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    foregroundColor: Tema.primary,
                    maxRadius: 17,
                    child: const Icon(Icons.person_rounded),  
                  ),
                  onTap: () => ModalUsuario(usuario: usuario).show(context),
                ),
              ],
            )
          ]
        ),
      ),
    );

  }

}
