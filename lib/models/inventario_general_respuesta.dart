import 'package:sigsei/models/inventario_general.dart';

class InventarioGeneralRespuesta {

  List<InventarioGeneral>? listaInventarioGeneral;

  InventarioGeneralRespuesta({
    this.listaInventarioGeneral,
  });

  factory InventarioGeneralRespuesta.fromJson(List<dynamic> json) {

    return InventarioGeneralRespuesta(
      listaInventarioGeneral: json.map((inventarioGeneral) => InventarioGeneral.fromJson(inventarioGeneral)).toList(),
    );
    
  }

}
