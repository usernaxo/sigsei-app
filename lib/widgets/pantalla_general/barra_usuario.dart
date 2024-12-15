import 'package:flutter/material.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/themes/tema.dart';

class BarraUsuario extends StatelessWidget {

  final Usuario usuario;
  final bool botonRetroceso;

  final GlobalKey<ScaffoldState> claveMenu;
  
  const BarraUsuario({
    super.key,
    required this.usuario,
    required this.botonRetroceso,
    required this.claveMenu
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Tema.primary,
          borderRadius: BorderRadius.circular(0)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (botonRetroceso)
                  Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        child: Icon(
                          Icons.arrow_back,
                          color: Tema.primary,
                        ),
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
                Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.person_rounded,
                        size: 17,
                      ),
                    ),
                    onTap: () => claveMenu.currentState?.openDrawer(),
                  ),
                ),
              ],
            )
          ]
        ),
      ),
    );

  }

}
