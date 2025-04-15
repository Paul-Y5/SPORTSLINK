import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey notificationButtonKey;
  final int notificationCount;
  final Function(BuildContext) onNotificationPressed;
  final Function(BuildContext, List<PopupMenuEntry<String>>) onMenuPressed;

  const CustomAppBar({
    super.key,
    required this.notificationButtonKey,
    required this.notificationCount,
    required this.onNotificationPressed,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          onMenuPressed(
            context,
            [
              _buildMenuItem('home', Icons.home, 'Home'),
              _buildMenuItem('profile', Icons.person, 'Perfil'),
              _buildMenuItem('friends', Icons.group, 'Amigos'),
              _buildMenuItem('settings', Icons.settings, 'Settings & Help Center'),
            ],
          );
        },
        child: const Icon(Icons.menu, color: Colors.white),
      ),
      title: Image.asset(
        'img/SPORTSLINK.png',
        height: 30, // Altura do logotipo
        fit: BoxFit.contain, // Ajusta a imagem para evitar overflow
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              key: notificationButtonKey,
              icon: const Icon(Icons.notifications, color: Colors.orange),
              onPressed: () {
                onNotificationPressed(context);
              },
            ),
            if (notificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$notificationCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(String value, IconData icon, String text) {
    return PopupMenuItem(
      value: value,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(200, 0, 0, 0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}