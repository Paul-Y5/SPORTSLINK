import 'package:flutter/material.dart';

ButtonStyle customButtonStyle(BuildContext context) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.pressed)) {
        return const Color.fromARGB(200, 255, 153, 0);
      }
      return const Color.fromARGB(120, 0, 0, 0); // Preto desaturado
    }),
    foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.pressed)) {
        return const Color.fromARGB(255, 0, 0, 0);
      }
      return Colors.orange;
    }),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ), // Ajuste do padding
    ),
    textStyle: WidgetStateProperty.all(
      const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ), // Ajuste do texto
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Ajuste das bordas
        side: const BorderSide(
          color: Color.fromARGB(255, 255, 255, 255), // Cor da borda
          width: 1, // Largura da borda
        ),
      ),
    ),
    minimumSize: WidgetStateProperty.all(
      Size(
        MediaQuery.of(context).size.width * 0.8, 50), // Largura como 80% da largura da tela, altura fixa
    ),
  );
}


ButtonStyle customButtonStyleForms(BuildContext context) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.pressed)) {
        // Tom mais escuro de laranja quando pressionado
        return Colors.orange.shade700;
      }
      return Colors.orange; // Laranja normal
    }),
    foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.pressed)) {
        // Cor do texto em preto quando pressionado
        return Colors.black;
      }
      return Colors.black; // Cor do texto preta
    }),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(
        horizontal:
            30, // Diminuímos o padding horizontal para deixar o botão mais estreito
        vertical:
            15, // Diminuímos o padding vertical para deixar o botão mais baixo
      ),
    ),
    textStyle: WidgetStateProperty.all(
      const TextStyle(
        fontSize: 18, // Tamanho do texto um pouco menor
        fontWeight: FontWeight.bold,
      ),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Borda arredondada
      ),
    ),
    minimumSize: WidgetStateProperty.all(
      Size(
        MediaQuery.of(context).size.width * 0.3, // Largura menor, 70% da tela
        20, // Altura mais compacta
      ),
    ),
  );
}


InputDecoration inputDecoration({String labelText = ''}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(color: Color.fromARGB(255, 242, 240, 240)), // Cor da label
    border: const OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color.fromARGB(255, 252, 250, 250)), // Borda padrão preta
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.orange, width: 2), // Borda laranja no foco
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.orange, width: 2), // Borda laranja no erro
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 237, 30, 15), width: 2), // Borda vermelha em erro
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ), // Ajuste do padding interno
    filled: true,
    fillColor: const Color.fromARGB(0, 255, 255, 255), // Cor de fundo branca
  );
  
}
