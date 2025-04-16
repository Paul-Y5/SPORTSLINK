import 'package:flutter/material.dart';

class CampoDetails extends StatefulWidget {
  const CampoDetails({super.key});

  @override
  State<CampoDetails> createState() => _CampoDetailsState();
}

class _CampoDetailsState extends State<CampoDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Campo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Detalhes do Campo"),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Voltar"),
            ),
          ],
        ),
      ),
    );
  }
}