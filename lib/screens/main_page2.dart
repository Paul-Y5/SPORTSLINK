import 'package:flutter/material.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/styles/custom_appbar.dart';
import 'package:sports_link/widgets/menu_card.dart';

class MainPage2 extends StatefulWidget {
  const MainPage2({super.key});

  @override
  State<MainPage2> createState() => _MainPage2State();
}

class _MainPage2State extends State<MainPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Carouselbg(), // Fundo dinâmico
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
              notificationButtonKey: GlobalKey(),
              notificationCount: 0,
              onNotificationPressed: (context) {},
              onMenuPressed: (context, items) {},
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MenuCard(
                        icon: Icons.lock,
                        text: 'Reservar\nCampo Privado',
                        color: Colors.orange,
                        fullWidth: false,
                      ),
                      MenuCard(
                        icon: Icons.public,
                        text: 'Jogar em\nCampo Público',
                        color: Colors.blue,
                        fullWidth: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  MenuCard(
                    icon: Icons.arrow_back,
                    text: 'Voltar ao Menu',
                    color: Colors.green,
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}