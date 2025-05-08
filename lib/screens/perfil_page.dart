import 'package:flutter/material.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/desportos.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/models/utilizador.dart';
import 'package:sports_link/screens/historico_page.dart';
import 'package:sports_link/screens/pagina_conquistas.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/styles/custom_appbar.dart';
import 'package:sports_link/controllers/controller_dropdown.dart' as dpd;

class PerfilPage extends StatefulWidget {
  final Utilizador user;

  const PerfilPage({super.key, required this.user});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final GlobalKey notificationButtonKey = GlobalKey();
  bool isDropdownOpen = false;

  double progress = 0.0; // Progresso atual do nível

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Carouselbg(),
          if (isDropdownOpen)
            ModalBarrier(
              color: Colors.black45,
              dismissible: true,
              onDismiss: () => setState(() => isDropdownOpen = false),
            ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
              notificationButtonKey: notificationButtonKey,
              onNotificationPressed: (context) => dpd.showNotificationDropdown(context, notificationButtonKey, widget.user),
              onMenuPressed: dpd.toggleDropdownOverlay,
            ),
            body: Column(
              children: [
                const SizedBox(height: 40),
                _buildProfileHeader(),
                const SizedBox(height: 10),
                Text(
                  widget.user.nome, // Nome dinâmico
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoCards(),
                const SizedBox(height: 16),
                _buildLevelProgress(), // Adicionada a barra de progresso do nível
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
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 55,
            backgroundColor: Colors.black,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Color.fromARGB(186, 255, 255, 255),
              child: Icon(Icons.person, size: 80, color: Colors.black),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                //TODO
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange,
                ),
                child: const Icon(Icons.edit, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    final user = widget.user;
    int jogos = (user is Jogador) ? user.partidas.length : 0;
    int amigos = (user is Jogador) ? user.amigos.length : 0;
    double rating = (user is Jogador) ? user.mediaAvaliacoes : 0.0;

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

  Widget _buildLevelProgress() {
    final user = widget.user;
    if (user is Jogador) {
      return Column(
        children: [
          Text(
            'Nível: ${user.nivel.toInt()}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: user.nivel % 1, // Progresso entre 0.0 e 1.0
                backgroundColor: Colors.grey[300],
                color: Colors.orange,
                minHeight: 10,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Simula o aumento do progresso
                user.nivel += 0.4; // Incrementa o progresso
                if (user.nivel >= user.nivel.toInt() + 1) {
                  user.nivel = user.nivel.toInt() + 1.0; // Atualiza o nível
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Ganhar Progresso',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildProfileDetails() {
    final user = widget.user;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditableSectionTitle('Características'),
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
                if (user is Jogador) ...[
                  _DetailText(title: 'Idade', value: '${user.idade} anos'),
                  const SizedBox(height: 6),
                  _DetailText(
                    title: 'Peso',
                    value: '${user.peso.toStringAsFixed(1)} Kg',
                  ),
                  const SizedBox(height: 6),
                  _DetailText(
                    title: 'Altura',
                    value: '${user.altura.toStringAsFixed(2)} m',
                  ),
                  const SizedBox(height: 6),
                  _DetailText(
                    title: 'Desporto(s) Favorito(s)',
                    value: user.desportos.map((d) => d.nome).join(', '),
                  ),
                ],
                if (user is Arrendador) ...[
                  const SizedBox(height: 6),
                  _DetailText(
                    title: 'Número de Campos',
                    value: user.camposPrivados.length.toString(),
                  ),
                  const SizedBox(height: 6),
                  _DetailText(
                    title: 'Campos Associados',
                    value: user.camposPrivados
                        .map((campo) => campo.nome)
                        .join(', '),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildEditableSectionTitle('Descrição'),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(163, 0, 0, 0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              (user is Jogador) ? user.descricao : '',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(height: 24),
          _OrangeButton(
            icon: Icons.history,
            label: 'Histórico Partidas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoricoPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _OrangeButton(
            icon: Icons.adjust_sharp,
            label: 'Conquistas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaginaConquistas(conquistas: []),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEditableSectionTitle(String title) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const Icon(Icons.edit, color: Colors.orange),
      ],
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

class _OrangeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _OrangeButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black, size: 28),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
