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
              if (widget.partida.jogadores!.length < widget.minJogadores) {
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
        actions: [
          // Ícone para abrir o popup de jogadores
          IconButton(
            icon: const Icon(Icons.people, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
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
          // Carousel no fundo
          const Carouselbg(),
          // Conteúdo principal
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                // Chat da partida
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
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
                      // Exemplo de mensagens (substitua por um widget de chat real)
                      Container(
                        height: 200, // Altura do chat
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListView(
                          children: partida.chat
                              !.map((mensagem) => ListTile(
                                    title: Text(mensagem.remetente.nome),
                                    leading: CircleAvatar(
                                      backgroundImage: AssetImage(
                                        mensagem.remetente.urlIMG ??
                                            'assets/default_image.png',
                                      ),
                                      radius: 20,
                                    ),
                                    subtitle: Text(mensagem.conteudo),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Campo de entrada de mensagem
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
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
                            onPressed: () {
                              // Lógica para enviar mensagem
                            },
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
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Convidar Amigos'),
                                          content: SizedBox(
                                            width: double.maxFinite,
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: [
                                                if (currentUser
                                                    .amigos
                                                    .isNotEmpty)
                                                  ...currentUser.amigos.map((
                                                    amigo,
                                                  ) {
                                                    return Card(
                                                      margin:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 8,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: ListTile(
                                                        leading: CircleAvatar(
                                                          backgroundImage:
                                                              AssetImage(
                                                                amigo.urlIMG ??
                                                                    'assets/default_image.png',
                                                              ),
                                                          radius: 20,
                                                        ),
                                                        title: Text(
                                                          amigo.nome,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        subtitle: Text(
                                                          'Nível: ${amigo.nivel}',
                                                        ),
                                                        trailing: ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              // Adiciona uma notificação ao array de notificações do amigo
                                                              amigo.notificacoes.add(
                                                                {
                                                                      'tipo':
                                                                          'convite',
                                                                      'mensagem':
                                                                          '${currentUser.nome} convidou você para a partida!',
                                                                      'partidaId':
                                                                          widget
                                                                              .partida
                                                                              .id,
                                                                    }
                                                                    as String,
                                                              );

                                                              // Exibe uma mensagem de sucesso
                                                              ScaffoldMessenger.of(
                                                                context,
                                                              ).showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                    'Convite enviado para ${amigo.nome}!',
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.orange,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Convidar',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  })
                                                else
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 12.0,
                                                        ),
                                                    child: Text(
                                                      'Você não tem amigos para convidar.',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black54,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
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
                                                style: TextStyle(
                                                  color: Color.fromARGB(255,2,2,2,))
                                              ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
