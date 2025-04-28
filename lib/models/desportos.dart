enum Desportos {
  futebol,
  basquetebol,
  andebol,
  voleibol,
  tenis,
  futsal
}

extension DesportosExtension on Desportos {
  String get nome {
    switch (this) {
      case Desportos.futebol:
        return 'Futebol';
      case Desportos.basquetebol:
        return 'Basquetebol';
      case Desportos.andebol:
        return 'Andebol';
      case Desportos.voleibol:
        return 'Voleibol';
      case Desportos.tenis:
        return 'Tênis';
      case Desportos.futsal:
        return 'Futsal';
    }
  }
}