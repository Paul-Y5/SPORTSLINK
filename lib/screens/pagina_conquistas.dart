import 'package:flutter/material.dart';
import 'package:sports_link/models/conquista.dart';

class PaginaConquistas extends StatelessWidget {
  final List<Conquista> conquistas;

  const PaginaConquistas({super.key, required this.conquistas});

  @override
  Widget build(BuildContext context) {
    if (conquistas.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Conquistas')),
        body: Center(
          child: Text(
            'Feature coming soon...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Conquistas')),
      body: ListView.builder(
        itemCount: conquistas.length,
        itemBuilder: (context, index) {
          final conquista = conquistas[index];
          return ListTile(
            leading: Icon(
              conquista.desbloqueada ? Icons.check_circle : Icons.lock,
              color: conquista.desbloqueada ? Colors.green : Colors.grey,
            ),
            title: Text(conquista.nome),
            subtitle: Text(conquista.descricao),
            trailing:
                conquista.desbloqueada
                    ? Text(
                      'Desbloqueada',
                      style: TextStyle(color: Colors.green),
                    )
                    : Text('Bloqueada', style: TextStyle(color: Colors.grey)),
          );
        },
      ),
    );
  }
}
