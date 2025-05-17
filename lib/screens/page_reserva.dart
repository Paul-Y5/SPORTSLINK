import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sports_link/data/my_user.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/models/reserva.dart';
import 'package:sports_link/screens/main_page_1.dart';
import 'package:sports_link/utils/general.dart';
import 'package:sports_link/widgets/style_row.dart';
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
  int? numeroHorasReserva;

  final GlobalKey notificationButtonKey = GlobalKey();

  final TextEditingController numeroCartaoController = TextEditingController();
  final TextEditingController nomeCartaoController = TextEditingController();
  final TextEditingController validadeCartaoController = TextEditingController();
  final TextEditingController cvvCartaoController = TextEditingController();
  final TextEditingController telefoneMbWayController = TextEditingController();
  final TextEditingController emailPayPalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_PT', null).catchError((e) {
      debugPrint('Erro ao inicializar a formatação de data: $e');
    });
  }

  // Função para calcular o horário de fim de reserva baseado nas horas informadas
  TimeOfDay? calcularHoraFim(TimeOfDay startTime, int numeroHoras) {
    final startInMinutes = startTime.hour * 60 + startTime.minute;
    final endInMinutes = startInMinutes + (numeroHoras * 60);
    final endHour = (endInMinutes ~/ 60) % 24;
    final endMinute = endInMinutes % 60;
    return TimeOfDay(hour: endHour, minute: endMinute);
  }

  // Função para mostrar a caixa de diálogo para o usuário inserir o número de horas
  void _showInputHoras(BuildContext context) {
    final dayOfWeek = getDiaSemanaPt(today);
    final timeRange = widget.campo.diasFuncionamento[dayOfWeek];

    if (timeRange == null || timeRange.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não há horários disponíveis para este dia.'),
        ),
      );
      return;
    }

    final start = selectedStartTime!;
    final endLimit = timeRange.last;

    // Obter horários reservados
    List<TimeOfDay> horariosReservados = getHorariosReservados(today, widget.campo);

    // Calcular durações válidas
    List<int> duracoesValidas = [];
    int horas = 1;

    while (true) {
      final fim = calcularHoraFim(start, horas);
      if (fim == null ||
          fim.hour > endLimit.hour ||
          (fim.hour == endLimit.hour && fim.minute > endLimit.minute)) {
        break;
      }

      // Verificar se o intervalo está ocupado
      final inicioIntervalo = toMinutes(start);
      final fimIntervalo = toMinutes(fim);

      final intervaloOcupado = horariosReservados.any((reservado) {
        final reservadoEmMinutos = toMinutes(reservado);
        return reservadoEmMinutos >= inicioIntervalo && reservadoEmMinutos < fimIntervalo;
      });

      if (!intervaloOcupado) {
        duracoesValidas.add(horas);
      }

      horas++;
    }

    if (duracoesValidas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não há durações válidas disponíveis.'),
        ),
      );
      return;
    }

    // Exibir as durações válidas
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecionar duração'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: duracoesValidas.length,
              itemBuilder: (context, index) {
                final horas = duracoesValidas[index];
                final fim = calcularHoraFim(start, horas)!;
                return ListTile(
                  title: Text(
                    '${horas}h - ${start.format(context)} até ${fim.format(context)}',
                  ),
                  subtitle: Text(
                    'Total a pagar: ${(widget.campo.preco * horas).toStringAsFixed(2)}€',
                  ),
                  onTap: () {
                    setState(() {
                      numeroHorasReserva = horas;
                      selectedEndTime = fim;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  //Função para mostrar os horários disponíveis
  void _showAvailableTimes(BuildContext context) {
    final dayOfWeek = getDiaSemanaPt(today);
    final timeRange = widget.campo.diasFuncionamento[dayOfWeek];

    if (timeRange == null || timeRange.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não há horários disponíveis para este dia.'),
        ),
      );
      return;
    }

    // Obter todos os horários disponíveis no intervalo de funcionamento
    List<TimeOfDay> todosHorarios = gerarHorariosFuncionamento(timeRange);
    debugPrint('Todos os horários disponíveis: ${todosHorarios.map((h) => h.format(context)).toList()}');

    // Filtrar horários já reservados
    List<TimeOfDay> horariosReservados = getHorariosReservados(today, widget.campo);
    debugPrint('Horários reservados: ${horariosReservados.map((h) => h.format(context)).toList()}');

    List<TimeOfDay> horariosDisponiveis = todosHorarios.where((horario) {
      final inicioIntervalo = toMinutes(horario);
      final fimIntervalo = inicioIntervalo + 60;

      final ocupado = horariosReservados.any((reservado) {
        final reservadoEmMinutos = toMinutes(reservado);
        return reservadoEmMinutos >= inicioIntervalo && reservadoEmMinutos < fimIntervalo;
      });

      debugPrint('Horário ${horario.format(context)} está ocupado? $ocupado');
      return !ocupado;
    }).toList();

    debugPrint('Horários disponíveis: ${horariosDisponiveis.map((h) => h.format(context)).toList()}');

    if (horariosDisponiveis.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não há horários disponíveis para este dia.'),
        ),
      );
      return;
    }

    // Exibir os horários disponíveis
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolher horário de início'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: horariosDisponiveis.length,
              itemBuilder: (context, index) {
                final horario = horariosDisponiveis[index];
                return ListTile(
                  title: Text(horario.format(context)),
                  onTap: () {
                    setState(() {
                      selectedStartTime = horario;
                    });
                    Navigator.pop(context);
                    _showInputHoras(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final arrendador = getMyUser(widget.campo.idArrendador) as Arrendador;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        // Adicionado SafeArea
        child: Stack(
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
                    if (selectedStartTime != null &&
                        selectedEndTime != null &&
                        numeroHorasReserva != null)
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildInfoRow('Data', DateFormat('dd/MM/yyyy').format(today)),
                              const SizedBox(height: 8),
                              buildInfoRow('Horário', '${formatTimeOfDay(selectedStartTime!)} - ${formatTimeOfDay(selectedEndTime!)}'),
                              const SizedBox(height: 8),
                              buildInfoRow('Duração', '$numeroHorasReserva horas'),
                              const SizedBox(height: 8),
                              buildInfoRow('Total a Pagar', '${(widget.campo.preco * numeroHorasReserva!).toStringAsFixed(2)}€'),
                              if (widget.campo.desportos.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                buildInfoRow('Desportos Associados', widget.campo.desportos.map((d) => d.toString().trim().split('.').last).join(', ')),
                              ],
                            ],
                          ),
                        ),
                      ),
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
                            metodoPagamentoSelecionado != null &&
                            selectedEndTime != null &&
                            numeroHorasReserva != null) {
                          final horario = '${selectedStartTime!.format(context)} - ${selectedEndTime!.format(context)}';
                          final data = DateFormat('dd/MM/yyyy').format(today);
                          final total = (widget.campo.preco * numeroHorasReserva!).toStringAsFixed(2);

                          // Exibe o popup de pagamento
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text(
                                  'Efetuar Pagamento',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Campo: ${widget.campo.nome}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Data: $data',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Horário: $horario',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Total: $total€',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Formulário específico para o método de pagamento selecionado
                                      if (metodoPagamentoSelecionado == 'Cartão de Crédito')
                                        Column(
                                          children: [
                                            TextField(
                                              controller: numeroCartaoController,
                                              decoration: InputDecoration(
                                                labelText: 'Número do Cartão',
                                                border: const OutlineInputBorder(),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.orange,
                                                    width: 2,
                                                  ),
                                                ),
                                                labelStyle: const TextStyle(
                                                  color: Color.fromARGB(255, 0, 0, 0),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            TextField(
                                              controller: nomeCartaoController,
                                              decoration: const InputDecoration(
                                                labelText: 'Nome no Cartão',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller: validadeCartaoController,
                                                    decoration: const InputDecoration(
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                  color:
                                                                      Colors
                                                                          .orange,
                                                                  width: 2,
                                                                ),
                                                          ),
                                                      labelStyle: TextStyle(
                                                        color: Color.fromARGB(255, 0, 0, 0),
                                                      ),
                                                      labelText: 'Validade (MM/AA)',
                                                      border: OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: TextField(
                                                    controller: cvvCartaoController,
                                                    decoration: const InputDecoration(
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                  color:
                                                                      Colors
                                                                          .orange,
                                                                  width: 2,
                                                                ),
                                                          ),
                                                      labelStyle: TextStyle(
                                                        color: Color.fromARGB(255, 0, 0, 0),
                                                      ),
                                                      labelText: 'CVV',
                                                      border: OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      else if (metodoPagamentoSelecionado == 'MB Way')
                                        Column(
                                          children: [
                                            TextField(
                                              controller: telefoneMbWayController,
                                              decoration: const InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.orange,
                                                        width: 2,
                                                      ),
                                                    ),
                                                labelStyle: TextStyle(
                                                  color: Color.fromARGB(255, 0, 0, 0),
                                                ),
                                                labelText: 'Número de Telefone',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Você receberá uma notificação no seu MB Way para confirmar o pagamento.',
                                              style: TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      else if (metodoPagamentoSelecionado == 'PayPal')
                                        Column(
                                          children: [
                                            TextField(
                                              controller: emailPayPalController,
                                              decoration: const InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.orange,
                                                        width: 2,
                                                      ),
                                                    ),
                                                labelStyle: TextStyle(
                                                  color: Color.fromARGB(255, 0, 0, 0),
                                                ),
                                                labelText: 'E-mail do PayPal',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Você será redirecionado para o PayPal para concluir o pagamento.',
                                              style: TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      else if (metodoPagamentoSelecionado == 'Transferencia Bancaria')
                                        Text(
                                          'Transferência Bancária para o IBAN: ${arrendador.iban}',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Processa os dados do formulário
                                      if (metodoPagamentoSelecionado == 'Cartão de Crédito') {
                                        final numeroCartao = numeroCartaoController.text;
                                        final nomeCartao = nomeCartaoController.text;
                                        final validade = validadeCartaoController.text;
                                        final cvv = cvvCartaoController.text;

                                        if (numeroCartao.isEmpty || nomeCartao.isEmpty || validade.isEmpty || cvv.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Por favor, preencha todos os campos do cartão de crédito.'),
                                            ),
                                          );
                                          return;
                                        }
                                      } else if (metodoPagamentoSelecionado == 'MB Way') {
                                        final telefone = telefoneMbWayController.text;

                                        if (telefone.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Por favor, insira o número de telefone para MB Way.'),
                                            ),
                                          );
                                          return;
                                        }
                                      } else if (metodoPagamentoSelecionado == 'PayPal') {
                                        final email = emailPayPalController.text;

                                        if (email.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Por favor, insira o e-mail do PayPal.'),
                                            ),
                                          );
                                          return;
                                        }
                                      }

                                      DateTime dataFormatted = DateFormat('dd/MM/yyyy').parse(data);
                                      // Finaliza a reserva e atualiza map de reservas
                                      final reserva = Reserva(
                                        id: Random().nextInt(1000000),
                                        idCampo: widget.campo.id,
                                        idCliente: widget.user.id,
                                        idArrendador: widget.campo.idArrendador,
                                        data: dataFormatted,
                                        horaInicio: selectedStartTime!.format(context),
                                        tempoDuracao: numeroHorasReserva!.toString(),
                                        estado: "Confirmada",
                                        pagamento: metodoPagamentoSelecionado!,
                                      );

                                      if (widget.campo.reservas.containsKey(dataFormatted)) {
                                        widget.campo.reservas[dataFormatted]!.add(reserva);
                                      } else {
                                        widget.campo.reservas[dataFormatted] = [reserva];
                                      }

                                      // Parsed data para o formato correto
                                      final DateFormat formatter = DateFormat(
                                        'dd/MM/yyyy',
                                      );
                                      final parseddata = formatter.parse(data);

                                      //Utilizaddor cria partida no estado reservado
                                      (widget.user as Jogador).partidas.add(
                                        Partida(
                                            id: Random().nextInt(1000000),
                                            data: parseddata,
                                            hora: selectedStartTime!,
                                            campo: widget.campo,
                                            estado: EstadoPartida.agendada,
                                            tipo: TipoPartida.privada),
                                      );

                                      // Adiciona uma notificação ao arrendador
                                      final arrendador = getMyUser(widget.campo.idArrendador) as Arrendador;
                                      arrendador.notificacoes.add(
                                        'Reserva confirmada para ${widget.campo.nome} em $data, $horario. Total: $total€',
                                      );

                                      // Quem fez a reserva
                                      widget.user.notificacoes.add(
                                        'Reserva confirmada para ${widget.campo.nome} em $data, $horario. Total: $total€',
                                      );

                                      // Volta para a main page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainPage1(
                                            id: widget.user.id,
                                          ),
                                        ),
                                      );

                                      // Exibe uma mensagem de sucesso
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text('Reserva confirmada com sucesso!'),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                    ),
                                    child: const Text(
                                      'Confirmar Pagamento',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              );
                            },
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

          // Verifica se o dia está totalmente reservado
          final dayOfWeek = getDiaSemanaPt(selectedDay);
          if (widget.campo.diasFuncionamento.containsKey(dayOfWeek)) {
            final timeRange = widget.campo.diasFuncionamento[dayOfWeek]!;
            final inicio = timeRange[0];
            final fim = timeRange[1];

            // Gera todos os horários possíveis (de hora a hora)
            List<TimeOfDay> todosSlots = [];
            var horaAtual = inicio;
            while (toMinutes(horaAtual) < toMinutes(fim)) {
              todosSlots.add(horaAtual);
              horaAtual = TimeOfDay(hour: horaAtual.hour + 1, minute: horaAtual.minute);
            }
            final totalSlots = todosSlots.length;

            // Lista de reservas já criadas nessa data
            final parsedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
            final reservasDoDia = widget.campo.reservas[parsedDay] ?? [];

            // Conta quantos slots estão ocupados
            int reservasCount = 0;
            for (var reserva in reservasDoDia) {
              final duracaoHoras = int.tryParse(reserva.tempoDuracao) ?? 1;
              reservasCount += duracaoHoras;
            }

            if (reservasCount >= totalSlots) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Já não há horários disponíveis para este dia!'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
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

            // Normaliza para tirar hora/minuto
            final parsedDay = DateTime(day.year, day.month, day.day);

            // Horário de funcionamento do campo nesse dia
            final timeRange = widget.campo.diasFuncionamento[dayOfWeek]!;
            final inicio = timeRange[0];
            final fim = timeRange[1];

            // Gera todos os horários possíveis (de hora a hora)
            List<TimeOfDay> todosSlots = [];
            var horaAtual = inicio;
            while (toMinutes(horaAtual) < toMinutes(fim)) {
              todosSlots.add(horaAtual);
              horaAtual = TimeOfDay(hour: horaAtual.hour + 1, minute: horaAtual.minute);
            }
            final totalSlots = todosSlots.length;

            // Lista de reservas já criadas nessa data
            final reservasDoDia = widget.campo.reservas[parsedDay] ?? [];

            // Conta quantos slots estão ocupados
            int reservasCount = 0;
            for (var reserva in reservasDoDia) {
              final duracaoHoras = int.tryParse(reserva.tempoDuracao) ?? 1;
              reservasCount += duracaoHoras;
            }

            // Cor do dia
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
          todayBuilder: (context, day, _) => Container(
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
                backgroundColor: Colors.grey, // texto branco sobre fundo cinza
              ), // texto branco sobre fundo cinza
            ),
          ),
          selectedBuilder: (context, day, _) => Container(
            margin: const EdgeInsets.all(6.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
              border: Border.all(color: const Color.fromARGB(255, 247, 247, 247), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${day.day}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          outsideBuilder: (context, day, _) => Center(
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
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: metodoPagamentoSelecionado,
          hint: const Text(
            'Selecionar método de pagamento',
            style: TextStyle(color: Colors.white),
          ),
          isExpanded: true,
          dropdownColor: Colors.black,
          items: arrendador.metodosPagamento.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: Text(
                  entry.value,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
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
}

String formatTimeOfDay(TimeOfDay time) {
  final now = DateTime.now();
  final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat('HH:mm').format(dateTime); // Formato de 24 horas
}

// Corrigir a função getHorariosReservados para incluir intervalos completos
List<TimeOfDay> getHorariosReservados(DateTime data, CampoPriv campo) {
  // Normalizar a data (remover hora, minuto e segundo)
  final dataNormalizada = DateTime(data.year, data.month, data.day);

  final reservasDoDia = campo.reservas[dataNormalizada] ?? [];
  List<TimeOfDay> horariosReservados = [];

  debugPrint('Reservas do dia $dataNormalizada: $reservasDoDia');

  for (var reserva in reservasDoDia) {
    final horaInicio = TimeOfDay(
      hour: int.parse(reserva.horaInicio.split(":")[0]),
      minute: int.parse(reserva.horaInicio.split(":")[1]),
    );
    final duracaoHoras = int.tryParse(reserva.tempoDuracao) ?? 1;

    for (int i = 0; i < duracaoHoras * 60; i += 15) {
      final horaBloqueada = TimeOfDay(
        hour: (horaInicio.hour + (horaInicio.minute + i) ~/ 60) % 24,
        minute: (horaInicio.minute + i) % 60,
      );
      horariosReservados.add(horaBloqueada);
    }
  }

  debugPrint('Horários reservados para $dataNormalizada: ${horariosReservados.map((h) => '${h.hour}:${h.minute.toString().padLeft(2, '0')}').toList()}');
  return horariosReservados;
}

int toMinutes(TimeOfDay time) {
  return time.hour * 60 + time.minute;
}
