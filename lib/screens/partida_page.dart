import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/controllers/user_provider.dart';
import 'package:sports_link/styles/carouselbg.dart'; // Import do carousel de imagens de fundo

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
  bool isUserJoined = false; // Controla se o usuário já se juntou à partida

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
    _iniciarContador();
  }

  void _iniciarContador() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          tempoRestante = tempoRestante - const Duration(seconds: 1);
          if (tempoRestante.isNegative) {
            _timer?.cancel();
          }
        });
      }
    });
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

    // Obter o usuário atual do Provider
    final currentUser = Provider.of<UserProvider>(context).user as Jogador;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Partida'),
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          // Carousel de imagens de fundo
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

                // Informações do campo
                Container(
                  width: double.infinity, // Faz o contêiner ocupar toda a largura
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
                      Text(
                        'Tempo de Espera: ${widget.tempoEspera} minutos',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      Text(
                        'Número Mínimo de Jogadores: ${widget.minJogadores}',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Estado: ${campo.ocupado ? "Ocupado" : "Disponível"}',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),

                      // Timer regressivo com mensagem condicional
                      Text(
                        tempoRestante.isNegative
                            ? 'Partida já começou.'
                            : 'Aguardando jogadores: ${tempoRestante.inMinutes.remainder(60).toString().padLeft(2, '0')}:${tempoRestante.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 16,
                          color: tempoRestante.isNegative ? Colors.red : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Lista de jogadores com fundo estilizado
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
                      if (partida.jogadores!.isNotEmpty)
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
                                      jogador.urlIMG ?? 'assets/default_image.png'),
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

                // Botão "Juntar-me" ou "Convidar Amigos"
                if (!isUserJoined)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Adicionar o usuário atual à lista de jogadores
                          partida.jogadores!.add(currentUser);
                          isUserJoined = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                          onPressed: () {
                            // Lógica para convidar amigos
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Convites enviados!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
