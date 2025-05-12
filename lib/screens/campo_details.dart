import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/controllers/controller_dropdown.dart' as dpd;
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/controllers/user_provider.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/models/campo_pub.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/screens/page_reserva.dart';
import 'package:sports_link/screens/partida_owner.dart';
import 'package:sports_link/screens/partida_page.dart';
import 'package:sports_link/screens/perfil_page.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/styles/custom_appbar.dart';
import 'package:sports_link/widgets/menu_card.dart';
import 'package:intl/intl.dart';
import 'package:sports_link/widgets/style_row.dart';

class CampoDetails extends StatefulWidget {
  final Campo campo;

  const CampoDetails({super.key, required this.campo});

  @override
  State<CampoDetails> createState() => _CampoDetailsState();
}

class _CampoDetailsState extends State<CampoDetails> {
  bool isDropdownOpen = false; // Variável para controlar o estado do dropdown
  final GlobalKey notificationButtonKey = GlobalKey(); // Chave para o botão de notificações

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            const Carouselbg(),
            if (isDropdownOpen)
              const ModalBarrier(
                color: Color.fromARGB(128, 0, 0, 0),
                dismissible: false,
              ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: CustomAppBar(
                notificationButtonKey: notificationButtonKey,
                onNotificationPressed: (context) {
                  dpd.showNotificationDropdown(context, notificationButtonKey, currentUser!);
                },
                onMenuPressed: (context, items) {
                  setState(() {
                    isDropdownOpen = !isDropdownOpen;
                  });
                  dpd.toggleDropdownOverlay(context, items);
                },
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Nome do campo
                      Center(
                        child: Text(
                          widget.campo.nome,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Imagem do campo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          widget.campo.imagem,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.broken_image,
                              size: 100,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Botão para abrir o mapa
                      MenuCard(
                        icon: Icons.location_on,
                        text: 'Localização',
                        color: Colors.orange,
                        fullWidth: true,
                        onPressed: _openMap,
                      ),
                      const SizedBox(height: 10),

                      // Informações do campo
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Informações',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange, // Título em laranja
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Exibe informações dependendo do tipo de campo
                            if (widget.campo is CampoPriv) ...[
                              // Campo Privado
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: Colors.orange[50],
                                
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.person, // Ícone de pessoa
                                    color: Colors.orange, // Cor laranja para combinar com o tema
                                    size: 28,
                                  ),
                                  title: const Text(
                                    'Responsável',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    _getNomeArrendador(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios, // Ícone de seta para indicar navegação
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                  onTap: _openArrendadorProfile, // Navegar para o perfil do arrendador
                                ),
                              ),
                              const SizedBox(height: 8),
                              buildInfoRow('Preço', '${(widget.campo as CampoPriv).preco.toStringAsFixed(2)}€/h'),
                              const SizedBox(height: 8),
                              buildInfoRow('Métodos de Pagamento', _getMetodosPagamento()),
                              const SizedBox(height: 8),
                              buildInfoRow('Horários', _getHorariosFuncionamento()),
                              if (widget.campo.desportos.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                buildInfoRow('Desportos Associados', widget.campo.desportos.join(', ')),
                              ],
                              const SizedBox(height: 20),
                              if (widget.campo is CampoPriv &&
                                  currentUser!.id !=
                                      (widget.campo as CampoPriv)
                                          .idArrendador) ...[
                              ElevatedButton(
                                onPressed: _scheduleReservation,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                  child: const Center(
                                    child: Text(
                                      'Agendar Reserva',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                            if (widget.campo is CampoPub) ...[
                              _buildInformacoesCampoPub(widget.campo as CampoPub),
                            ],
                            if (widget.campo is CampoPriv &&
                                (widget.campo as CampoPriv).idArrendador == currentUser?.id) ...[
                              const SizedBox(height: 20),
                              const Text(
                                'Reservas Agendadas:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if ((widget.campo as CampoPriv).reservas.isNotEmpty)
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: (widget.campo as CampoPriv).reservas.length,
                                  itemBuilder: (context, index) {
                                    final data = (widget.campo as CampoPriv).reservas.keys.elementAt(index);
                                    final reservas = (widget.campo as CampoPriv).reservas[data]!;

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Data: ${DateFormat('dd/MM/yyyy').format(data)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ...reservas.map((reserva) {
                                          return Container(
                                            margin: const EdgeInsets.symmetric(vertical: 8),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(100, 255, 255, 255),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Cliente: ${_getNomeCliente(reserva.idCliente)}',
                                                  style: const TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  'Hora de Início: ${reserva.horaInicio}',
                                                  style: const TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  'Duração: ${reserva.tempoDuracao} horas',
                                                  style: const TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  'Estado: ${reserva.estado}',
                                                  style: const TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  'Método de Pagamento: ${reserva.pagamento}',
                                                  style: const TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ],
                                    );
                                  },
                                )
                              else
                                const Text(
                                  'Nenhuma reserva encontrada.',
                                  style: TextStyle(fontSize: 16, color: Colors.black54),
                                ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getNomeArrendador() {
    if (widget.campo is CampoPriv) {
      final idArrendador = (widget.campo as CampoPriv).idArrendador;
      for (var arrendador in mockUsers.values) {
        if (arrendador.id == idArrendador) {
          return arrendador.nome;
        }
      }
    }
    return 'Entidade Pública';
  }

  String _getMetodosPagamento() {
    if (widget.campo is CampoPriv) {
      final idArrendador = (widget.campo as CampoPriv).idArrendador;
      for (var arrendador in mockUsers.values) {
        arrendador as Arrendador;
        if (arrendador.id == idArrendador) {
          return arrendador.metodosPagamento.values.join(', ');
        }
      }
    }
    return '';
  }

  String _getHorariosFuncionamento() {
    if (widget.campo is CampoPriv) {
      final campoPriv = widget.campo as CampoPriv;
      return campoPriv.diasFuncionamento.entries
          .map(
            (entry) =>
                '${entry.key}: ${entry.value[0].format(context)} - ${entry.value[1].format(context)}',
          )
          .join(', ');
    }
    return 'Horário não disponível';
  }

  void _openMap() async {
    final userPosition = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    final startPoint = LatLng(userPosition.latitude, userPosition.longitude);
    final endPoint = LatLng(
      widget.campo.ponto.latitude,
      widget.campo.ponto.longitude,
    );

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Center(
            child: Text(
              "Localização do Campo",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: SizedBox(
            height: 300,
            width: 300,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: endPoint,
                minZoom: 13.0,
                maxZoom: 20.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: startPoint,
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                    Marker(
                      point: endPoint,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.orange,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [startPoint, endPoint],
                      strokeWidth: 4.0,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _scheduleReservation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                PageReserva(campo: widget.campo as CampoPriv, user: Provider.of<UserProvider>(context).user as Jogador),
      ),
    );
  }

  void _openArrendadorProfile() {
    if (widget.campo is CampoPriv) {
      final idArrendador = (widget.campo as CampoPriv).idArrendador;
      final arrendador =
          mockUsers.values.firstWhere((a) => a.id == idArrendador)
              as Arrendador;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PerfilPage(user: arrendador)),
      );
    }
  }

  void _showStartMatchPopup() {
  final TextEditingController maxJogadoresController = TextEditingController();
  final TextEditingController minJogadoresController = TextEditingController();
  final TextEditingController duracaoController = TextEditingController();
  final bool checked = false;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Configurar Partida',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.orange, // Título em laranja
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Número Mínimo de Jogadores (opcional):',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black, // Texto preto
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: minJogadoresController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Ex: 4',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              const Text(
                'Número máximo de Jogadores (opcional):',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black, // Texto preto
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: maxJogadoresController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Ex: 10',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Duração da Partida (opcional):',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black, // Texto preto
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: duracaoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Ex: 60 minutos',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 8),
              // Checkbox para marcar resultado
              Row(
                children: [
                  Checkbox(
                    value: checked,
                    onChanged: (value) {},
                    activeColor: Colors.orange,
                  ),
                  const Text(
                    'Marcar resultado da partida',
                    style: TextStyle(
                      color: Colors.black, // Texto preto
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.orange, // Botão laranja
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (maxJogadoresController.text.isEmpty) {
                maxJogadoresController.text = '0';
              } 
              if (minJogadoresController.text.isEmpty) {
                minJogadoresController.text = '0';
              } 
              if (duracaoController.text.isEmpty) {
                duracaoController.text = '0';
              }

              // Confirmar informações e redirecionar para a página da partida
              Navigator.of(context).pop();
              _startMatch(
                widget.campo as CampoPub, // Usa o campo atual
                int.parse(maxJogadoresController.text),
                int.parse(minJogadoresController.text),
                double.parse(duracaoController.text),
                checked,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Botão laranja
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Confirmar',
              style: TextStyle(
                color: Colors.black, // Texto preto
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}

  void _startMatch(CampoPub campoSelecionado, int maxJogadores, int minJogadores, double duracaoController, bool checked) {
  setState(() {
    String resultado = ''; // Definir resultado padrão
    if (checked) {
      resultado = '0-0';
    }
    campoSelecionado.ocupado = true; // Atualizar o estado do campo para ocupado
    campoSelecionado.partidaEmCurso = true; // Atualizar o estado da partida
    campoSelecionado.partida = Partida(
      id: DateTime.now().millisecondsSinceEpoch,
      resultado: resultado,
      campo: campoSelecionado,
      duracao: duracaoController,
      data: DateTime.now(),
      hora: TimeOfDay.now(),
      estado: EstadoPartida.aguardando,
      jogadores: [Provider.of<UserProvider>(context, listen: false).user as Jogador],
      tipo: TipoPartida.publica,
      numeroJogadoresMaximo: maxJogadores,
      numeroJogadoresMinimo: minJogadores,
    );
  });

  // Exibir mensagem de sucesso
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Partida iniciada no campo ${campoSelecionado.nome}!',
      ),
    ),
  );

  // Redirecionar para a página do proprietário da partida
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PartidaOwnerPage(
        partida: campoSelecionado.partida!,
      ),
    ),
  );
}

  String _getNomeCliente(int idCliente) {
    for (var user in mockUsers.values) {
      if (user.id == idCliente) {
        return user.nome;
      }
    }
    return 'Cliente desconhecido';
  }

  Widget _buildInformacoesCampoPub(CampoPub campoPub) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildInfoRow('Entidade Responsável', campoPub.entidadePublicaResp),
      const SizedBox(height: 8),
      buildInfoRow('Estado', campoPub.ocupado ? 'Ocupado' : 'Disponível'),
      if (campoPub.ocupado && campoPub.partida != null) ...[
        const SizedBox(height: 20),
        const Text(
          'Partida em andamento:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 8),
        buildInfoRow('Jogadores', _getJogadoresPartida(campoPub)),
        const SizedBox(height: 8),
        buildInfoRow('Hora de Início', _getHoraInicioPartida(campoPub)),
        const SizedBox(height: 8),
        buildInfoRow('Estado', _getEstadoPartida(campoPub)),
      ],
      const SizedBox(height: 20),
      _buildBotaoCampoPub(campoPub),
    ],
  );
}

  Widget _buildBotaoCampoPub(CampoPub campoPub) {
  final temPartida = campoPub.partida != null;
  final estadoAguardando = temPartida && campoPub.partida!.estado == EstadoPartida.aguardando;
  final estadoEmAndamento = temPartida && campoPub.partida!.estado == EstadoPartida.emAndamento;
  final jogadoresMaximosAtingidos = temPartida &&
      campoPub.partida!.jogadores != null &&
      campoPub.partida!.numeroJogadoresMaximo != null &&
      campoPub.partida!.jogadores!.length >= campoPub.partida!.numeroJogadoresMaximo!;

  return Center(
    child: SizedBox(
      width: double.infinity, // O botão ocupará toda a largura disponível
      child: ElevatedButton(
        onPressed: () {
          if (estadoAguardando || (estadoEmAndamento && !jogadoresMaximosAtingidos)) {
            // Redirecionar para a página da partida existente
            campoPub.partida!.jogadores!.add(Provider.of<UserProvider>(context, listen: false).user as Jogador);
            (Provider.of<UserProvider>(context, listen: false).user! as Jogador).partidas.add(campoPub.partida!);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PartidaPage(
                  partida: campoPub.partida!,
                ),
              ),
            );
          } else if (!temPartida) {
            // Abrir popup para configurar e iniciar uma nova partida
            _showStartMatchPopup();
          } else {
            // Exibir mensagem de erro se os jogadores máximos forem atingidos
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('O número máximo de jogadores foi atingido.'),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          estadoAguardando
              ? 'Entrar na Partida'
              : estadoEmAndamento && !jogadoresMaximosAtingidos
                  ? 'Entrar na Partida'
                  : !temPartida
                      ? 'Começar Partida'
                      : 'Partida Finalizada',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}

  String _getJogadoresPartida(CampoPub campoPub) {
  if (campoPub.partida != null && campoPub.partida!.jogadores != null) {
    return campoPub.partida!.jogadores!
        .map((jogador) => jogador.nome)
        .join(', ');
  }
  return 'Nenhum jogador presente';
}

String _getHoraInicioPartida(CampoPub campoPub) {
  if (campoPub.partida != null) {
    final hora = campoPub.partida!.hora;
    return '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';
  }
  return 'Hora não disponível';
}

String _getEstadoPartida(CampoPub campoPub) {
  if (campoPub.partida != null) {
    switch (campoPub.partida!.estado) {
      case EstadoPartida.aguardando:
        return 'Aguardando jogadores';
      case EstadoPartida.emAndamento:
        return 'Em andamento';
      case EstadoPartida.terminada:
        return 'Finalizada';
      case EstadoPartida.cancelada:
        return 'Cancelada';
      default:
        return 'Estado desconhecido';
    }
  }
  return 'Estado não disponível';
}
}
