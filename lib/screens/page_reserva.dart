import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sports_link/data/my_user.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/styles/custom_appbar.dart';
import 'package:sports_link/controllers/controller_dropdown.dart' as dpd;

class PageReserva extends StatefulWidget {
  final CampoPriv campo;

  const PageReserva({super.key, required this.campo});

  @override
  PageReservaState createState() => PageReservaState();
}

class PageReservaState extends State<PageReserva> {
  DateTime today = DateTime.now();
  DateTime focusedDay = DateTime.now();
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  final GlobalKey notificationButtonKey = GlobalKey();
  bool isDropdownOpen = false;
  int notificationCount = 0;

  @override
  void initState() {
    super.initState();
    // Inicializando a formatação de data para o português
    initializeDateFormatting('pt_PT', null)
        .then((_) {
          setState(() {}); // Atualizar o estado após a inicialização
        })
        .catchError((e) {
          debugPrint('Erro ao inicializar a formatação de data: $e');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Carouselbg(), // Fundo dinâmico
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
              notificationButtonKey: notificationButtonKey,
              onNotificationPressed: (context) {
                dpd.showNotificationDropdown(context, notificationButtonKey);
              },
              onMenuPressed: (context, items) {
                dpd.toggleDropdownOverlay(context, items);
              }, user: getMyUser(1), // Adicione o usuário atual aqui
            ),
            body: SingleChildScrollView(
              // Adicionado para evitar overflow
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Agendar para o campo: ${widget.campo.nome}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Calendário com fundo
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(165, 255, 255, 255),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.utc(2025, 12, 31),
                        focusedDay: focusedDay,
                        calendarFormat: CalendarFormat.month,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        selectedDayPredicate: (day) {
                          return isSameDay(today, day);
                        },
                        onDaySelected: (selectedDay, focusedDayUpdate) {
                          setState(() {
                            today = selectedDay;
                            focusedDay = focusedDayUpdate;
                            selectedStartTime = null;
                            selectedEndTime = null;
                          });
                        },
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            final String dayOfWeek = DateFormat(
                              'EEEE',
                              'pt_PT',
                            ).format(day);

                            if (widget.campo.diasFuncionamento.containsKey(
                              dayOfWeek,
                            )) {
                              return Container(
                                margin: const EdgeInsets.all(6.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${day.day}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }
                            return null;
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    // Botão para escolher horário
                    ElevatedButton(
                      onPressed: () => _showAvailableTimes(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Cor de fundo do botão
                        foregroundColor: Colors.black, // Cor do texto
                      ),
                      child: const Text('Escolher horário'),
                    ),
                    const SizedBox(height: 20),
                    // Botão para confirmar reserva
                    ElevatedButton(
                      onPressed: () {
                        if (selectedStartTime != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Reserva confirmada para ${widget.campo.nome} em ${DateFormat('yyyy-MM-dd').format(today)} às ${selectedStartTime!.format(context)}',
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Por favor, selecione a data e o horário',
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Cor de fundo do botão
                        foregroundColor: Colors.black, // Cor do texto
                      ),
                      child: const Text('Confirmar Reserva'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAvailableTimes(BuildContext context) {
    final String dayOfWeek = DateFormat('EEEE', 'pt_PT').format(today);
    final availableTimes =
        widget.campo.diasFuncionamento[dayOfWeek] as List<List<TimeOfDay>>?;

    if (availableTimes == null || availableTimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não há horários disponíveis para este dia.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolher horário'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                availableTimes.map((timeRange) {
                  return ListTile(
                    title: Text(
                      '${timeRange[0].format(context)} - ${timeRange[1].format(context)}',
                    ),
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
}
