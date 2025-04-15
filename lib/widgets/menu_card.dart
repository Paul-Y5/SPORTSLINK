import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final bool fullWidth;
  final VoidCallback? onPressed; // Adicionado o callback onPressed

  const MenuCard({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    this.fullWidth = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Chama o callback quando o card é pressionado
      child: Container(
        width: fullWidth ? double.infinity : 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(128, 0, 0, 0), // Fundo com transparência
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}