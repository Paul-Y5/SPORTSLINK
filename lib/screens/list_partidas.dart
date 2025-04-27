import 'package:flutter/material.dart';

class ListPartidas extends StatefulWidget {
  const ListPartidas({super.key});

  @override
  State<ListPartidas> createState() => _ListPartidasState();
}

class _ListPartidasState extends State<ListPartidas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Partidas'),
      ),
      body: ListView.builder(
        itemCount: 10, // Número de partidas
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Partida ${index + 1}'),
            subtitle: Text('Detalhes da partida ${index + 1}'),
            onTap: () {
              // Ação ao tocar na partida
            },
          );
        },
      ),
    );
  }
}
