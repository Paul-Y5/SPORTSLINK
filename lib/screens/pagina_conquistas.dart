import 'package:flutter/material.dart';
import 'package:sports_link/models/conquista.dart';

class PaginaConquistas extends StatelessWidget {
  final List<Conquista> conquistas;

  const PaginaConquistas({super.key, required this.conquistas});

  @override
  Widget build(BuildContext context) {
    if (conquistas.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Conquistas'),
          backgroundColor: Colors.orange,
        ),
        body: const Center(
          child: Text(
            'Nenhuma conquista disponível no momento.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conquistas'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Número de colunas
            crossAxisSpacing: 16, // Espaçamento horizontal
            mainAxisSpacing: 16, // Espaçamento vertical
            childAspectRatio: 3 / 4, // Proporção do card
          ),
          itemCount: conquistas.length,
          itemBuilder: (context, index) {
            final conquista = conquistas[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: conquista.desbloqueada ? Colors.green[50] : Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      conquista.desbloqueada ? Icons.emoji_events : Icons.lock,
                      size: 48,
                      color: conquista.desbloqueada ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      conquista.nome,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: conquista.desbloqueada ? Colors.green : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      conquista.descricao,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      conquista.desbloqueada ? 'Desbloqueada' : 'Bloqueada',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: conquista.desbloqueada ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
