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
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Partida encerrada!')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final partida = widget.partida;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Gerenciar Partida'),
        backgroundColor: Colors.orange[400],
        elevation: 0,
      ),
      body: Stack(
        children: [
          const Carouselbg(),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informações gerais da partida
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Campo: ${partida.campo.nome}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Estado: ${_getEstadoPartida(partida)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: partida.estado == EstadoPartida.terminada
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Jogadores: ${partida.jogadores?.length ?? 0}/${partida.numeroJogadoresMaximo ?? 'N/A'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Data: ${partida.data.day}/${partida.data.month}/${partida.data.year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Hora: ${partida.hora.format(context)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Duração: ${partida.duracao?.toStringAsFixed(0) ?? 'N/A'} minutos',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Resultado: ${partida.resultado ?? 'N/A'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Número mínimo de jogadores
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Número Mínimo de Jogadores',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _minJogadoresController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: 'Digite o número mínimo de jogadores',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Número máximo de jogadores
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Número Máximo de Jogadores',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _maxJogadoresController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: 'Digite o número máximo de jogadores',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Resultado da partida
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resultado da Partida',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _resultadoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: 'Digite o resultado da partida',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Botões de ação
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _atualizarPartida,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Atualizar',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _encerrarPartida,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Encerrar Partida',
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
        return 'Aguardando jogadores';
      case EstadoPartida.emAndamento:
        return 'Em andamento';
      case EstadoPartida.terminada:
        return 'Finalizada';
      case EstadoPartida.cancelada:
        return 'Cancelada';
      default:
        return 'Estado desconhecido';
    }
  }
}
