import 'dart:async';
import 'package:flutter/material.dart';

class TempoPartidaWidget extends StatefulWidget {
  final DateTime inicio; // Data e hora de início da partida
  final int? duracao;    // Em minutos, ou null para progressivo

  const TempoPartidaWidget({super.key, required this.inicio, this.duracao});

  @override
  State<TempoPartidaWidget> createState() => _TempoPartidaWidgetState();
}

class _TempoPartidaWidgetState extends State<TempoPartidaWidget> {
  late Timer _timer;
  late int _segundos; // Pode ser decorrido ou restante

  @override
  void initState() {
    super.initState();
    _updateTempo();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _updateTempo();
      });
    });
  }

  void _updateTempo() {
    final agora = DateTime.now();
    final inicio = widget.inicio;
    if (widget.duracao != null) {
      // Regressivo
      final fim = inicio.add(Duration(minutes: widget.duracao!));
      _segundos = fim.difference(agora).inSeconds;
      if (_segundos < 0) _segundos = 0;
    } else {
      // Progressivo
      _segundos = agora.difference(inicio).inSeconds;
      if (_segundos < 0) _segundos = 0;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatarTempo(int totalSegundos) {
    final minutos = (totalSegundos ~/ 60).toString().padLeft(2, '0');
    final segundos = (totalSegundos % 60).toString().padLeft(2, '0');
    return '$minutos:$segundos';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.timer, color: Colors.orange),
        const SizedBox(width: 8),
        Text(
          widget.duracao != null
              ? 'Tempo restante: ${_formatarTempo(_segundos)}'
              : 'Tempo: ${_formatarTempo(_segundos)}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}