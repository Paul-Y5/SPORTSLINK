import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sports_link/models/partida.dart';

class CountdownTimer extends StatefulWidget {
  final Partida partida;

  const CountdownTimer({super.key, required this.partida});

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  late Duration remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    remainingTime = Duration(
      milliseconds: (widget.partida.duracao! * 1000).toInt(),
    );
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
    final minutes = remainingTime.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = remainingTime.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
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
