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
  late TextEditingController _resultadoController;

  double draggableX = 20;
  double draggableY = 100;
  bool isMinimized = false;

  @override
  void initState() {
    super.initState();
    _minJogadoresController = TextEditingController(
      text: widget.partida.numeroJogadoresMinimo?.toString() ?? '0',
    );
    _resultadoController = TextEditingController(
      text: widget.partida.resultado ?? '',
    );
  }

  @override
  void dispose() {
    _minJogadoresController.dispose();
    _resultadoController.dispose();
    super.dispose();
  }

  void _atualizarPartida() {
    setState(() {
      widget.partida.numeroJogadoresMinimo =
          int.tryParse(_minJogadoresController.text) ?? 0;
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
                          'Estado: ${partida.estado == EstadoPartida.aguardando
                              ? "Aguardando"
                              : partida.estado == EstadoPartida.emAndamento
                              ? "Em Andamento"
                              : "Finalizada"}',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                partida.estado == EstadoPartida.terminada
                                    ? Colors.red
                                    : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Jogadores: ${partida.jogadores?.length ?? 0}',
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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

          // ===================== CARD FLUTUANTE =====================
          Positioned(
            top: draggableY,
            left: draggableX,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  draggableX += details.delta.dx;
                  draggableY += details.delta.dy;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 200,
                height: isMinimized ? 60 : 180,
                decoration: BoxDecoration(
                  color: Colors.orange[400],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(50, 0, 0, 0),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(
                        "Card Flutuante",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isMinimized ? Icons.expand_more : Icons.expand_less,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isMinimized = !isMinimized;
                          });
                        },
                      ),
                    ),
                    if (!isMinimized)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Conteúdo extra do card flutuante.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
