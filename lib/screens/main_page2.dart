import 'package:flutter/material.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/styles/custom_appbar.dart';
import 'package:sports_link/widgets/menu_card.dart';
import 'package:sports_link/widgets/notification_dropdown.dart' as notification_dropdown;
import 'package:sports_link/widgets/notification_item.dart' as notification_item;

class MainPage2 extends StatefulWidget {
  const MainPage2({super.key});

  @override
  State<MainPage2> createState() => _MainPage2State();
}

class _MainPage2State extends State<MainPage2> {
  final GlobalKey notificationButtonKey = GlobalKey();
  bool isDropdownOpen = false;

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
              notificationButtonKey: notificationButtonKey,
              notificationCount: 0,
              onNotificationPressed: (context) {
                _showNotificationDropdown(context);
              },
              onMenuPressed: (context, items) {
                _toggleDropdownOverlay(context, items);
              },
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

  void _toggleDropdownOverlay(BuildContext context, List<PopupMenuEntry<String>> items) {
    setState(() {
      isDropdownOpen = true;
    });

    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(0, 80, 0, 0),
      items: items,
    ).then((_) {
      setState(() {
        isDropdownOpen = false;
      });
    });
  }

  void _showNotificationDropdown(BuildContext context) {
    notification_dropdown.showNotificationDropdown(
      context: context,
      notificationButtonKey: notificationButtonKey,
      items: [
        _buildNotificationItem('Sem notificações'),
      ],
      onClose: () {
        setState(() {
          isDropdownOpen = false;
        });
      },
    );
  }

  PopupMenuItem<String> _buildNotificationItem(String text) {
    return PopupMenuItem(
      value: 'notification',
      child: notification_item.NotificationItem(text: text),
    );
  }
}