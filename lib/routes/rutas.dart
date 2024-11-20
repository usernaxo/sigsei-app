import 'package:flutter/material.dart';
import 'package:sigsei/screens/pantalla_acceso.dart';
import 'package:sigsei/screens/pantalla_indicadores.dart';
import 'package:sigsei/screens/pantalla_modulos.dart';

class Rutas {

  static const pantallaAcceso = "pantalla_acceso";
  static const pantallaModulos = "pantalla_modulos";

  static Map<String, Widget Function(BuildContext context)> rutas = {

    "pantalla_acceso": (BuildContext context) => const PantallaAcceso(),
    "pantalla_modulos": (BuildContext context) => const PantallaModulos(),
    "pantalla_indicadores": (BuildContext context) => const PantallaIndicadores()

  };

}
