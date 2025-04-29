import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/models/campo_pub.dart';

List<Campo> filterCampos({
  required List<Campo> campos,
  required String query,
  required bool isAscending,
  String filtroTipo = 'todos', // 'todos', 'publico', 'privado'
  int camposVisiveis = 10,
  bool semLimite = false,
}) {
  // Filtro de tipo
  List<Campo> filtrados = campos.where((campo) {
    if (filtroTipo == 'publico' && campo is! CampoPub) return false;
    if (filtroTipo == 'privado' && campo is! CampoPriv) return false;
    return campo.nome.toLowerCase().contains(query.toLowerCase());
  }).toList();

  // Ordenação
  filtrados.sort((a, b) =>
      isAscending ? a.nome.compareTo(b.nome) : b.nome.compareTo(a.nome));

  // Limite opcional
  return semLimite ? filtrados : filtrados.take(camposVisiveis).toList();
}
