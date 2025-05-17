import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/controllers/user_provider.dart';
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/screens/arr_campos_list.dart';
import 'package:sports_link/screens/home_page.dart';
import 'package:sports_link/screens/list_amigos_page.dart';
import 'package:sports_link/screens/main_page_1.dart';
import 'package:sports_link/screens/partidas_jogador.dart';
import 'package:sports_link/screens/perfil_page.dart';
import 'package:sports_link/screens/settings_help.dart';

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
            if (user is Jogador && user is! Arrendador) ...[
              _buildMenuItem(
                'Ser Arrendador',
                Icons.sports_soccer,
                'Ser Arrendador',
                onTap: () {
                  showArrendadorFormPopup(context, user);
                },
              ),
            ],
            _buildMenuItem('Amigos', Icons.group, 'Amigos', onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ListAmigosPage()),
              );
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
                'Gerir Campos',
                Icons.sports_baseball,
                'Gerir Campos',
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SettingsHelpPage()),
              );
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

void showArrendadorFormPopup(BuildContext context, Jogador user) {
  final formKey = GlobalKey<FormState>();
  final ibanController = TextEditingController();
  bool termosAceites = false;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 251, 251, 251),
            title: const Text(
              'Tornar-se Arrendador',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: ibanController,
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    decoration: const InputDecoration(
                      labelText: 'IBAN',
                      labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira o IBAN';
                      }
                      if (value.length < 15 || value.length > 34) {
                        return 'IBAN inválido';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: termosAceites,
                        activeColor: Colors.orange,
                        checkColor: Colors.black,
                        onChanged: (val) {
                          setState(() {
                            termosAceites = val ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Aceito os termos e condições',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: termosAceites
                    ? () {
                        if (formKey.currentState!.validate()) {
                          final jogador = user;
                          final novoArrendador = Arrendador(
                            id: jogador.id,
                            nivel: jogador.nivel.toDouble(),
                            nome: jogador.nome,
                            email: jogador.email,
                            iban: ibanController.text,
                            noCampos: 0,
                            numTele: jogador.numTele,
                            password: jogador.password,
                            nacionalidade: jogador.nacionalidade,
                            idade: jogador.idade,
                            descricao: jogador.descricao,
                            utilizador: jogador.utilizador,
                            createDate: jogador.createDate,
                            isOnline: jogador.isOnline,
                            isInPartida: jogador.isInPartida,
                          )..setAltura(jogador.altura)
                          ..setPeso(jogador.peso)
                          ..setDesportos(List.from(jogador.desportos))
                          ..setAvaliacoes(List.from(jogador.avaliacoes))
                          ..adicionarMetodoPagamento('Transferência Bancária', ibanController.text)
                          ..setNumAvaliacoes(jogador.numAvaliacoes);
                           
                          mockUsers[user.id] = novoArrendador;

                          // Atualiza o provider para refletir o novo tipo de utilizador
                          Provider.of<UserProvider>(context, listen: false).setUser(novoArrendador);

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Agora és um arrendador!', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                              backgroundColor: Color.fromARGB(255, 0, 255, 0),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainPage1(id: novoArrendador.id),
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text('Submeter'),
              ),
            ],
          );
        },
      );
    },
  );
}
