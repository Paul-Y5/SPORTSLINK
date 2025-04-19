import 'package:sports_link/models/campo_priv.dart';

List<CampoPriv> filterCampos({
  required List campos,
  required String query,
  required bool isAscending,
  int camposVisiveis = 10,
  bool semLimite = false,
}) {
  List<CampoPriv> filtrados =
      campos
          .whereType<CampoPriv>()
          .where(
            (campo) => campo.nome.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

  filtrados.sort(
    (a, b) => isAscending ? a.nome.compareTo(b.nome) : b.nome.compareTo(a.nome),
  );

  return semLimite ? filtrados : filtrados.take(camposVisiveis).toList();
}
