import 'package:flutter/material.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/screens/campo_details.dart';

class CardCampo extends StatelessWidget {
  final Campo campo;

  const CardCampo({super.key, required this.campo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        title: Text(campo.nome),
        subtitle: const Text("Informações sobre o campo"),
        trailing: IconButton(
          icon: const Icon(Icons.location_on),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CampoDetails(campo: campo,)),
            );
          },
        ),
      ),
    );
  }
}
