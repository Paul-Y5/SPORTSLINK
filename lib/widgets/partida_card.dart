import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/screens/partida_page.dart';
import 'package:sports_link/utils/time_utils.dart';
import 'package:sports_link/utils/blinkdot.dart';

class PartidaCard extends StatefulWidget {
  final Partida partida;

  const PartidaCard({super.key, required this.partida});

  @override
  PartidaCardState createState() => PartidaCardState();
}

class PartidaCardState extends State<PartidaCard> {
  late Duration tempoRestante;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _atualizarTempoRestante();
    _iniciarAtualizacao();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _atualizarTempoRestante() {
    setState(() {
      tempoRestante = calcularTempoRestante(widget.partida.data, widget.partida.hora);
    });
  }

  void _iniciarAtualizacao() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _atualizarTempoRestante();
    });
  }

  @override
  Widget build(BuildContext context) {
    final minutos = tempoRestante.inMinutes.remainder(60).toString().padLeft(2, '0');
    final segundos = tempoRestante.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    widget.partida.campo.nome,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
                if (widget.partida.estado == EstadoPartida.emAndamento)
                  const BlinkingDot(), // Bolinha vermelha intermitente
              ],
            ),
            const SizedBox(height: 8),

            // Data e hora da partida
            Text(
              '${widget.partida.data.day}/${widget.partida.data.month}/${widget.partida.data.year} às ${widget.partida.hora.format(context)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),

            // Estado da partida
            Text(
              'Estado: ${widget.partida.estado == EstadoPartida.aguardando ? "Aguardando Jogadores" : widget.partida.estado == EstadoPartida.emAndamento ? "Em Andamento" : "Cancelada"}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),

            // Tempo restante ou tempo de jogo
            if (widget.partida.estado == EstadoPartida.aguardando)
              Text(
                'Tempo restante: $minutos:$segundos',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              )
            else if (widget.partida.estado == EstadoPartida.emAndamento)
              Text(
                'Tempo de jogo: ${widget.partida.resultado ?? "N/A"}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.red,
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
                        partida: widget.partida,
                        tempoEspera: 15,
                        minJogadores: widget.partida.numeroJogadoresMinimo ?? 4, // Valor padrão caso seja null
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  }
}