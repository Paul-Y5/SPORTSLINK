import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/controllers/user_provider.dart';
import 'package:sports_link/styles/carouselbg.dart';

class HistoricoPage extends StatelessWidget {
  const HistoricoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obter o usuário atual
    final currentUser = Provider.of<UserProvider>(context).user as Jogador;

    // Filtrar partidas finalizadas e canceladas do usuário
    final historicoPartidas = currentUser.partidas.where((partida) {
      return partida.estado == EstadoPartida.terminada ||
          partida.estado == EstadoPartida.cancelada;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Partidas'),
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          // Fundo com o Carousel
          const Carouselbg(),
          // Conteúdo principal
          historicoPartidas.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhuma partida finalizada ou cancelada encontrada.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: historicoPartidas.length,
                  itemBuilder: (context, index) {
                    final partida = historicoPartidas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${partida.data.day}/${partida.data.month}/${partida.data.year} às ${partida.hora.format(context)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              'Estado: ${partida.estado == EstadoPartida.terminada ? "Finalizada" : "Cancelada"}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            if (partida.estado == EstadoPartida.terminada)
                              Text(
                                'Resultado: ${partida.resultado ?? "N/A"}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}