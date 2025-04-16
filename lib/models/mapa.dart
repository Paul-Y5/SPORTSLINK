class Mapa {
  final int id;
  final DateTime ultimoUpdate;

  Mapa({
    required this.id,
    required this.ultimoUpdate,
  });

  @override
  String toString() {
    return 'Mapa{id: $id, ultimoUpdate: $ultimoUpdate}';
  }
}