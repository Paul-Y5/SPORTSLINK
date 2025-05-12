import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/models/msg.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/controllers/user_provider.dart';
import 'package:sports_link/screens/main_page_1.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/utils/blinkdot.dart';
import 'package:sports_link/utils/time_utils.dart';
import 'package:sports_link/widgets/style_row.dart';

class PartidaPage extends StatefulWidget {
  final Partida partida;

  const PartidaPage({
    super.key,
    required this.partida,
  });

  @override
  State<PartidaPage> createState() => _PartidaPageState();
}

class _PartidaPageState extends State<PartidaPage> {
  late Duration tempoRestante;
  Timer? _timer;
  bool isUserJoined = false;

  late Jogador currentUser;
  final TextEditingController _chatController = TextEditingController(); // Controlador para o chat

  @override
  void initState() {
    super.initState();

    // Calcula o tempo restante usando a função utilitária
    tempoRestante = calcularTempoRestante(widget.partida.data, widget.partida.hora);

    // Obtém o usuário atual e define se já está na partida
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        currentUser = Provider.of<UserProvider>(context, listen: false).user as Jogador;
        setState(() {
          isUserJoined = widget.partida.jogadores?.any((j) => j.id == currentUser.id) ?? false;
        });
      }
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
              if (widget.partida.jogadores!.length < widget.partida.numeroJogadoresMinimo!) {
                // Cancela a partida
                widget.partida.setEstado(EstadoPartida.cancelada);
                mockPartidas.removeWhere((p) => p.id == widget.partida.id);

                // Exibe uma mensagem informando que a partida foi cancelada
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('A partida foi cancelada por falta de jogadores.'),
                    ),
                  );
                }

                // No fim de 10 segundos, navega para a tela inicial
                Future.delayed(const Duration(seconds: 10), () {
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage1(id: currentUser.id),
                      ),
                    );
                  }
                });
              } else {
                // Inicia a partida
                setState(() {
                  widget.partida.estado = EstadoPartida.emAndamento;
                });

                // Exibe uma mensagem informando que a partida começou
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('A partida foi iniciada!'),
                    ),
                  );
                }
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
    _chatController.dispose(); // Libera o controlador do chat
    super.dispose();
  }

  void _showInviteFriendsPopup() {
    final TextEditingController inviteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Convidar Amigos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Digite o nome do amigo que deseja convidar:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: inviteController,
                decoration: InputDecoration(
                  hintText: 'Nome do amigo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.orange),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.orange),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (inviteController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Convite enviado para ${inviteController.text}!'),
                    ),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, insira o nome do amigo.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Enviar Convite',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _sendMessage() {
    if (_chatController.text.isNotEmpty) {
      setState(() {
        widget.partida.chat!.add(
          Msg(
            remetente: currentUser,
            conteudo: _chatController.text, 
            timestamp: DateTime.now(),  
          ),
        );
      });
      _chatController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final partida = widget.partida;
    final campo = partida.campo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Partida'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.people, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      'Jogadores na Partida (${partida.jogadores?.length ?? 0})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          if (partida.jogadores?.isNotEmpty ?? false)
                            ...partida.jogadores!.map((jogador) {
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
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
                                ),
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
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Fechar',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          const Carouselbg(), // Fundo com o carousel
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informações do campo e partida
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
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
                              const BlinkingDot(), // Bolinha vermelha intermitente
                          ],
                        ),
                        const SizedBox(height: 8),
                        buildInfoRow('Número Mínimo de Jogadores', '${widget.partida.numeroJogadoresMinimo}'),
                        buildInfoRow('Jogadores na Partida', '${partida.jogadores?.length ?? 0}'),
                        const SizedBox(height: 16),
                        Text(
                          'Estado: ${partida.estado == EstadoPartida.aguardando ? "Aguardando" : partida.estado == EstadoPartida.emAndamento ? "Em Andamento" : "Cancelada"}',
                          style: TextStyle(
                            fontSize: 16,
                            color: partida.estado == EstadoPartida.cancelada ? Colors.red : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
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
                ),
                const SizedBox(height: 16),

                // Chat da partida
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chat da Partida',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListView(
                            children: partida.chat!
                                .map((mensagem) => ListTile(
                                      title: Text(mensagem.remetente.nome),
                                      leading: CircleAvatar(
                                        backgroundImage: AssetImage(
                                          mensagem.remetente.urlIMG ?? 'assets/default_image.png',
                                        ),
                                        radius: 20,
                                      ),
                                      subtitle: Text(mensagem.conteudo),
                                    ))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _chatController,
                                decoration: InputDecoration(
                                  hintText: 'Digite sua mensagem...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _sendMessage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Icon(Icons.send, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                              partida.jogadores!.add(currentUser);
                              isUserJoined = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size(200, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Entrar na Partida',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      else if (isUserJoined)
                        ElevatedButton(
                          onPressed: partida.jogadores!.length < (partida.numeroJogadoresMaximo ?? 100)
                              ? () {
                                  _showInviteFriendsPopup();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: partida.jogadores!.length < (partida.numeroJogadoresMaximo ?? 100)
                                ? Colors.orange
                                : Colors.grey,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size(200, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Convidar Amigos',
                            style: TextStyle(fontSize: 18),
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
