import 'package:flutter/material.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/screens/partida_page.dart';
import 'package:sports_link/utils/time_utils.dart';
import 'package:sports_link/utils/blinkdot.dart';
import 'package:sports_link/utils/tempo_partida_widget.dart';

class PartidaCard extends StatelessWidget {
  final Partida partida;
  const PartidaCard({super.key, required this.partida});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome do campo e bolinha intermitente
            Row(
              children: [
                Expanded(
                  child: Text(
                    partida.campo.nome,
                    style: const TextStyle(
                      fontSize: 18,
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

            // Data e hora da partida
            Text(
              '${partida.data.day}/${partida.data.month}/${partida.data.year} às ${partida.hora.format(context)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),

            // Estado da partida
            Text(
              'Estado: ${partida.estado == EstadoPartida.aguardando ? "Aguardando Jogadores" : partida.estado == EstadoPartida.emAndamento ? "Em Andamento" : "Cancelada"}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),

            // Tempo restante ou tempo de jogo
            if (partida.estado == EstadoPartida.aguardando)
              Text(
                'Tempo restante: ${calcularTempoRestante(partida.data, partida.hora).inMinutes.remainder(60).toString().padLeft(2, '0')}:${calcularTempoRestante(partida.data, partida.hora).inSeconds.remainder(60).toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              )
            else if (partida.estado == EstadoPartida.emAndamento)
              TempoPartidaWidget(
                duracao: partida.duracao?.toInt(),
                inicio: DateTime(
                  partida.data.year,
                  partida.data.month,
                  partida.data.day,
                  partida.hora.hour,
                  partida.hora.minute,
                ), // Converte TimeOfDay para DateTime
              ),
            const SizedBox(height: 8),

            // Botão para ver detalhes
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PartidaPage(
                        partida: partida
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          ],
        ),
      ),
    );
  }
}
