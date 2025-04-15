import 'package:flutter/material.dart';
import 'package:sports_link/widgets/menu_card.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MenuCard(
                icon: Icons.sports_soccer,
                text: 'Criar\nPartida',
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MenuCard(
                icon: Icons.search,
                text: 'Encontrar\nPartida Aberta',
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        MenuCard(
          icon: Icons.add_location_alt,
          text: 'Adicionar Campo',
          color: Colors.green,
          fullWidth: true,
        ),
      ],
    );
  }
}