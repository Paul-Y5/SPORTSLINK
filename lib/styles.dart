// lib/styles.dart
import 'package:flutter/material.dart';

ButtonStyle customButtonStyle() {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.pressed)) {
        return Colors.orange;
      }
      return const Color.fromARGB(159, 0, 0, 0); // preto desaturado
    }),
    foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.pressed)) {
        return Colors.black;
      }
      return Colors.orange;
    }),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 50, vertical: 25), // Ajuste do padding
    ),
    textStyle: WidgetStateProperty.all(
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Ajuste do texto
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Ajuste das bordas
      ),
    ),
    minimumSize: WidgetStateProperty.all(
      const Size(200, 50), // Define um tamanho mínimo para os botões
    ),
  );
}