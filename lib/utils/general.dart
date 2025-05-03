import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}

String getDiaSemanaPt(DateTime date) {
  String dia = DateFormat('EEEE', 'pt_PT').format(date);

  return capitalize(dia);
}


List<TimeOfDay> gerarHorariosFuncionamento(List<TimeOfDay> timeRange) {
  List<TimeOfDay> horarios = [];

  final horaInicio = timeRange[0];
  final horaFim = timeRange[1];

  int startHour = horaInicio.hour;
  int endHour = horaFim.hour;

  if (horaFim.minute > 0) {
    endHour += 1;
  }

  for (int hour = startHour; hour < endHour; hour++) {
    horarios.add(TimeOfDay(hour: hour, minute: 0));
  }

  return horarios;
}
