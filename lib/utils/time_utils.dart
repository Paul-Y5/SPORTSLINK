import 'package:flutter/material.dart';

Duration calcularTempoRestante(DateTime dataPartida, TimeOfDay horaPartida) {
  final now = DateTime.now();
  final partidaDateTime = DateTime(
    dataPartida.year,
    dataPartida.month,
    dataPartida.day,
    horaPartida.hour,
    horaPartida.minute,
  );
  return partidaDateTime.difference(now);
}