import 'package:flutter/material.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/utilizador.dart';
import 'package:sports_link/screens/arr_campos_list.dart';
import 'package:sports_link/screens/home_page.dart';
import 'package:sports_link/screens/main_page_1.dart';
import 'package:sports_link/screens/perfil_page.dart'; // Importa a MainPage1

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey notificationButtonKey;
  final Function(BuildContext) onNotificationPressed;
  final Function(BuildContext, List<PopupMenuEntry<String>>) onMenuPressed;

  final Utilizador user;

  const CustomAppBar({
    super.key,
    required this.notificationButtonKey,
    required this.onNotificationPressed,
    required this.onMenuPressed,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          onMenuPressed(context, [
            _buildMenuItem('Home', Icons.home, 'Home', onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainPage1(id: user.id,)),
              );
            }),
            _buildMenuItem('Perfil', Icons.person, 'Perfil', onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PerfilPage(user: user)),
              );
            }),
            _buildMenuItem('Amigos', Icons.group, 'Amigos'),
            _buildMenuItem('Partidas', Icons.sports_sharp, 'Partidas Jogadas'),
            if (user is Arrendador)
              _buildMenuItem('Meus Campos', Icons.account_balance_rounded, 'Meus Campos',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ArrCamposList()),
                    );
                  }),
            _buildMenuItem('Definições & Ajuda', Icons.settings, 'Definições & Ajuda'),
            _buildMenuItem('Sair', Icons.logout, 'Sair', onTap: () {
              // Adicione a lógica de logout aqui
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }),
          ]);
        },
        child: const Icon(Icons.menu, color: Colors.orange),
      ),
      title: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage1(id: user.id,)),
          );
        },
        child: Image.asset(
          'img/SPORTSLINK.png',
          height: 30,
          fit: BoxFit.contain,
        ),
      ),
      centerTitle: true,
      actions: [
        Stack(
          children: [
            IconButton(
              key: notificationButtonKey,
              icon: const Icon(Icons.notifications, color: Colors.orange),
              tooltip: 'Notificações',
              onPressed: () {
                onNotificationPressed(context);
              },
            ),
            if (user.notificacoes.isNotEmpty)
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
                    user.notificacoes.length > 20 ? '20+' : user.notificacoes.length.toString(),
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

  PopupMenuItem<String> _buildMenuItem(
    String value,
    IconData icon,
    String text, {
    VoidCallback? onTap,
  }) {
    return PopupMenuItem(
      value: value,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: const Color.fromARGB(200, 0, 0, 0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(icon, color: Colors.orange),
              const SizedBox(width: 8),
              Text(text, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
}
