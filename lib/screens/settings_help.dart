import 'package:flutter/material.dart';

class SettingsHelpPage extends StatelessWidget {
  const SettingsHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Definições e Ajuda'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de Definições do Utilizador
            const Text(
              'Definições do Utilizador',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.orange),
              title: const Text('Editar Perfil'),
              subtitle: const Text('Atualize as suas informações pessoais'),
              onTap: () {
                // Navegar para a página de edição de perfil
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.orange),
              title: const Text('Alterar Palavra-Passe'),
              subtitle: const Text('Atualize a sua palavra-passe'),
              onTap: () {
                // Navegar para a página de alteração de palavra-passe
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.orange),
              title: const Text('Notificações'),
              subtitle: const Text('Gerencie as suas preferências de notificações'),
              onTap: () {
                // Navegar para a página de configurações de notificações
              },
            ),
            const Divider(height: 30, thickness: 1),

            // Seção de Ajuda
            const Text(
              'Ajuda',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.orange),
              title: const Text('FAQ'),
              subtitle: const Text('Perguntas frequentes'),
              onTap: () {
                // Navegar para a página de FAQ
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_support, color: Colors.orange),
              title: const Text('Suporte'),
              subtitle: const Text('Entre em contacto com o suporte'),
              onTap: () {
                // Navegar para a página de suporte
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.orange),
              title: const Text('Sobre'),
              subtitle: const Text('Informações sobre o aplicativo'),
              onTap: () {
                // Navegar para a página "Sobre"
              },
            ),
            const Divider(height: 30, thickness: 1),

            // Seção de Logout
            const Text(
              'Conta',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Excluir Conta Permanentemente'),
              subtitle: const Text('Esta ação não pode ser desfeita'),
              onTap: () {
                // Lógica para logout
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Terminar Sessão'),
                      content: const Text('Tem a certeza de que deseja terminar a sessão?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Lógica para logout
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacementNamed('/login');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Terminar Sessão'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}