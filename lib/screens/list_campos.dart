import 'package:flutter/material.dart';
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/data/my_user.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/utilizador.dart';
import 'package:sports_link/styles/custom_appbar.dart';
import 'package:sports_link/widgets/card_campo.dart';
import 'package:sports_link/widgets/notification_dropdown.dart' as notification_dropdown;

class ListCampos extends StatefulWidget {
  const ListCampos({super.key});

  @override
  State<ListCampos> createState() => _ListCamposState();
  
}

class _ListCamposState extends State<ListCampos> {
  late Utilizador currentUser;
  int notificationCount = 3;
  bool isDropdownOpen = false;
  final GlobalKey notificationButtonKey = GlobalKey();

  // Variáveis específicas da página
  final List<Campo> campos = mockCampos;
  List<String> filteredCampos = [];
  bool isMapView = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUser = getMyUser();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Fundo
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
              notificationButtonKey: notificationButtonKey,
              notificationCount: notificationCount,
              onNotificationPressed: (context) {
                _showNotificationDropdown(context);
              },
              onMenuPressed: (context, items) {
                _toggleDropdownOverlay(context, items);
              },
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return ListView.builder(
                  itemCount: campos.length,
                  itemBuilder: (context, index) {
                    //TODO: Implementar lógica para mostrar os campos filtrados
                    return CardCampo(campo: '');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //Lógica da página

  // Filtragem de campos
  void filterCampos(String query) {
    final filtered =
        campos
            .where((campo) => campo.getNome.toLowerCase().contains(query.toLowerCase()))
            .toList();
    setState(() {
      filteredCampos = filtered.cast<String>();
    });
  }

  // Método para abrir o menu suspenso
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

  // Método para mostrar o menu de notificações
  void _showNotificationDropdown(BuildContext context) {
    notification_dropdown.showNotificationDropdown(
      context: context,
      notificationButtonKey: notificationButtonKey,
      onClose: () {
        setState(() {
          isDropdownOpen = false;
        });
      },
    );
  }

}