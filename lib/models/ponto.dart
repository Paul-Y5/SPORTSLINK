class Ponto {
  int id;
  int idMapa;
  double latitude;
  double longitude;

  Ponto({
    required this.id,
    required this.idMapa,
    required this.latitude,
    required this.longitude,
  });

  factory Ponto.fromJson(Map<String, dynamic> json) {
    return Ponto(
      id: json['ID'] as int,
      idMapa: json['ID_Mapa'] as int,
      latitude: (json['Latitude'] as num).toDouble(),
      longitude: (json['Longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'ID_Mapa': idMapa,
      'Latitude': latitude,
      'Longitude': longitude,
    };
  }

  @override
  String toString() {
    return 'Ponto{id: $id, id_Mapa: $idMapa, latitude: $latitude, longitude: $longitude}';
  }
}