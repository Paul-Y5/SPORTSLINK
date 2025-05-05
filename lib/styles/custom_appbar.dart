import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/controllers/user_provider.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/screens/arr_campos_list.dart';
import 'package:sports_link/screens/home_page.dart';
import 'package:sports_link/screens/main_page_1.dart';
import 'package:sports_link/screens/partidas_jogador.dart';
import 'package:sports_link/screens/perfil_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey notificationButtonKey;
  final Function(BuildContext) onNotificationPressed;
  final Function(BuildContext, List<PopupMenuEntry<String>>) onMenuPressed;

  const CustomAppBar({
    super.key,
    required this.notificationButtonKey,
    required this.onNotificationPressed,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          onMenuPressed(context, [
            _buildMenuItem('Home', Icons.home, 'Home', onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainPage1(id: user!.id)),
              );
            }),
            _buildMenuItem('Perfil', Icons.person, 'Perfil', onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PerfilPage(user: user!)),
              );
            }),
            _buildMenuItem('Amigos', Icons.group, 'Amigos', onTap: () {
              // lógica para abrir a página de amigos aqui
            }),
            if (user is Jogador) ...[
              _buildMenuItem(
                'Partidas',
                Icons.sports_sharp,
                'Partidas${user.partidas.isNotEmpty ? ' (${user.partidas.length})' : ''}',
                onTap: () {
                  debugPrint('Numero de partidas: ${user.partidas.length}');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ListaPartidasPage()),
                  );
                },
              ),
            ],
            if (user is Arrendador) ...[
              _buildMenuItem(
                'Campos',
                Icons.sports_baseball,
                'Campos${user.camposPrivados.isNotEmpty ? ' (${user.camposPrivados.length})' : ''}',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ArrCamposList()),
                  );
                },
              ),
            ],

            _buildMenuItem('Definições & Ajuda', Icons.settings, 'Definições & Ajuda', onTap: () {
              // Adicione a lógica para abrir as definições e ajuda aqui
            }),
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
            MaterialPageRoute(builder: (context) => MainPage1(id: user!.id)),
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
            if (user!.notificacoes.isNotEmpty)
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
