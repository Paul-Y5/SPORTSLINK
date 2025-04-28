import 'package:sports_link/models/jogador.dart';

class Avaliation {
  // Atributos
  final int id;
  final Jogador utilizador;
  final String? comentario;
  final int rating;
  final DateTime data;

  Avaliation({
    required this.id,
    required this.utilizador,
    required this.comentario,
    required this.rating,
    required this.data,
  });

  factory Avaliation.fromJson(Map<String, dynamic> json) {
    return Avaliation(
      id: json['id'] as int,
      utilizador: Jogador.fromJson(json['utilizador']),
      comentario: json['comentario'] as String,
      rating: json['rating'] as int,
      data: DateTime.parse(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'utilizador': utilizador,
      'comentario': comentario,
      'rating': rating,
      'data': data.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Avaliation{id: $id, utilizador: $utilizador, comentario: $comentario, rating: $rating, data: $data}';
  }

}