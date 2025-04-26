import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sports_link/models/campo_priv.dart';

class PageReserva extends StatefulWidget {
  final CampoPriv campo;

  const PageReserva({super.key, required this.campo});

  @override
  PageReservaState createState() => PageReservaState();
}

class PageReservaState extends State<PageReserva> {
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  // Função para formatar a data
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Função para exibir o calendário de escolha de data
  void _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025, 12, 31),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        selectedStartTime = null; // Reset hora ao mudar a data
        selectedEndTime = null;
      });
    }
  }

  // Função para exibir a lista de horários disponíveis no dia escolhido
  void _showAvailableTimes(BuildContext context) {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma data primeiro.')),
      );
      return;
    }

    // Obtém o dia da semana em formato textual (e.g., "Monday")
    final String dayOfWeek = DateFormat('EEEE', 'pt_PT').format(selectedDate!);

    // Busca os horários disponíveis no mapa `diasFuncionamento`
    final availableTimes = widget.campo.diasFuncionamento[dayOfWeek] as List<List<TimeOfDay>>?;

    if (availableTimes == null || availableTimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não há horários disponíveis para este dia.')),
      );
      return;
    }

    // Exibe os horários disponíveis em um diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolher horário'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: availableTimes.map((timeRange) {
              return ListTile(
                title: Text('${timeRange[0].format(context)} - ${timeRange[1].format(context)}'),
                onTap: () {
                  setState(() {
                    selectedStartTime = timeRange[0];
                    selectedEndTime = timeRange[1];
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar Reserva - ${widget.campo.nome}'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Agendar para o campo: ${widget.campo.nome}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Seleção de Data
            Row(
              children: [
                Text(
                  selectedDate == null
                      ? 'Escolha a data'
                      : DateFormat('yyyy-MM-dd').format(selectedDate!),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _showDatePicker(context),
                  child: const Text('Escolher data'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Seleção de Hora
            Row(
              children: [
                Text(
                  selectedStartTime == null
                      ? 'Escolha a hora de início'
                      : selectedStartTime!.format(context),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _showAvailableTimes(context),
                  child: const Text('Escolher horário'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Confirmar Reserva
            ElevatedButton(
              onPressed: () {
                if (selectedDate != null && selectedStartTime != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Reserva confirmada para ${widget.campo.nome} em ${formatDate(selectedDate!)} às ${selectedStartTime!.format(context)}',
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, complete todos os campos'),
                    ),
                  );
                }
              },
              child: const Text('Confirmar Reserva'),
            ),
          ],
        ),
      ),
    );
  }
}
