import 'package:flutter/material.dart';

class AddCampo extends StatefulWidget {
  const AddCampo({super.key});

  @override
  State<AddCampo> createState() => _AddCampoState();
}

class _AddCampoState extends State<AddCampo> {
  final TextEditingController campoNameController = TextEditingController();
  final TextEditingController campoLocationController = TextEditingController();
  final TextEditingController campoPriceController = TextEditingController();
  final TextEditingController campoDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Campo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: campoNameController,
              decoration: const InputDecoration(labelText: 'Nome do Campo'),
            ),
            TextField(
              controller: campoLocationController,
              decoration: const InputDecoration(labelText: 'Localização'),
            ),
            TextField(
              controller: campoPriceController,
              decoration: const InputDecoration(labelText: 'Preço'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: campoDescriptionController,
              decoration:
                  const InputDecoration(labelText: 'Descrição (opcional)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para adicionar o campo
                Navigator.pop(context);
              },
              child: const Text('Adicionar Campo'),
            ),
          ],
        ),
      ),
    );
  }
}