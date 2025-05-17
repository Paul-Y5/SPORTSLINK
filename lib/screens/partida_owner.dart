import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/styles/carouselbg.dart';

class PartidaOwnerPage extends StatefulWidget {
  final Partida partida;
  final dynamic user; // Replace 'dynamic' with your actual User type if available

  const PartidaOwnerPage({super.key, required this.partida, required this.user});

  @override
  State<PartidaOwnerPage> createState() => _PartidaOwnerPageState();
}

class _PartidaOwnerPageState extends State<PartidaOwnerPage> {
  late TextEditingController _minJogadoresController;
  late TextEditingController _maxJogadoresController;
  late TextEditingController _resultadoController;

  // Novo: Contagem regressiva para início automático
  Timer? _countdownTimer;
  int _segundosRestantes = 30; // Exemplo: 30 segundos para início automático

  @override
  void initState() {
    super.initState();
    _minJogadoresController = TextEditingController(
      text: widget.partida.numeroJogadoresMinimo?.toString() ?? '0',
    );
    _maxJogadoresController = TextEditingController(
      text: widget.partida.numeroJogadoresMaximo?.toString() ?? '0',
    );
    _resultadoController = TextEditingController(
      text: widget.partida.resultado ?? '',
    );

    // Se a partida está aguardando e já tem jogadores mínimos, inicia contagem
    if (widget.partida.estado == EstadoPartida.aguardando &&
        (widget.partida.jogadores?.length ?? 0) >= (widget.partida.numeroJogadoresMinimo ?? 0) &&
        (widget.partida.numeroJogadoresMinimo ?? 0) > 0) {
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _minJogadoresController.dispose();
    _maxJogadoresController.dispose();
    _resultadoController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  // Novo: Função para iniciar contagem regressiva
  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _segundosRestantes = 30; // Ou outro valor desejado
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_segundosRestantes > 0) {
          _segundosRestantes--;
        } else {
          timer.cancel();
          _comecarPartida();
        }
      });
    });
  }

  // Novo: Função para começar a partida
  void _comecarPartida() {
    if ((widget.partida.jogadores?.length ?? 0) < (widget.partida.numeroJogadoresMinimo ?? 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não há jogadores suficientes para começar a partida!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      widget.partida.estado = EstadoPartida.emAndamento;
      (widget.user as Jogador).isInPartida = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Partida iniciada!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _atualizarPartida() {
    setState(() {
      widget.partida.numeroJogadoresMinimo =
          int.tryParse(_minJogadoresController.text) ?? 0;
      widget.partida.numeroJogadoresMaximo =
          int.tryParse(_maxJogadoresController.text) ?? 0;
      widget.partida.resultado = _resultadoController.text;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partida atualizada com sucesso!')),
    );
  }

  void _encerrarPartida() {
    setState(() {
      widget.partida.estado = EstadoPartida.terminada;
      // Remover a partida do campo
      widget.partida.campo.partida = null;
      widget.partida.campo.ocupado = false;
      // Remover a partida do jogador
      // Remover a resto dos jogadores
      for (var jogador in widget.partida.jogadores!) {
        jogador.isInPartida = false;
      }

      // Adicionar ao histórico de todos os jogadores da partida
      if (widget.partida.jogadores != null) {
        for (var jogador in widget.partida.jogadores!) {
          if (!jogador.partidas.contains(widget.partida)) {
            jogador.adicionarPartida(widget.partida);
          }
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partida encerrada!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final partida = widget.partida;
    final infoStyle = TextStyle(fontSize: 16, color: Colors.grey[800]);
    final labelStyle = const TextStyle(
      fontSize: 14,
      color: Colors.orange,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Partida Detalhes'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.orange[400],
        elevation: 0,
      ),
      body: Stack(
        children: [
          const Carouselbg(),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 32 + kToolbarHeight, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card informações gerais
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.sports_soccer,
                                color: Colors.orange[700], size: 28),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                partida.campo.nome,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[800],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getEstadoColor(partida),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _getEstadoPartida(partida),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 28, thickness: 1.2),
                        ListTile(
                          dense: true,
                          leading:
                              const Icon(Icons.people_alt_outlined, color: Colors.orange),
                          title: Text('Jogadores', style: labelStyle),
                          subtitle: Text(
                            '${partida.jogadores?.length ?? 0} / ${partida.numeroJogadoresMaximo ?? 'N/A'}',
                            style: infoStyle,
                          ),
                        ),
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.calendar_today, color: Colors.orange),
                          title: Text('Data', style: labelStyle),
                          subtitle: Text(
                            '${partida.data.day.toString().padLeft(2, '0')}/${partida.data.month.toString().padLeft(2, '0')}/${partida.data.year}',
                            style: infoStyle,
                          ),
                        ),
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.access_time, color: Colors.orange),
                          title: Text('Hora', style: labelStyle),
                          subtitle: Text(
                            partida.hora.format(context),
                            style: infoStyle,
                          ),
                        ),
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.timer, color: Colors.orange),
                          title: Text('Duração', style: labelStyle),
                          subtitle: Text(
                            '${partida.duracao?.toStringAsFixed(0) ?? 'N/A'} minutos',
                            style: infoStyle,
                          ),
                        ),
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.emoji_events, color: Colors.orange),
                          title: Text('Resultado', style: labelStyle),
                          subtitle: Text(
                            partida.resultado?.isNotEmpty == true
                                ? partida.resultado!
                                : 'N/A',
                            style: infoStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // NOVO: Contagem regressiva e botão de começar partida
                if (partida.estado == EstadoPartida.aguardando)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if ((partida.jogadores?.length ?? 0) >= (partida.numeroJogadoresMinimo ?? 0) &&
                          (partida.numeroJogadoresMinimo ?? 0) > 0)
                        Column(
                          children: [
                            Text(
                              'A partida irá começar automaticamente em:',
                              style: TextStyle(
                                color: Colors.orange[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${(_segundosRestantes ~/ 60).toString().padLeft(2, '0')}:${(_segundosRestantes % 60).toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () {
                                _countdownTimer?.cancel();
                                _comecarPartida();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              icon: const Icon(Icons.play_arrow, color: Colors.black),
                              label: const Text(
                                'Começar Partida',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          'É necessário pelo menos ${partida.numeroJogadoresMinimo ?? 0} jogadores para começar.',
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      const SizedBox(height: 18),
                    ],
                  ),

                // Card edição de jogadores
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Editar Jogadores',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[700],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _minJogadoresController,
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.orange,
                                decoration: InputDecoration(
                                  labelText: 'Mínimo',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.orange, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelStyle: const TextStyle(color: Colors.orange),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _maxJogadoresController,
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.orange,
                                decoration: InputDecoration(
                                  labelText: 'Máximo',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.orange, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelStyle: const TextStyle(color: Colors.orange),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Card edição do resultado
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resultado da Partida',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[700],
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _resultadoController,
                          cursorColor: Colors.orange,
                          decoration: InputDecoration(
                            labelText: 'Resultado',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.orange, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelStyle: const TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Botões
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _atualizarPartida,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 28,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.save, color: Colors.black),
                      label: const Text(
                        'Atualizar',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _encerrarPartida,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 28,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.stop_circle, color: Colors.white),
                      label: const Text(
                        'Encerrar',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getEstadoPartida(Partida partida) {
    switch (partida.estado) {
      case EstadoPartida.aguardando:
        return 'Aguardando';
      case EstadoPartida.emAndamento:
        return 'Em andamento';
      case EstadoPartida.terminada:
        return 'Finalizada';
      case EstadoPartida.cancelada:
        return 'Cancelada';
      default:
        return 'Desconhecido';
    }
  }

  Color _getEstadoColor(Partida partida) {
    switch (partida.estado) {
      case EstadoPartida.aguardando:
        return Colors.blueAccent;
      case EstadoPartida.emAndamento:
        return Colors.orange;
      case EstadoPartida.terminada:
        return Colors.red;
      case EstadoPartida.cancelada:
        return Colors.grey;
      default:
        return Colors.black26;
    }
  }
}