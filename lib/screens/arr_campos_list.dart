import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/screens/campo_details.dart';
import 'package:sports_link/controllers/user_provider.dart';

class ArrCamposList extends StatelessWidget {
  const ArrCamposList({super.key});

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
      ),
      body: camposAssociados.isEmpty
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
                                builder: (context) => CampoDetails(campo: campo),
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
    final TextEditingController nomeController =
        TextEditingController(text: campo.nome);
    final TextEditingController precoController =
        TextEditingController(text: campo.preco.toStringAsFixed(2));
    final Map<String, List<TimeOfDay>> horarios = Map.from(campo.diasFuncionamento);

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
                      decoration: const InputDecoration(labelText: 'Nome do Campo'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: precoController,
                      decoration: const InputDecoration(labelText: 'Preço por Hora (€)'),
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
                                child: Text('Início: ${horas[0].format(context)}'),
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
                                child: Text('Fim: ${horas[1].format(context)}'),
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
                    campo.preco = double.tryParse(precoController.text) ?? campo.preco;
                    campo.diasFuncionamento = horarios;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Alterações salvas com sucesso!')),
                    );

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
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
