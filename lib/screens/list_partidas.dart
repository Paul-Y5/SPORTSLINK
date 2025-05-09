import 'package:flutter/material.dart';
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/styles/carouselbg.dart';

import 'package:sports_link/widgets/partida_card.dart';

class ListPartidas extends StatefulWidget {
  const ListPartidas({super.key});

  @override
  State<ListPartidas> createState() => _ListPartidasState();
}

class _ListPartidasState extends State<ListPartidas> {
  final List<Partida> partidasPublicasDisponiveis =
      mockPartidas.where((partida) {
        return partida.tipo == TipoPartida.publica &&
            (partida.estado == EstadoPartida.aguardando ||
                partida.estado == EstadoPartida.emAndamento);
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Carousel no fundo
          const Carouselbg(),
          // Conteúdo principal
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Partidas Públicas Disponíveis'),
              backgroundColor: Colors.orange, // Transparência no AppBar
              elevation: 0,
            ),
            body: partidasPublicasDisponiveis.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma partida disponível no momento.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: partidasPublicasDisponiveis.length,
                    itemBuilder: (context, index) {
                      final partida = partidasPublicasDisponiveis[index];
                      return PartidaCard(partida: partida);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}