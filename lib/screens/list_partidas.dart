import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/controllers/controller_dropdown.dart' as dpd;
import 'package:sports_link/controllers/user_provider.dart';
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/styles/carouselbg.dart';

import 'package:sports_link/styles/custom_appbar.dart'; // importa a custom appbar
import 'package:sports_link/widgets/partida_card.dart';

class ListPartidas extends StatefulWidget {
  const ListPartidas({super.key});

  @override
  State<ListPartidas> createState() => _ListPartidasState();
}

class _ListPartidasState extends State<ListPartidas> {
  final GlobalKey notificationButtonKey = GlobalKey();

  final List<Partida> partidasPublicasDisponiveis =
      mockPartidas.where((partida) {
        return partida.tipo == TipoPartida.publica &&
            (partida.estado == EstadoPartida.aguardando ||
                partida.estado == EstadoPartida.emAndamento);
      }).toList();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final Jogador? currentUser = userProvider.user as Jogador?;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Carouselbg(),
          Column(
            children: [
              CustomAppBar(
                notificationButtonKey: notificationButtonKey,
                onNotificationPressed: (ctx) {
                  if (currentUser != null) {
                    dpd.showNotificationDropdown(
                      context,
                      notificationButtonKey,
                      currentUser,
                    );
                  }
                },
                onMenuPressed: (ctx, items) {
                  dpd.toggleDropdownOverlay(context, items);
                },
              ),
              Expanded(
                child: partidasPublicasDisponiveis.isEmpty
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
                          return PartidaCard(partida: partida);
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}