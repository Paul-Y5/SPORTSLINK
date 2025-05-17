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

class PartidaPage extends StatefulWidget {
  final Partida partida;

  const PartidaPage({super.key, required this.partida});

  @override
  State<PartidaPage> createState() => _PartidaPageState();
}

class _PartidaPageState extends State<PartidaPage> {
  late Duration tempoRestante;
  Timer? _timer;
  bool isUserJoined = false;
  late Jogador currentUser;
  final TextEditingController _chatController = TextEditingController();

  @override
  void initState() {
    super.initState();

    tempoRestante = calcularTempoRestante(widget.partida.data, widget.partida.hora);

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

            if (tempoRestante.isNegative) {
              _timer?.cancel();

              if (widget.partida.jogadores!.length < widget.partida.numeroJogadoresMinimo!) {
                widget.partida.setEstado(EstadoPartida.cancelada);
                mockPartidas.removeWhere((p) => p.id == widget.partida.id);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('A partida foi cancelada por falta de jogadores.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                Future.delayed(const Duration(seconds: 3), () {
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage1(id: currentUser.id),
                      ),
                    );
                  }
                });
              } else {
                setState(() {
                  widget.partida.estado = EstadoPartida.emAndamento;
                });

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('A partida foi iniciada!'),
                      backgroundColor: Colors.green,
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
    _chatController.dispose();
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
              onPressed: () => Navigator.of(context).pop(),
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
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, insira o nome do amigo.'),
                      backgroundColor: Colors.red,
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
    final infoStyle = TextStyle(fontSize: 16, color: Colors.grey[800]);
    final labelStyle = TextStyle(fontSize: 14, color: Colors.orange[700], fontWeight: FontWeight.w500);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Detalhes da Partida'),
        centerTitle: true,
        backgroundColor: Colors.orange[400],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.people, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
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
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Fechar',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
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
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.sports_soccer, color: Colors.orange[700], size: 28),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                campo.nome,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[800],
                                ),
                              ),
                            ),
                            if (partida.estado == EstadoPartida.emAndamento)
                              const BlinkingDot(),
                          ],
                        ),
                        const Divider(height: 28, thickness: 1.2),
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.people_alt_outlined, color: Colors.orange),
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
                        const SizedBox(height: 8),
                        Text(
                          'Estado: ${_getEstadoPartida(partida)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: partida.estado == EstadoPartida.cancelada ? Colors.red : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
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
                const SizedBox(height: 20),

                // Card do chat
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
                          height: 180,
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
                const SizedBox(height: 20),

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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${currentUser.nome} entrou na partida!')),
                            );
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
}
