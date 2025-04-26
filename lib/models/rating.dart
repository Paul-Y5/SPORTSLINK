class Rating {
  int id;
  int idAvaliador;
  int rating;
  DateTime data;
  String? comentario;
  int idAvaliado;

  Rating({
    required this.id,
    required this.idAvaliador,
    required this.rating,
    required this.data,
    this.comentario,
    required this.idAvaliado,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      idAvaliador: json['idAvaliador'],
      rating: json['rating'],
      data: DateTime.parse(json['data']),
      comentario: json['comentario'],
      idAvaliado: json['idAvaliado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idAvaliador': idAvaliador,
      'rating': rating,
      'data': data.toIso8601String(),
      'comentario': comentario,
      'idAvaliado': idAvaliado,
    };
  }

  @override
  String toString() {
    return 'Rating{id: $id, idAvaliador: $idAvaliador, rating: $rating, data: $data, comentario: $comentario, idAvaliado: $idAvaliado}';
  }
  
}