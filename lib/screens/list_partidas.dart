import 'package:flutter/material.dart';
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/screens/partida_page.dart';
import 'package:sports_link/styles/carouselbg.dart';

class ListPartidas extends StatefulWidget {
  const ListPartidas({super.key});

  @override
  State<ListPartidas> createState() => _ListPartidasState();
}

class _ListPartidasState extends State<ListPartidas> {
  final List<Partida> partidasPublicasDisponiveis =
      mockPartidas.where((partida) {
        return partida.tipo == TipoPartida.publica &&
            (partida.estado == EstadoPartida.aguardando ||
                partida.estado == EstadoPartida.emAndamento);
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Carousel no fundo
          const Carouselbg(),
          // Conteúdo principal
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Partidas Públicas Disponíveis'),
              backgroundColor: Colors.orange, // Transparência no AppBar
              elevation: 0,
            ),
            body: partidasPublicasDisponiveis.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma partida disponível no momento.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: partidasPublicasDisponiveis.length,
                    itemBuilder: (context, index) {
                      final partida = partidasPublicasDisponiveis[index];

                      // Definir valores padrão para tempo de espera e número mínimo de jogadores
                      final int tempoEspera = 10; // Exemplo: 10 minutos
                      final int minJogadores = 4; // Exemplo: 4 jogadores

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(
                            partida.campo.nome,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          subtitle: Text(
                            '${partida.data.day}/${partida.data.month}/${partida.data.year} às ${partida.hora.format(context)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PartidaPage(
                                    partida: partida,
                                    tempoEspera: tempoEspera,
                                    minJogadores: minJogadores,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text(
                              'Ver Detalhes',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
