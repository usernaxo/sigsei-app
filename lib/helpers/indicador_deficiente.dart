class IndicadorDeficiente {

  static int limiteHorasIg = 09;
  static double limiteNotaPromedio = 6.0;
  static double limiteErrorSei = 0.6;
  static double limiteEstandarSei = 98;
  static double limiteVarianza = 0.2;

  static double limiteConteo = 5;
  static double limiteChecklist = 90;

  static double limiteErrorAbs = 3;

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

  static bool esConteoDeficiente(String conteo) {

    double? valorConteo = double.tryParse(conteo.replaceAll(",", ".").replaceAll("%", ""));

    return valorConteo != null ? ((valorConteo > limiteConteo) ? true : false) : false;

  }

  static bool esChecklistDeficiente(String checklist) {

    double? valorChecklist = double.tryParse(checklist.replaceAll(",", ".").replaceAll("%", ""));

    return valorChecklist != null ? ((valorChecklist < limiteChecklist) ? true : false) : false;

  }

  static bool esErrorAbsDeficiente(String errorAbs) {

    double? valorErrorAbs = double.tryParse(errorAbs.replaceAll(",", ".").replaceAll("%", ""));

    return valorErrorAbs != null ? ((valorErrorAbs >= limiteErrorAbs) ? true : false) : false;

  }

}
