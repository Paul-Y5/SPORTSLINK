import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/models/desportos.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/controllers/user_provider.dart';
import 'package:sports_link/styles/carouselbg.dart';

class ListAmigosPage extends StatefulWidget {
  const ListAmigosPage({super.key});

  @override
  State<ListAmigosPage> createState() => _ListAmigosPageState();
}

class _ListAmigosPageState extends State<ListAmigosPage> {
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
    // Obter o usuário atual e a lista de amigos
    final currentUser = Provider.of<UserProvider>(context).user as Jogador;
    final amigos = currentUser.amigos;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Carousel no fundo
          const Carouselbg(),
          // Conteúdo principal
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Lista de Amigos'),
              backgroundColor: Colors.orange[800],
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () {
                    _adicionarAmigo(context);
                  },
                ),
              ],
            ),
            body: amigos.isEmpty
                ? const Center(
                    child: Text(
                      'Você ainda não tem amigos.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
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
                              // Lógica para navegar para a página de perfil do amigo
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PerfilAmigoPage(amigo: amigo as Jogador),
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
    );
  }
}

class PerfilAmigoPage extends StatelessWidget {
  final Jogador amigo;

  const PerfilAmigoPage({super.key, required this.amigo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Carousel no fundo
          const Carouselbg(),
          // Conteúdo principal
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('Perfil de ${amigo.nome}'),
              backgroundColor: Colors.orange[800],
              elevation: 0,
            ),
            body: Column(
              children: [
                const SizedBox(height: 40),
                _buildProfileHeader(),
                const SizedBox(height: 10),
                Text(
                  amigo.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoCards(),
                const SizedBox(height: 16),
                Expanded(child: _buildProfileDetails()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: CircleAvatar(
        backgroundImage: AssetImage(amigo.urlIMG ?? 'assets/default_image.png'),
        radius: 55,
      ),
    );
  }

  Widget _buildInfoCards() {
    int jogos = amigo.partidas.length;
    int amigos = amigo.amigos.length;
    double rating = amigo.mediaAvaliacoes;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _InfoCard(value: jogos.toString(), label: 'Jogos'),
          _InfoCard(value: amigos.toString(), label: 'Amigos'),
          _InfoCard(value: rating.toStringAsFixed(1), label: 'Rating'),
        ],
      ),
    );
  }

  Widget _buildProfileDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Características'),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(160, 0, 0, 0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailText(title: 'Idade', value: '${amigo.idade} anos'),
                const SizedBox(height: 6),
                _DetailText(
                  title: 'Peso',
                  value: '${amigo.peso.toStringAsFixed(1)} Kg',
                ),
                const SizedBox(height: 6),
                _DetailText(
                  title: 'Altura',
                  value: '${amigo.altura.toStringAsFixed(2)} m',
                ),
                const SizedBox(height: 6),
                _DetailText(
                  title: 'Desporto(s) Favorito(s)',
                  value: amigo.desportos.map((d) => d.nome).join(', '),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('Descrição'),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(163, 0, 0, 0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              amigo.descricao,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String value;
  final String label;

  const _InfoCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class _DetailText extends StatelessWidget {
  final String title;
  final String value;

  const _DetailText({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$title: $value',
      style: const TextStyle(color: Colors.white, fontSize: 14),
    );
  }
}