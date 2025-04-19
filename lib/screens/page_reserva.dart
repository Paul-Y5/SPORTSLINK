import 'package:flutter/material.dart';
import 'package:sports_link/models/campo.dart';

class PageReserva extends StatelessWidget {
  final Campo campo;

  const PageReserva({super.key, required this.campo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar Reserva - ${campo.nome}'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text(
          'Página para agendar reserva para o campo: ${campo.nome}',
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
