import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/controllers/user_provider.dart';
import 'package:sports_link/screens/main_page_1.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/utils/blinkdot.dart';
import 'package:sports_link/utils/time_utils.dart';

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

    // Calcula o tempo restante usando a função utilitária
    tempoRestante = calcularTempoRestante(widget.partida.data, widget.partida.hora);

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
                          Expanded(
                            child: Text(
                              'Campo: ${campo.nome}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          if (partida.estado == EstadoPartida.emAndamento)
                            BlinkingDot(), // Bolinha vermelha intermitente
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Número Mínimo de Jogadores: ${widget.minJogadores}'),
                      Text('Número de Jogadores na Partida: ${partida.jogadores?.length ?? 0}'),
                      const SizedBox(height: 16),
                      Text(
                        'Estado: ${partida.estado == EstadoPartida.aguardando ? "Aguardando" : partida.estado == EstadoPartida.emAndamento ? "Em Andamento" : "Cancelada"}',
                      ),
                      const SizedBox(height: 16),

                      // Timer ou resultado ao vivo
                      if (partida.estado == EstadoPartida.aguardando)
                        Row(
                          children: [
                            const Icon(Icons.timer, color: Colors.orange),
                            const SizedBox(width: 8),
                            Text(
                              'Aguardando jogadores: ${tempoRestante.inMinutes.remainder(60).toString().padLeft(2, '0')}:${tempoRestante.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.orange,
                              ),
                            ),
                          ],
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

                // Botões de ação
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!isUserJoined && partida.jogadores!.length < (partida.numeroJogadoresMaximo ?? 100))
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              partida.jogadores!.add(currentUser); // Adiciona o usuário atual à partida
                              isUserJoined = true; // Marca que o usuário entrou na partida
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size(200, 50), // Define um tamanho mínimo
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Entrar na Partida',
                            style: TextStyle(fontSize: 18), // Aumenta o tamanho da fonte
                          ),
                        )
                      else if (isUserJoined)
                        ElevatedButton(
                          onPressed: partida.jogadores!.length < (partida.numeroJogadoresMaximo ?? 100)
                              ? () {
                                  // Exibe um popup para convidar amigos
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Convidar Amigos'),
                                        content: const Text('Selecione os amigos que você deseja convidar.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Fechar', style: TextStyle(color: Colors.orange)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              : null, // Desabilita o botão se a partida estiver cheia
                          style: ElevatedButton.styleFrom(
                            backgroundColor: partida.jogadores!.length < (partida.numeroJogadoresMaximo ?? 100)
                                ? Colors.orange
                                : Colors.grey,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size(200, 50), // Define um tamanho mínimo
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Convidar Amigos',
                            style: TextStyle(fontSize: 18), // Aumenta o tamanho da fonte
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Lista de jogadores
                // Acordeão para jogadores
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      'Jogadores na Partida (${partida.jogadores?.length ?? 0})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    children: [
                      if (partida.jogadores?.isNotEmpty ?? false)
                        ...partida.jogadores!.map((jogador) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                jogador.urlIMG ?? 'assets/default_image.png',
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
                          );
                        })
                      else
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Nenhum jogador presente no momento.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
