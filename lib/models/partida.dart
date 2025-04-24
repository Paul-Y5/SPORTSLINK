import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/models/msg.dart';

class Partida {
  int id;
  DateTime data;
  DateTime hora;
  double duracao;
  Campo campo;
  String resultado;
  List<Jogador> jogadores;
  int noJogadores;
  List<Msg> chat;
  String estado;

  Partida({
    required this.id,
    required this.data,
    required this.hora,
    required this.duracao,
    required this.campo,
    required this.resultado,
    required this.jogadores,
    required this.noJogadores,
    required this.chat,
    required this.estado,
  });  

  factory Partida.fromJson(Map<String, dynamic> json) {
    return Partida(
      id: json['id'],
      data: DateTime.parse(json['data']),
      hora: DateTime.parse(json['hora']),
      duracao: json['duracao'].toDouble(),
      campo: Campo.fromJson(json['campo']),
      resultado: json['resultado'],
      jogadores: (json['jogadores'] as List).map((j) => Jogador.fromJson(j)).toList(),
      noJogadores: json['noJogadores'],
      chat: (json['chat'] as List).map((m) => Msg.fromJson(m)).toList(),
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data.toIso8601String(),
      'hora': hora.toIso8601String(),
      'duracao': duracao,
      'campo': campo.toJson(),
      'resultado': resultado,
      'jogadores': jogadores.map((j) => j.toJson()).toList(),
      'noJogadores': noJogadores,
      'chat': chat.map((m) => m.toJson()).toList(),
      'estado': estado,
    };
  }

  @override
  String toString() {
    return 'Partida{id: $id, data: $data, hora: $hora, duracao: $duracao, campo: $campo, resultado: $resultado, jogadores: $jogadores, noJogadores: $noJogadores, chat: $chat, estado: $estado}';
  }

  @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;
    if (other is! Partida) return false;
    return id == other.id &&
        data == other.data &&
        hora == other.hora &&
        duracao == other.duracao &&
        campo == other.campo &&
        resultado == other.resultado &&
        jogadores == other.jogadores &&
        noJogadores == other.noJogadores &&
        chat == other.chat &&
        estado == other.estado;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        data.hashCode ^
        hora.hashCode ^
        duracao.hashCode ^
        campo.hashCode ^
        resultado.hashCode ^
        jogadores.hashCode ^
        noJogadores.hashCode ^
        chat.hashCode ^
        estado.hashCode;
  }

}