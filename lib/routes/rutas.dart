import 'package:flutter/material.dart';
import 'package:sigsei/screens/pantalla_acceso.dart';
import 'package:sigsei/screens/pantalla_agendas.dart';
import 'package:sigsei/screens/pantalla_auditorias.dart';
import 'package:sigsei/screens/pantalla_avances.dart';
import 'package:sigsei/screens/pantalla_indicadores.dart';
import 'package:sigsei/screens/pantalla_inventario_general.dart';
import 'package:sigsei/screens/pantalla_modulos.dart';

class Rutas {

  static const pantallaAcceso = "pantalla_acceso";
  static const pantallaModulos = "pantalla_modulos";

  static Map<String, Widget Function(BuildContext context)> rutas = {

    "pantalla_acceso": (BuildContext context) => const PantallaAcceso(),
    "pantalla_modulos": (BuildContext context) => const PantallaModulos(),
    "pantalla_avances": (BuildContext context) => const PantallaAvances(),
    "pantalla_indicadores": (BuildContext context) => const PantallaIndicadores(),
    "pantalla_auditorias_smu": (BuildContext context) => const PantallaAuditorias(),
    "pantalla_inventario_general": (BuildContext context) => const PantallaInventarioGeneral(),
    "pantalla_agendas": (BuildContext context) => const PantallaAgendas(),

  };

}
