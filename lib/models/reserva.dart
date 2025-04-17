class Reserva {
  int id;
  int idCampo;
  int idCliente;
  int idArrendador;
  DateTime data;
  String horaInicio;
  String tempoDuracao;
  String estado;
  String? descricao;
  String? pagamento;
  String? feedback;


  Reserva({
    required this.id,
    required this.idCampo,
    required this.idCliente,
    required this.idArrendador,
    required this.data,
    required this.horaInicio,
    required this.tempoDuracao,
    required this.estado,
    this.descricao,
    this.pagamento,
    this.feedback,
  });

  // Convertendo para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idCampo': idCampo,
      'idCliente': idCliente,
      'idArrendador': idArrendador,
      'data': data.toIso8601String(),
      'horaInicio': horaInicio,
      'tempoDuracao': tempoDuracao,
      'estado': estado,
      'descricao': descricao,
      'pagamento': pagamento,
      'feedback': feedback,
    };
  }
}