import 'package:sigsei/models/avance.dart';

class AvancesRespuesta {

  List<Avance>? listaAvances;

  AvancesRespuesta({
    this.listaAvances,
  });

  factory AvancesRespuesta.fromJson(List<dynamic> json) {

    return AvancesRespuesta(
      listaAvances: json.map((avance) => Avance.fromJson(avance)).toList(),
    );
    
  }

}
