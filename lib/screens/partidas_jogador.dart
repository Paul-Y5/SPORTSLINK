import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/controllers/controller_dropdown.dart' as dpd;
import 'package:sports_link/controllers/user_provider.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/models/utilizador.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/styles/custom_appbar.dart';

class ListaPartidasPage extends StatefulWidget {
  const ListaPartidasPage({super.key});

  @override
  State<ListaPartidasPage> createState() => _ListaPartidasPageState();
}

class _ListaPartidasPageState extends State<ListaPartidasPage> {
  late List<Partida> partidasPublicas;
  late List<Partida> partidasPrivadas;
  final GlobalKey notificationButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    partidasPublicas = [];
    partidasPrivadas = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentUser = Provider.of<UserProvider>(context).user as Jogador;

    setState(() {
      partidasPublicas = currentUser.partidas
          .where((partida) => partida.tipo == TipoPartida.publica)
          .toList();
      partidasPrivadas = currentUser.partidas
          .where((partida) => partida.tipo == TipoPartida.privada)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        notificationButtonKey: notificationButtonKey,
        onNotificationPressed: (context) {
          dpd.showNotificationDropdown(
            context,
            notificationButtonKey,
            userProvider as Utilizador,
          );
        },
        onMenuPressed: (context, items) {
          dpd.toggleDropdownOverlay(context, items);
        },
      ),
      body: Stack(
        children: [
          const Carouselbg(), // Fundo animado
          if (partidasPublicas.isEmpty && partidasPrivadas.isEmpty)
            const Center(
              child: Text(
                'Nenhuma partida agendada.',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.orange),
              ),
            )
          else
            ListView(
              children: [
                // Exibir partidas públicas
                if (partidasPublicas.isNotEmpty) ...[
                  _buildPartidasHeader('Partidas Públicas'),
                  _buildPartidasList(partidasPublicas),
                ],
                // Exibir partidas privadas
                if (partidasPrivadas.isNotEmpty) ...[
                  _buildPartidasHeader('Partidas Privadas'),
                  _buildPartidasList(partidasPrivadas),
                ],
              ],
            ),
        ],
      ),
    );
  }

  // Função para criar o cabeçalho das partidas
  Widget _buildPartidasHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Função para construir a lista de partidas
  Widget _buildPartidasList(List<Partida> partidas) {
    return Column(
      children: partidas.map((partida) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text('Partida ${partida.id} - ${partida.campo.nome}'),
            subtitle: Text(
              '${partida.data.toLocal()} - ${partida.hora.format(context)}',
            ),
            trailing: Icon(_getEstadoIcon(partida.estado)),
            onTap: () {
              // Lógica para navegar para os detalhes da partida
              _navigateToPartidaDetalhes(partida);
            },
          ),
        );
      }).toList(),
    );
  }

  // Função para obter o ícone de acordo com o estado da partida
  IconData _getEstadoIcon(EstadoPartida estado) {
    switch (estado) {
      case EstadoPartida.agendada:
        return Icons.schedule;
      case EstadoPartida.aguardando:
        return Icons.people;
      case EstadoPartida.emAndamento:
        return Icons.sports;
      case EstadoPartida.terminada:
        return Icons.check_circle;
      case EstadoPartida.cancelada:
        return Icons.cancel;
      }
  }

  // Função para navegar para os detalhes da partida
  void _navigateToPartidaDetalhes(Partida partida) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PartidaDetalhesPage(partida: partida),
      ),
    );
  }
}

// Exemplo de uma página de detalhes da partida
class PartidaDetalhesPage extends StatefulWidget {
  final Partida partida;

  const PartidaDetalhesPage({super.key, required this.partida});

  @override
  State<PartidaDetalhesPage> createState() => _PartidaDetalhesPageState();
}

class _PartidaDetalhesPageState extends State<PartidaDetalhesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Partida ${widget.partida.id}'),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Campo: ${widget.partida.campo.nome}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Data: ${widget.partida.data.toLocal()}'),
              Text('Hora: ${widget.partida.hora.format(context)}'),
              const SizedBox(height: 16),
              Text(
                'Estado: ${widget.partida.estado.name}',
                style: const TextStyle(fontSize: 16),
              ),
              const Spacer(),
              if (widget.partida.estado != EstadoPartida.cancelada &&
                  widget.partida.estado != EstadoPartida.terminada)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        (Provider.of<UserProvider>(context, listen: false)
                            .user as Jogador).partidas
                            .removeWhere((partida) => partida.id == widget.partida.id);
                        Campo campo = widget.partida.campo;
                        if (campo is CampoPriv) {
                          campo.reservas.removeWhere(
                            (reserva, _) => reserva == widget.partida.data,
                          );
                        }
                        widget.partida.estado = EstadoPartida.cancelada;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reserva cancelada com sucesso!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      Navigator.pop(context); // Volta à lista após cancelar, se quiseres
                    },
                    child: const Text(
                      'Cancelar Reserva',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
