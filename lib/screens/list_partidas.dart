import 'package:flutter/material.dart';
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/screens/partida_page.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'dart:async'; // Import necessário para o Timer

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

                      // Definir valores padrão para tempo de espera e número mínimo de jogadores
                      final int tempoEspera = 10; // Exemplo: 10 minutos
                      final int minJogadores = 4; // Exemplo: 4 jogadores

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nome do campo e bolinha intermitente
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      partida.campo.nome,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                  if (partida.estado == EstadoPartida.emAndamento)
                                    const BlinkingDot(), // Bolinha vermelha intermitente
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Data e hora da partida
                              Text(
                                '${partida.data.day}/${partida.data.month}/${partida.data.year} às ${partida.hora.format(context)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Estado da partida
                              Text(
                                'Estado: ${partida.estado == EstadoPartida.aguardando ? "Aguardando Jogadores" : partida.estado == EstadoPartida.emAndamento ? "Em Andamento" : "Cancelada"}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Tempo restante ou tempo de jogo
                              if (partida.estado == EstadoPartida.aguardando)
                                CountdownTimer(partida: partida) // Tempo restante para partidas aguardando
                              else if (partida.estado == EstadoPartida.emAndamento)
                                Text(
                                  'Tempo de jogo: ${_getTempoDeJogo(partida)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              const SizedBox(height: 8),

                              // Botão para ver detalhes
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PartidaPage(
                                          partida: partida,
                                          tempoEspera: tempoEspera,
                                          minJogadores: minJogadores,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: const Text(
                                    'Ver Detalhes',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class BlinkingDot extends StatefulWidget {
  const BlinkingDot({super.key});

  @override
  _BlinkingDotState createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<BlinkingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: const Icon(
        Icons.circle,
        color: Colors.red,
        size: 12,
      ),
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final Partida partida;

  const CountdownTimer({super.key, required this.partida});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.partida.duracao as Duration; // Duração total da partida
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (remainingTime > const Duration(seconds: 0)) {
            remainingTime -= const Duration(seconds: 1);
          } else {
            _timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');
    return Text(
      'Tempo restante: $minutes:$seconds',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

String _getTempoDeJogo(Partida partida) {
  final now = DateTime.now();
  final inicio = DateTime(
    partida.data.year,
    partida.data.month,
    partida.data.day,
    partida.hora.hour,
    partida.hora.minute,
  );

  final tempoDecorrido = now.difference(inicio);
  final minutos = tempoDecorrido.inMinutes.remainder(60).toString().padLeft(2, '0');
  final segundos = tempoDecorrido.inSeconds.remainder(60).toString().padLeft(2, '0');

  return '$minutos:$segundos';
}
