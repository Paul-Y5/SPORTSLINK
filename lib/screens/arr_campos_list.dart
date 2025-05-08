import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart'; // Import necessário para localização
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/models/ponto.dart';
import 'package:sports_link/screens/campo_details.dart';
import 'package:sports_link/controllers/user_provider.dart';
import 'package:sports_link/utils/abrir_mapa.dart';

class ArrCamposList extends StatefulWidget {
  const ArrCamposList({super.key});

  @override
  State<ArrCamposList> createState() => _ArrCamposListState();
}

class _ArrCamposListState extends State<ArrCamposList> {
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );

        setState(() {
          selectedLocation = LatLng(position.latitude, position.longitude);
        });
        return;
      }
    } catch (e) {
      debugPrint('Erro ao obter localização: $e');
    }

    // Localização padrão caso não seja possível obter a localização atual
    setState(() {
      selectedLocation = LatLng(40.6405, -8.6538); // Exemplo: Aveiro, Portugal
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obter o utilizador atual do Provider
    final currentUser = Provider.of<UserProvider>(context).user;

    // Verificar se o utilizador é um arrendador
    if (currentUser is! Arrendador) {
      return Scaffold(
        appBar: AppBar(title: const Text('Meus Campos')),
        body: const Center(
          child: Text('Apenas arrendadores podem acessar esta página.'),
        ),
      );
    }

    // Filtrar os campos associados ao arrendador
    final List<CampoPriv> camposAssociados = currentUser.camposPrivados;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Campos'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final nomeController = TextEditingController();
              final precoController = TextEditingController();
              final larguraController = TextEditingController();
              final comprimentoController = TextEditingController();
              final descricaoController = TextEditingController();

              final Map<String, bool> diasSelecionados = {
                'Segunda': false,
                'Terça': false,
                'Quarta': false,
                'Quinta': false,
                'Sexta': false,
                'Sábado': false,
                'Domingo': false,
              };

              final Map<String, List<TimeOfDay>> horarios = {};
              Ponto? pontoSelecionado;

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: const Text('Adicionar Campo Privado'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: nomeController,
                                decoration: InputDecoration(
                                  labelText: 'Nome do Campo',
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.orange,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                style: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: precoController,
                                decoration: InputDecoration(
                                  labelText: 'Preço por Hora (€)',
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.orange,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                style: const TextStyle(color: Colors.black),
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: larguraController,
                                decoration: InputDecoration(
                                  labelText: 'Largura (m)',
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.orange,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                style: const TextStyle(color: Colors.black),
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: comprimentoController,
                                decoration: InputDecoration(
                                  labelText: 'Comprimento (m)',
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.orange,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                style: const TextStyle(color: Colors.black),
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: descricaoController,
                                decoration: InputDecoration(
                                  labelText: 'Descrição do Campo',
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.orange,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                style: const TextStyle(color: Colors.black),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Localização:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  final ponto = await Navigator.push<LatLng>(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => SelecionarLocalizacaoMapa(
                                            initialLocation:
                                                selectedLocation ??
                                                LatLng(0.0, 0.0),
                                          ),
                                    ),
                                  );
                                  if (ponto != null) {
                                    setState(() {
                                      pontoSelecionado = Ponto(id: DateTime.timestamp().millisecondsSinceEpoch, idMapa: 0, latitude: selectedLocation!.latitude, longitude: selectedLocation!.longitude);
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                ),
                                label: Text(
                                  pontoSelecionado != null
                                      ? 'Selecionado: ${pontoSelecionado!.latitude.toStringAsFixed(4)}, ${pontoSelecionado!.longitude.toStringAsFixed(4)}'
                                      : 'Selecionar Localização',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Dias de Funcionamento:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Column(
                                children:
                                    diasSelecionados.entries.map((entry) {
                                      final dia = entry.key;
                                      final ativo = entry.value;
                                      return Column(
                                        crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                        children: [
                                          CheckboxListTile(
                                            title: Text(dia),
                                            value: ativo,
                                            activeColor:
                                                Colors
                                                    .orange,
                                            checkColor:
                                                const Color.fromARGB(255, 0, 0, 0),
                                            onChanged: (bool? value) {
                                              setState(() {
                                                diasSelecionados[dia] = value!;
                                                if (value) {
                                                  horarios[dia] = [
                                                    const TimeOfDay(
                                                      hour: 9,
                                                      minute: 0,
                                                    ),
                                                    const TimeOfDay(
                                                      hour: 18,
                                                      minute: 0,
                                                    ),
                                                  ];
                                                } else {
                                                  horarios.remove(dia);
                                                }
                                              });
                                            },
                                          ),
                                          if (ativo)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      final novaHora =
                                                          await showTimePicker(
                                                            context: context,
                                                            initialEntryMode: TimePickerEntryMode.input,
                                                            initialTime: horarios[dia]![0],
                                                            builder: (BuildContext context, Widget? child) {
                                                              return Theme(
                                                                data: Theme.of(context).copyWith(
                                                                  timePickerTheme: TimePickerThemeData(
                                                                    backgroundColor: Colors.white,
                                                                    dialHandColor: Colors.orange,
                                                                    hourMinuteTextColor: Colors.black,
                                                                    entryModeIconColor: Colors.orange,
                                                                    dayPeriodTextColor: Colors.orange,
                                                                  ),
                                                                  colorScheme: const ColorScheme.light(
                                                                    primary: Colors.orange, // cor do botão "OK"
                                                                    onSurface: Colors.black, // cor do texto
                                                                  ),
                                                                ), child: child!,
                                                                );
                                                              },
                                                            );
                                                      if (novaHora != null) {
                                                        setState(() {
                                                          horarios[dia]![0] =
                                                              novaHora;
                                                        });
                                                      }
                                                    },
                                                    child: Text(
                                                      'Início: ${horarios[dia]![0].format(context)}',
                                                      style: const TextStyle(
                                                        color: Colors.orange,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      final novaHora =
                                                          await showTimePicker(
                                                        context: context,
                                                        initialEntryMode:
                                                            TimePickerEntryMode
                                                                .input,
                                                        initialTime:
                                                            horarios[dia]![0],
                                                        builder: (
                                                          BuildContext context,
                                                          Widget? child,
                                                        ) {
                                                          return Theme(
                                                            data: Theme.of(
                                                              context,
                                                            ).copyWith(
                                                              timePickerTheme: TimePickerThemeData(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                dialHandColor:
                                                                    Colors
                                                                        .orange,
                                                                hourMinuteTextColor:
                                                                    Colors
                                                                        .black,
                                                                entryModeIconColor:
                                                                    Colors
                                                                        .orange,
                                                                dayPeriodTextColor:
                                                                    Colors
                                                                        .orange,
                                                              ),
                                                              colorScheme:
                                                                  const ColorScheme.light(
                                                                    primary:
                                                                        Colors
                                                                            .orange, // cor do botão "OK"
                                                                    onSurface:
                                                                        Colors
                                                                            .black, // cor do texto
                                                                  ),
                                                            ),
                                                            child: child!,
                                                          );
                                                        },
                                                      );
                                                      if (novaHora != null) {
                                                        setState(() {
                                                          horarios[dia]![1] =
                                                              novaHora;
                                                        });
                                                      }
                                                    },
                                                    child: Text(
                                                      'Fim: ${horarios[dia]![1].format(context)}',
                                                      style: const TextStyle(
                                                        color: Colors.orange,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      );
                                    }).toList(),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final nome = nomeController.text.trim();
                              final preco = double.tryParse(
                                precoController.text,
                              );
                              final largura = double.tryParse(
                                larguraController.text,
                              );
                              final comprimento = double.tryParse(
                                comprimentoController.text,
                              );
                              final descricao = descricaoController.text.trim();

                              if (nome.isEmpty ||
                                  preco == null ||
                                  largura == null ||
                                  comprimento == null ||
                                  pontoSelecionado == null ||
                                  horarios.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Por favor, preencha todos os campos corretamente.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final id = DateTime.now().millisecondsSinceEpoch;
                              final ponto = Ponto(
                                latitude: pontoSelecionado!.latitude,
                                longitude: pontoSelecionado!.longitude,
                                id: id,
                                idMapa: 0,
                              );

                              final novoCampo = CampoPriv(
                                id: id,
                                nome: nome,
                                preco: preco,
                                largura: largura,
                                comprimento: comprimento,
                                imagem: 'assets/default_field.png',
                                diasFuncionamento: Map.from(horarios),
                                descricao: descricao,
                                idArrendador:
                                    Provider.of<UserProvider>(
                                      context,
                                      listen: false,
                                    ).user!.id,
                                ponto: ponto,
                                idPonto: ponto.id,
                                idMapa: 0,
                                ocupado: false,
                              );

                              final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false,
                              );
                              if (userProvider.user is Arrendador) {
                                (userProvider.user as Arrendador).camposPrivados
                                    .add(novoCampo);
                              }

                              mockCampos.add(novoCampo);

                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Campo adicionado com sucesso!',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: const Text(
                              'Adicionar',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body:
          camposAssociados.isEmpty
              ? const Center(
                child: Text(
                  'Nenhum campo associado.',
                  style: TextStyle(fontSize: 16),
                ),
              )
              : ListView.builder(
                itemCount: camposAssociados.length,
                itemBuilder: (context, index) {
                  final campo = camposAssociados[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        campo.nome,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Preço: ${campo.preco.toStringAsFixed(2)}€/h\n'
                        'Dimensões: ${campo.comprimento}m x ${campo.largura}m',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.info, color: Colors.blue),
                            onPressed: () {
                              // Navegar para a página de detalhes do campo
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CampoDetails(campo: campo),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {
                              // Abrir o popup para editar o campo
                              _showEditCampoDialog(context, campo);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }

  void _showEditCampoDialog(BuildContext context, CampoPriv campo) {
    final TextEditingController nomeController = TextEditingController(
      text: campo.nome,
    );
    final TextEditingController precoController = TextEditingController(
      text: campo.preco.toStringAsFixed(2),
    );
    final Map<String, List<TimeOfDay>> horarios = Map.from(
      campo.diasFuncionamento,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editar Campo'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Campo',
                        labelStyle: TextStyle(color:Color.fromARGB(255, 0, 0, 0)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: precoController,
                      decoration: const InputDecoration(
                        labelText: 'Preço por Hora (€)',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Horários de Funcionamento:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...horarios.entries.map((entry) {
                      final String dia = entry.key;
                      final List<TimeOfDay> horas = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dia,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () async {
                                  final novaHora = await showTimePicker(
                                    context: context,
                                    initialTime: horas[0],
                                  );
                                  if (novaHora != null) {
                                    setState(() {
                                      horarios[dia]![0] = novaHora;
                                    });
                                  }
                                },
                                child: Text(
                                  'Início: ${horas[0].format(context)}',
                                  style: const TextStyle(color: Colors.orange),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final novaHora = await showTimePicker(
                                    context: context,
                                    initialTime: horas[1],
                                  );
                                  if (novaHora != null) {
                                    setState(() {
                                      horarios[dia]![1] = novaHora;
                                    });
                                  }
                                },
                                child: Text(
                                  'Fim: ${horas[1].format(context)}',
                                  style: const TextStyle(color: Colors.orange),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Salvar alterações
                    campo.nome = nomeController.text;
                    campo.preco =
                        double.tryParse(precoController.text) ?? campo.preco;
                    campo.diasFuncionamento = horarios;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Alterações salvas com sucesso!'),
                      ),
                    );

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
