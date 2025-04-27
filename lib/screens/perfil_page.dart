import 'package:flutter/material.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/styles/custom_appbar.dart';
import 'package:sports_link/widgets/notification_dropdown.dart'
    as notification_dropdown;

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final GlobalKey notificationButtonKey = GlobalKey();
  bool isDropdownOpen = false;
  int notificationCount = 3;

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
              notificationCount: notificationCount,
              onNotificationPressed: _showNotificationDropdown,
              onMenuPressed: _toggleDropdownOverlay,
            ),
            body: Column(
              children: [
                const SizedBox(height: 40), // Reduzido espaço aqui!
                _buildProfileHeader(),
                const SizedBox(height: 10),
                const Text(
                  'Utilizador',
                  style: TextStyle(
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
                debugPrint('Editar foto de perfil');
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _InfoCard(value: '12', label: 'Jogos'),
          _InfoCard(value: '10', label: 'Amigos'),
          _InfoCard(value: '9.9', label: 'Rating'),
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
              children: const [
                _DetailText(title: 'Idade', value: '22 anos'),
                SizedBox(height: 6),
                _DetailText(title: 'Peso', value: '80 Kg'),
                SizedBox(height: 6),
                _DetailText(title: 'Altura', value: '1.82 m'),
                SizedBox(height: 6),
                _DetailText(
                  title: 'Desporto(s) Favorito(s)',
                  value: 'Basquetebol',
                ),
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
            child: const Text(
              'Jogador experiente com paixão por esportes. Sempre pronto para um desafio!',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(height: 24),
          _OrangeButton(
            icon: Icons.history,
            label: 'Histórico Partidas',
            onPressed: () {
              // TODO
            },
          ),
          const SizedBox(height: 12),
          _OrangeButton(
            icon: Icons.adjust_sharp,
            label: 'Conquistas',
            onPressed: () {
              // TODO
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

  // Controle de Dropdowns
  void _toggleDropdownOverlay(
    BuildContext context,
    List<PopupMenuEntry<String>> items,
  ) {
    setState(() => isDropdownOpen = true);
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(0, 80, 0, 0),
      items: items,
    ).then((_) => setState(() => isDropdownOpen = false));
  }

  void _showNotificationDropdown(BuildContext context) {
    notification_dropdown.showNotificationDropdown(
      context: context,
      notificationButtonKey: notificationButtonKey,
      onClose: () => setState(() => isDropdownOpen = false),
    );
  }
}

// --- Widgets auxiliares (mantidos!)

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
