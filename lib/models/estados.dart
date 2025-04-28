enum EstadoPartidaPublica { aberta, cheia, emAndamento, concluida, cancelada }

enum EstadoPartidaPrivada {
  confirmada,
  emAndamento,
  concluida,
  cancelada,
}

enum EstadoCampo { disponivel, reservado, emManutencao, indisponivel }

enum EstadoUsuario { ativo, inativo, banido, convidado }

extension EnumToString on Enum {
  String toShortString() {
    return toString().split('.').last; 
  }
}

