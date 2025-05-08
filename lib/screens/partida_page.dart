import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/controllers/user_provider.dart';
import 'package:sports_link/screens/main_page_1.dart';
import 'package:sports_link/styles/carouselbg.dart';

class PartidaPage extends StatefulWidget {
  final Partida partida;
  final int tempoEspera; // minutos
  final int minJogadores;

  const PartidaPage({
    super.key,
    required this.partida,
    required this.tempoEspera,
    required this.minJogadores,
  });

  @override
  State<PartidaPage> createState() => _PartidaPageState();
}

class _PartidaPageState extends State<PartidaPage> {
  late Duration tempoRestante;
  Timer? _timer;
  bool isUserJoined = false;

  late Jogador currentUser;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final partidaDateTime = DateTime(
      widget.partida.data.year,
      widget.partida.data.month,
      widget.partida.data.day,
      widget.partida.hora.hour,
      widget.partida.hora.minute,
    );

    // Verificar o estado da partida e calcular o tempo restante apenas se estiver "aguardando"
    if (widget.partida.estado == EstadoPartida.aguardando) {
      tempoRestante = partidaDateTime.difference(now);
    } else {
      tempoRestante = Duration.zero; // Partida já começou
    }

    // Obtem o usuário atual e define se já está na partida
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentUser =
          Provider.of<UserProvider>(context, listen: false).user as Jogador;
      setState(() {
        isUserJoined =
            widget.partida.jogadores?.any((j) => j.id == currentUser.id) ??
            false;
      });
    });

    _iniciarContador();
  }

  void _iniciarContador() {
    if (widget.partida.estado == EstadoPartida.aguardando) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            tempoRestante -= const Duration(seconds: 1);

            // Verifica se o tempo acabou
            if (tempoRestante.isNegative) {
              _timer?.cancel();

              // Verifica se há jogadores suficientes para iniciar a partida
              if (widget.partida.jogadores!.length < widget.minJogadores) {
                // Cancela a partida
                widget.partida.setEstado(EstadoPartida.cancelada);
                mockPartidas.removeWhere((p) => p.id == widget.partida.id);

                // Exibe uma mensagem informando que a partida foi cancelada
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('A partida foi cancelada por falta de jogadores.'),
                  ),
                );

                // No fim de 10 segundos, navega para a tela inicial
                Future.delayed(const Duration(seconds: 10), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage1(id: currentUser.id),
                    ),
                  );
                });
              } else {
                // Inicia a partida
                setState(() {
                  widget.partida.estado = EstadoPartida.emAndamento;
                });

                // Exibe uma mensagem informando que a partida começou
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('A partida foi iniciada!'),
                  ),
                );
              }
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildBlinkingDot() {
    return const SizedBox(
      width: 10,
      height: 10,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final partida = widget.partida;
    final campo = partida.campo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Partida'),
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          const Carouselbg(),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagem do campo
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    campo.imagem,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),

                // Informações do campo e partida
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Campo: ${campo.nome}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (partida.estado == EstadoPartida.emAndamento)
                            _buildBlinkingDot(), // Bolinha vermelha intermitente
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Tempo de Espera: ${widget.tempoEspera} minutos'),
                      Text(
                        'Número Mínimo de Jogadores: ${widget.minJogadores}',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Estado: ${partida.estado == EstadoPartida.aguardando ? "Aguardando" : partida.estado == EstadoPartida.emAndamento ? "Em Andamento" : "Cancelada"}',
                      ),
                      const SizedBox(height: 16),
                      if (partida.estado == EstadoPartida.aguardando)
                        Text(
                          'Aguardando jogadores: ${tempoRestante.inMinutes.remainder(60).toString().padLeft(2, '0')}:${tempoRestante.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                          ),
                        )
                      else if (partida.estado == EstadoPartida.emAndamento)
                        Text(
                          'Resultado ao vivo: ${partida.resultado ?? "N/A"}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        )
                      else
                        const Text(
                          'Partida cancelada.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Lista de jogadores
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(250, 255, 255, 255),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jogadores no Campo:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (partida.jogadores?.isNotEmpty ?? false)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: partida.jogadores!.length,
                          itemBuilder: (context, index) {
                            final jogador = partida.jogadores![index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(200, 255, 153, 0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage(
                                    jogador.urlIMG ??
                                        'assets/default_image.png',
                                  ),
                                  radius: 20,
                                ),
                                title: Text(
                                  jogador.nome,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('Nível: ${jogador.nivel}'),
                              ),
                            );
                          },
                        )
                      else
                        const Text(
                          'Nenhum jogador presente no momento.',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
