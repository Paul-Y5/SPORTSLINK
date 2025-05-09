import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sports_link/models/partida.dart';

class TempoDeJogo extends StatefulWidget {
  final Partida partida;

  const TempoDeJogo({super.key, required this.partida});

  @override
  State<TempoDeJogo> createState() => _TempoDeJogoState();
}

class _TempoDeJogoState extends State<TempoDeJogo> {
  late Timer _timer;
  String _tempo = '';

  @override
  void initState() {
    super.initState();
    _atualizarTempo();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _atualizarTempo();
    });
  }

  void _atualizarTempo() {
    final now = DateTime.now();
    final inicio = DateTime(
      widget.partida.data.year,
      widget.partida.data.month,
      widget.partida.data.day,
      widget.partida.hora.hour,
      widget.partida.hora.minute,
    );

    final tempoDecorrido = now.difference(inicio);
    final minutos = tempoDecorrido.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final segundos = tempoDecorrido.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    setState(() {
      _tempo = '$minutos:$segundos';
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Tempo de jogo: $_tempo',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
