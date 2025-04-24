import 'package:sports_link/models/jogador.dart';

class Msg {
  String conteudo;
  Jogador remetente;
  DateTime timestamp;

  Msg({
    required this.conteudo,
    required this.remetente,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'conteudo': conteudo,
      'remetente': remetente.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Msg.fromJson(Map<String, dynamic> json) {
    return Msg(
      conteudo: json['conteudo'],
      remetente: Jogador.fromJson(json['remetente']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  @override
  String toString() {
    return 'Mensagem{conteudo: $conteudo, remetente: $remetente, timestamp: $timestamp}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Msg &&
        other.conteudo == conteudo &&
        other.remetente == remetente &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return conteudo.hashCode ^ remetente.hashCode ^ timestamp.hashCode;
  }

}