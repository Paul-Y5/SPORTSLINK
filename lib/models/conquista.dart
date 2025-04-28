class Conquista {
  final String nome;
  final String descricao;
  bool desbloqueada;

  Conquista({
    required this.nome,
    required this.descricao,
    this.desbloqueada = false,
  });

  void desbloquear() {
    desbloqueada = true;
  }
}
