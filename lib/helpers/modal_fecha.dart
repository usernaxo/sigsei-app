import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ModalFecha {

  static const rango = DateRangePickerSelectionMode.range;
  static const simple = DateRangePickerSelectionMode.single;

  final BuildContext context;
  final DateRangePickerSelectionMode tipoModalFecha;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final Function(DateTime? fechaInicio, DateTime? fechaFin) fechaSeleccionada;

  ModalFecha({
    required this.context,
    required this.tipoModalFecha,
    required this.fechaSeleccionada,
    this.fechaInicio,
    this.fechaFin
  });

  Future<void> show() async {

    DateTime? fechaDesde;
    DateTime? fechaHasta;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.7,
              maxHeight: MediaQuery.sizeOf(context).height * 0.5,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7)
              ),
              padding: const EdgeInsets.all(20),
              child: SfDateRangePicker(
                showActionButtons: false,
                showNavigationArrow: true,
                backgroundColor: Colors.white,
                selectionMode: tipoModalFecha,
                minDate: DateTime(2000),
                maxDate: DateTime(2101),
                headerStyle: const DateRangePickerHeaderStyle(
                  backgroundColor: Colors.white,
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                monthViewSettings: const DateRangePickerMonthViewSettings(
                  enableSwipeSelection: false
                ),
                initialSelectedDate: tipoModalFecha == simple ? fechaInicio : null,
                initialSelectedRange: fechaInicio != null && fechaFin != null ? PickerDateRange(fechaInicio, fechaFin) : null,
                onSelectionChanged: (fecha) {
              
                  if (fecha.value != null) {
              
                    if (tipoModalFecha == DateRangePickerSelectionMode.single) {
              
                      fechaDesde = fecha.value;
              
                      if (fechaDesde != null) {
              
                        fechaSeleccionada(fechaDesde, fechaHasta);
              
                        Navigator.pop(context);
              
                      }
              
                    } else if (tipoModalFecha == DateRangePickerSelectionMode.range) {
              
                      fechaDesde = fecha.value.startDate;
                      fechaHasta = fecha.value.endDate;
                      
                      if (fechaDesde != null && fechaHasta != null) {
              
                        fechaSeleccionada(fechaDesde, fechaHasta);
              
                        Navigator.pop(context);
              
                      }
              
                    }
              
                  }
              
                },
              ),
            ),
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
