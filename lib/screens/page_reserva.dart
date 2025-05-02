import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/models/utilizador.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/styles/custom_appbar.dart';
import 'package:sports_link/controllers/controller_dropdown.dart' as dpd;

class PageReserva extends StatefulWidget {
  final CampoPriv campo;
  final Utilizador user;

  const PageReserva({super.key, required this.campo, required this.user});

  @override
  PageReservaState createState() => PageReservaState();
}

class PageReservaState extends State<PageReserva> {
  DateTime today = DateTime.now();
  DateTime focusedDay = DateTime.now();
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  String? metodoPagamentoSelecionado;

  final GlobalKey notificationButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_PT', null)
        .then((_) {
          setState(() {});
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
          const Carouselbg(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
              notificationButtonKey: notificationButtonKey,
              onNotificationPressed: (context) {
                dpd.showNotificationDropdown(
                  context,
                  notificationButtonKey,
                  widget.user,
                );
              },
              onMenuPressed: (context, items) {
                dpd.toggleDropdownOverlay(context, items);
              },
              user: widget.user,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      widget.campo.nome,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 20),
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
                        selectedDayPredicate: (day) => isSameDay(today, day),
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
                            final String dayOfWeek =
                                DateFormat(
                                  'EEEE',
                                  'pt_PT',
                                ).format(day).toLowerCase();

                            if (!widget.campo.diasFuncionamento.containsKey(
                              dayOfWeek,
                            )) {
                              return null;
                            }

                            final totalSlots =
                                widget
                                    .campo
                                    .diasFuncionamento[dayOfWeek]
                                    ?.length ??
                                0;

                            final reservasDoDia =
                                widget.campo.reservas?[DateFormat(
                                  'yyyy-MM-dd',
                                ).format(day)] ??
                                [];

                            final int reservasCount = reservasDoDia.length;

                            Color backgroundColor;

                            if (reservasCount == 0) {
                              backgroundColor = Colors.green;
                            } else if (reservasCount < totalSlots) {
                              backgroundColor = Colors.orange;
                            } else {
                              backgroundColor = Colors.red;
                            }

                            return Container(
                              margin: const EdgeInsets.all(6.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Método de Pagamento
                    if (widget.campo.arrendador.metodosPagamento.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Método de Pagamento',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButton<String>(
                            value: metodoPagamentoSelecionado,
                            hint: const Text('Selecionar método de pagamento'),
                            isExpanded: true,
                            items:
                                widget.campo.arrendador.metodosPagamento.entries
                                    .map((entry) {
                                      return DropdownMenuItem<String>(
                                        value: entry.key,
                                        child: Text(entry.value),
                                      );
                                    })
                                    .toList(),
                            onChanged: (value) {
                              setState(() {
                                metodoPagamentoSelecionado = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),

                    ElevatedButton(
                      onPressed: () => _showAvailableTimes(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Escolher horário'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedStartTime != null &&
                            metodoPagamentoSelecionado != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Reserva confirmada para ${widget.campo.nome} em ${DateFormat('yyyy-MM-dd').format(today)} às ${selectedStartTime!.format(context)}\nMétodo: ${widget.campo.arrendador.metodosPagamento[metodoPagamentoSelecionado]!}',
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Por favor, selecione a data, horário e método de pagamento',
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.black,
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
    final String dayOfWeek =
        DateFormat('EEEE', 'pt_PT').format(today).toLowerCase();
    final timeRange = widget.campo.diasFuncionamento[dayOfWeek];

    if (timeRange == null || timeRange.length < 2) {
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
          content: ListTile(
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
          ),
        );
      },
    );
  }
}
