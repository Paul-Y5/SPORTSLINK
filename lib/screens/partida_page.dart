import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/controllers/user_provider.dart';
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

    tempoRestante = partidaDateTime.difference(now);

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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          tempoRestante -= const Duration(seconds: 1);
          if (tempoRestante.isNegative) _timer?.cancel();
        });
      }
    });
  }

  void _convidarAmigos(BuildContext context, List<Jogador> amigos) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Convidar Amigos'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: amigos.length,
              itemBuilder: (context, index) {
                final amigo = amigos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                        amigo.urlIMG ?? 'assets/default_image.png',
                      ),
                      radius: 20,
                    ),
                    title: Text(
                      amigo.nome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('Nível: ${amigo.id}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${amigo.nome} foi convidado!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Convidar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
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
    final amigos = currentUser.amigos;

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
                      Text(
                        'Campo: ${campo.nome}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Tempo de Espera: ${widget.tempoEspera} minutos'),
                      Text(
                        'Número Mínimo de Jogadores: ${widget.minJogadores}',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Estado: ${campo.ocupado ? "Ocupado" : "Disponível"}',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tempoRestante.isNegative
                            ? 'Partida já começou.'
                            : 'Aguardando jogadores: ${tempoRestante.inMinutes.remainder(60).toString().padLeft(2, '0')}:${tempoRestante.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              tempoRestante.isNegative
                                  ? Colors.red
                                  : Colors.orange,
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
                                subtitle: Text('Nível: ${jogador.id}'),
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
                const SizedBox(height: 16),

                // Botões: Juntar, Convidar ou Abandonar
                if (!isUserJoined)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (!partida.jogadores!.any(
                            (j) => j.id == currentUser.id,
                          )) {
                            partida.jogadores!.add(currentUser);
                            isUserJoined = true;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Juntar-me à Partida',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      Center(
                        child: ElevatedButton(
                          onPressed:
                              () => _convidarAmigos(
                                context,
                                amigos.cast<Jogador>(),
                              ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Convidar Amigos',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              partida.jogadores?.removeWhere(
                                (j) => j.id == currentUser.id,
                              );
                              isUserJoined = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Você abandonou a partida.'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Abandonar Partida',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'À espera que a partida comece...',
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
}
