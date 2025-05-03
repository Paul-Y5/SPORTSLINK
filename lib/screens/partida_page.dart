import 'package:flutter/material.dart';
import 'package:sports_link/models/campo_pub.dart';

class PartidaPage extends StatelessWidget {
  final CampoPub campo;
  final int tempoEspera;
  final int minJogadores;

  const PartidaPage({
    super.key,
    required this.campo,
    required this.tempoEspera,
    required this.minJogadores,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Partida'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Campo: ${campo.nome}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Tempo de Espera: $tempoEspera minutos'),
            Text('Número Mínimo de Jogadores: $minJogadores'),
            const SizedBox(height: 16),
            Text(
              'Estado: ${campo.ocupado ? "Ocupado" : "Disponível"}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}