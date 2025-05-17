import 'package:flutter/material.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/models/utilizador.dart';
import 'package:sports_link/screens/partida_page.dart';

class MovableFab extends StatefulWidget {
  final Utilizador currentUser;
  const MovableFab({super.key, required this.currentUser});

  @override
  State<MovableFab> createState() => _MovableFabState();
}

class _MovableFabState extends State<MovableFab> {
  double? posX;
  double? posY;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Inicialização da posição no primeiro build
    posX ??= size.width - size.width; // Esquerda (0)
    posY ??= size.height / 2 - 28; // Centro vertical, 28 é metade da altura típica do FAB

    final partidas = (widget.currentUser is Jogador)
        ? (widget.currentUser as Jogador).partidas
        : [];
    Partida? partidaAtual;
    try {
      partidaAtual = partidas.firstWhere((p) => p.estado == EstadoPartida.emAndamento);
    } catch (_) {
      partidaAtual = null;
    }
    if (partidaAtual == null) return const SizedBox.shrink();

    return Positioned(
      left: posX,
      top: posY,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            posX = (posX! + details.delta.dx).clamp(0.0, size.width - 56); // 56 = tamanho do FAB
            posY = (posY! + details.delta.dy).clamp(0.0, size.height - 56);
          });
        },
        child: FloatingActionButton.extended(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.sports_soccer),
          label: const Text(
            'Ir para Partida',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            final partidas = (widget.currentUser is Jogador)
                ? (widget.currentUser as Jogador).partidas
                : [];
            Partida? partidaAtual;
            try {
              partidaAtual = partidas.firstWhere((p) => p.estado == EstadoPartida.emAndamento);
            } catch (_) {
              partidaAtual = null;
            }
            if (partidaAtual != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PartidaPage(partida: partidaAtual!),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Não há nenhuma partida em andamento!')),
              );
            }
          },
        ),
      ),
    );
  }
}