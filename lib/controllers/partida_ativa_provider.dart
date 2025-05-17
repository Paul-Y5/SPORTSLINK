import 'package:flutter/material.dart';

class PartidaAtivaProvider with ChangeNotifier {
  bool _emPartida = false;
  String? _infoPartida;
  VoidCallback? _retornarPartida;

  bool get emPartida => _emPartida;
  String? get infoPartida => _infoPartida;

  void iniciarPartida(String info, VoidCallback retornar) {
    _emPartida = true;
    _infoPartida = info;
    _retornarPartida = retornar;
    notifyListeners();
  }

  void sairDaPartida() {
    _emPartida = false;
    _infoPartida = null;
    _retornarPartida = null;
    notifyListeners();
  }

  void voltarParaPartida() {
    _retornarPartida?.call();
  }
}