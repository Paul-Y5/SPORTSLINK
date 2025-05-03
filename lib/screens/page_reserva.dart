import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sports_link/data/my_user.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/utils/general.dart';
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
    final arrendador = getMyUser(widget.campo.idArrendador) as Arrendador;
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
                  _buildCalendar(),
                  const SizedBox(height: 10),
                  _buildLegenda(),
                  const SizedBox(height: 20),
                  if (arrendador.metodosPagamento.isNotEmpty)
                    _buildDropdownPagamento(arrendador),
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
                              'Reserva confirmada para ${widget.campo.nome} em ${DateFormat('yyyy-MM-dd').format(today)} às ${selectedStartTime!.format(context)}\nMétodo: ${arrendador.metodosPagamento[metodoPagamentoSelecionado]!}',
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
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(165, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
        focusedDay: focusedDay,
        headerVisible: true,
        headerStyle: const HeaderStyle(
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          formatButtonVisible: false,
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.orange),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.orange),
        ),
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
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(),
          selectedDecoration: BoxDecoration(),
          defaultDecoration: BoxDecoration(),
          weekendDecoration: BoxDecoration(),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, _) {
            final dayOfWeek = getDiaSemanaPt(day);
            debugPrint(
              'Dia: $day - Dia da semana: $dayOfWeek - Funciona? ${widget.campo.diasFuncionamento.containsKey(dayOfWeek)}',
            );
            debugPrint(
              "CHAVES DO diasFuncionamento: ${widget.campo.diasFuncionamento.keys.toList()}",
            );

            if (!widget.campo.diasFuncionamento.containsKey(dayOfWeek)) {
              return Container(
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }

            final totalSlots =
                widget.campo.diasFuncionamento[dayOfWeek]?.length ?? 0;
            final reservasDoDia =
                widget.campo.reservas?[DateFormat('yyyy-MM-dd').format(day)] ??
                [];
            final reservasCount = reservasDoDia.length;

            debugPrint(
              'Dia: $day - Total de slots: $totalSlots - Reservas: $reservasCount',
            );

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
          todayBuilder:
              (context, day, _) => Container(
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey, // cor de fundo cinza para o dia atual
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  '${day.day}',
                  style: const TextStyle(
                    color: Colors.white,
                  ), // texto branco sobre fundo cinza
                ),
              ),
          selectedBuilder:
              (context, day, _) => Container(
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${day.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
          outsideBuilder:
              (context, day, _) => Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildLegenda() {
    Widget item(Color color, String label) => Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        item(Colors.green, "Disponível"),
        item(Colors.orange, "Com reservas"),
        item(Colors.red, "Indisponível"),
      ],
    );
  }

  Widget _buildDropdownPagamento(Arrendador arrendador) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Método de Pagamento',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: metodoPagamentoSelecionado,
          hint: const Text('Selecionar método de pagamento'),
          isExpanded: true,
          items:
              arrendador.metodosPagamento.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
          onChanged: (value) {
            setState(() {
              metodoPagamentoSelecionado = value;
            });
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _showAvailableTimes(BuildContext context) {
    final dayOfWeek = getDiaSemanaPt(today);
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
                if (timeRange[0].hour < timeRange[1].hour || 
                    (timeRange[0].hour == timeRange[1].hour && timeRange[0].minute < timeRange[1].minute)) {
                  selectedStartTime = timeRange[0];
                  selectedEndTime = timeRange[1];
                } else {
                  selectedStartTime = timeRange[1];
                  selectedEndTime = timeRange[0];
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Horário selecionado: ${selectedStartTime!.format(context)} - ${selectedEndTime!.format(context)}',
                    ),
                  ),
                );
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
