import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/controllers/controller_dropdown.dart' as dpd;
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/controllers/user_provider.dart';
import 'package:sports_link/screens/perfil_page.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/styles/custom_appbar.dart';

class ListAmigosPage extends StatefulWidget {
  const ListAmigosPage({super.key});

  @override
  State<ListAmigosPage> createState() => _ListAmigosPageState();
}

class _ListAmigosPageState extends State<ListAmigosPage> {
  final GlobalKey notificationButtonKey = GlobalKey();

  void _adicionarAmigo(BuildContext context) {
    final TextEditingController idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Amigo'),
          content: TextField(
            controller: idController,
            cursorColor: const Color.fromARGB(255, 0, 0, 0),
            decoration: const InputDecoration(
              floatingLabelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              labelText: 'ID do Amigo',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.orange, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                final idText = idController.text;
                if (idText.isNotEmpty) {
                  final currentUser =
                      Provider.of<UserProvider>(context, listen: false).user as Jogador;

                  // Tenta converter para int
                  final int? idInt = int.tryParse(idText);

                  if (idInt == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ID inválido. Digite um número.')),
                    );
                    return;
                  }

                  // Busca o amigo
                  final novoAmigo = mockUsers.values.firstWhere(
                    (user) => user.id == idInt,
                    orElse: () => throw Exception('Amigo não encontrado'),
                  );

                  setState(() {
                    currentUser.amigos.add(novoAmigo);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Amigo com ID $idInt foi adicionado!'),
                    ),
                  );

                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Adicionar', 
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user as Jogador;
    final amigos = currentUser.amigos;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        notificationButtonKey: notificationButtonKey,
        onNotificationPressed: (context) {
         dpd.showNotificationDropdown(
            context,
            notificationButtonKey,
            currentUser,
          );
        },
        onMenuPressed: (context, items) {
          dpd.toggleDropdownOverlay(context, items);
        },
      ),
      body: Stack(
        children: [
          const Carouselbg(),
          Padding(
            padding: const EdgeInsets.only(top: 80), // espaço para a appbar custom
            child: amigos.isEmpty
                ? const Center(
                    child: Text(
                      'Ainda não tens amigos.',
                      style: TextStyle(fontSize: 16, color: Colors.orange),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: amigos.length,
                    itemBuilder: (context, index) {
                      final amigo = amigos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(
                                amigo.urlIMG ?? 'assets/default_image.png'),
                            radius: 25,
                          ),
                          title: Text(
                            amigo.nome,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text('Nível: ${amigo.id}'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PerfilPage(user: amigo as Jogador,),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Ver Perfil',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => _adicionarAmigo(context),
        child: const Icon(Icons.person_add, color: Colors.black),
      ),
    );
  }
}
