import 'package:flutter/material.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/screens/campo_details.dart';

class CardCampo extends StatefulWidget {
  final Campo campo;

  const CardCampo({super.key, required this.campo});

  @override
  State<CardCampo> createState() => _CardCampoState();
}

class _CardCampoState extends State<CardCampo> {
  bool _isHovered = false; // estado do hoover

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true; 
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false; 
        });
      },
      child: GestureDetector(
        onTap: () {
          // Redireciona para a página de detalhes ao clicar no card
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CampoDetails(campo: widget.campo),
            ),
          );
        },
        child: SizedBox(
          height: 120,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: _isHovered ? 8 : 4, 
            color: _isHovered ? Colors.orange[80] : Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: Image.asset(widget.campo.imagem).image,
                radius: 50,
              ),
              title: Text(
                widget.campo.nome,
                style: const TextStyle(fontSize: 20), 
              ),
              subtitle: const Text(
                "Informações sobre o campo",
                style: TextStyle(fontSize: 16), 
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: _isHovered ? Colors.orange : const Color.fromARGB(255, 0, 0, 0), // Altera a cor no hover
              ),
            ),
          ),
        ),
      ),
    );
  }
}
