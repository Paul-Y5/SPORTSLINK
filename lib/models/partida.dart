import 'package:flutter/material.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/models/msg.dart';

class Partida {
  int id;
  DateTime data;
  TimeOfDay hora;
  double? duracao;
  Campo campo;
  String? resultado;
  List<Jogador>? jogadores;
  List<Msg>? chat;
  EstadoPartida estado;
  TipoPartida tipo;
  int? numeroJogadoresMinimo;
  int? numeroJogadoresMaximo;

  Partida({
    required this.id,
    required this.data,
    required this.hora,
    this.duracao,
    required this.campo,
    this.resultado,
    this.jogadores,
    this.chat,
    required this.estado,
    required this.tipo,
    this.numeroJogadoresMinimo,
    this.numeroJogadoresMaximo,
  });  

  factory Partida.fromJson(Map<String, dynamic> json) {
    return Partida(
      id: json['id'],
      data: DateTime.parse(json['data']),
      hora: _parseTimeOfDay(json['hora']),
      duracao: json['duracao'].toDouble(),
      campo: Campo.fromJson(json['campo']),
      resultado: json['resultado'],
      jogadores: (json['jogadores'] as List).map((j) => Jogador.fromJson(j)).toList(),
      chat: (json['chat'] as List).map((m) => Msg.fromJson(m)).toList(),
      estado: EstadoPartida.values.firstWhere((e) => e.toString() == 'EstadoPartida.${json['estado']}'),
      tipo: TipoPartida.values.firstWhere((e) => e.toString() == 'TipoPartida.${json['tipo']}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data.toIso8601String(),
      'hora': '${hora.hour}:${hora.minute}',
      'duracao': duracao,
      'campo': campo.toJson(),
      'resultado': resultado,
      'jogadores': jogadores?.map((j) => j.toJson()).toList(),
      'chat': chat?.map((m) => m.toJson()).toList(),
      'estado': estado,
      'tipo': tipo,
    };
  }

  @override
  String toString() {
    return 'Partida{id: $id, data: $data, hora: $hora, duracao: $duracao, campo: $campo, resultado: $resultado, jogadores: $jogadores, chat: $chat, estado: $estado, tipo: $tipo}';
  }

  @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;
    if (other is! Partida) return false;
    return id == other.id &&
        campo == other.campo &&
        estado == other.estado &&
        tipo == other.tipo;
  }

  @override
  int get hashCode {
    return id.hashCode ^ campo.hashCode ^ estado.hashCode ^ tipo.hashCode;
  }

  static TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  void setEstado(EstadoPartida novoEstado) {
    estado = novoEstado;
  }

}

enum TipoPartida {
  publica, // Partida pública, aberta a todos os jogadores
  privada, // Partida privada, apenas para jogadores convidados
}

enum EstadoPartida {
  agendada, // A partida está agendada
  aguardando, // A partida está aguardando jogadores
  emAndamento, // A partida está em andamento
  terminada,   // A partida foi terminada
  cancelada, // A partida foi cancelada
}
