import 'package:flutter/material.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/styles/carouselbg.dart';

class PartidaOwnerPage extends StatefulWidget {
  final Partida partida;

  const PartidaOwnerPage({super.key, required this.partida});

  @override
  State<PartidaOwnerPage> createState() => _PartidaOwnerPageState();
}

class _PartidaOwnerPageState extends State<PartidaOwnerPage> {
  late TextEditingController _minJogadoresController;
  late TextEditingController _maxJogadoresController;
  late TextEditingController _resultadoController;

  @override
  void initState() {
    super.initState();
    _minJogadoresController = TextEditingController(
      text: widget.partida.numeroJogadoresMinimo?.toString() ?? '0',
    );
    _maxJogadoresController = TextEditingController(
      text: widget.partida.numeroJogadoresMaximo?.toString() ?? '0',
    );
    _resultadoController = TextEditingController(
      text: widget.partida.resultado ?? '',
    );
  }

  @override
  void dispose() {
    _minJogadoresController.dispose();
    _maxJogadoresController.dispose();
    _resultadoController.dispose();
    super.dispose();
  }

  void _atualizarPartida() {
    setState(() {
      widget.partida.numeroJogadoresMinimo =
          int.tryParse(_minJogadoresController.text) ?? 0;
      widget.partida.numeroJogadoresMaximo =
          int.tryParse(_maxJogadoresController.text) ?? 0;
      widget.partida.resultado = _resultadoController.text;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partida atualizada com sucesso!')),
    );
  }

  void _encerrarPartida() {
    setState(() {
      widget.partida.estado = EstadoPartida.terminada;
      // Remover a partida do campo
      widget.partida.campo.partida = null;
      widget.partida.campo.ocupado = false;

      // Adicionar ao histórico de todos os jogadores da partida
      if (widget.partida.jogadores != null) {
        for (var jogador in widget.partida.jogadores!) {
          if (!jogador.partidas.contains(widget.partida)) {
            jogador.adicionarPartida(widget.partida);
          }
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partida encerrada!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final partida = widget.partida;
    final infoStyle = TextStyle(fontSize: 16, color: Colors.grey[800]);
    final labelStyle = TextStyle(
        fontSize: 14,
        color: Colors.orange[700],
        fontWeight: FontWeight.w500);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Partida Detalhes'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.orange[400],
        elevation: 0,
      ),
      body: Stack(
        children: [
          const Carouselbg(),
          SingleChildScrollView(
            padding:
                const EdgeInsets.fromLTRB(16, 32 + kToolbarHeight, 16, 16),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.sports_soccer,
                                color: Colors.orange[700], size: 28),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                partida.campo.nome,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[800],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getEstadoColor(partida),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _getEstadoPartida(partida),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 28, thickness: 1.2),
                        ListTile(
                          dense: true,
                          leading:
                              const Icon(Icons.people_alt_outlined, color: Colors.orange),
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Card edição de jogadores
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
                        Text(
                          'Editar Jogadores',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[700],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _minJogadoresController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Mínimo',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _maxJogadoresController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Máximo',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Card edição do resultado
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
                        Text(
                          'Resultado da Partida',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[700],
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _resultadoController,
                          decoration: InputDecoration(
                            labelText: 'Resultado',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Botões
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _atualizarPartida,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 28,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.save, color: Colors.black),
                      label: const Text(
                        'Atualizar',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _encerrarPartida,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 28,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.stop_circle, color: Colors.white),
                      label: const Text(
                        'Encerrar',
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

  Color _getEstadoColor(Partida partida) {
    switch (partida.estado) {
      case EstadoPartida.aguardando:
        return Colors.blueAccent;
      case EstadoPartida.emAndamento:
        return Colors.orange;
      case EstadoPartida.terminada:
        return Colors.red;
      case EstadoPartida.cancelada:
        return Colors.grey;
      default:
        return Colors.black26;
    }
  }
}
