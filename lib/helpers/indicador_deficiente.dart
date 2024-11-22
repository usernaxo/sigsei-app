class IndicadorDeficiente {

  static int limiteHorasIg = 09;
  static double limiteNotaPromedio = 6.0;
  static double limiteErrorSei = 0.6;
  static double limiteEstandarSei = 98;
  static double limiteVarianza = 0.2;

  static bool esHorasIgDeficiente(String horasIg) { 

    int? valorHorasIg = int.tryParse(horasIg.split(":")[0]);

    return valorHorasIg != null ? ((valorHorasIg >= limiteHorasIg) ? true : false) : false;

  }

  static bool esNotaPromedioDeficiente(String notaPromedio) {

    double? valorNotaPromedio = double.tryParse(notaPromedio.replaceAll(",", "."));

    return valorNotaPromedio != null ? ((valorNotaPromedio < limiteNotaPromedio) ? true : false) : false;

  }

  static bool esErrorSeiDeficiente(String errorSei) {

    double? valorErrorSei = double.tryParse(errorSei.replaceAll(",", ".").replaceAll("%", ""));

    return valorErrorSei != null ? ((valorErrorSei >= limiteErrorSei) ? true : false) : false;

  }

  static bool esEstandarSeiDeficiente(String estandarSei) {

    double? valorEstandarSei = double.tryParse(estandarSei.replaceAll(",", ".").replaceAll("%", ""));

    return valorEstandarSei != null ? ((valorEstandarSei < limiteEstandarSei) ? true : false) : false;

  }

  static bool esVarianzaDeficiente(String varianza) {

    double? valorVarianza = double.tryParse(varianza.replaceAll(",", ".").replaceAll("%", ""));

    return valorVarianza != null ? ((valorVarianza >= limiteVarianza) ? true : false) : false;

  }

}
