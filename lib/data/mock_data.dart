import 'package:flutter/material.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/desportos.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/models/msg.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/models/ponto.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/models/campo_pub.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/utilizador.dart';

// PONTOS
final List<Ponto> mockPontos = [
  Ponto(id: 1, idMapa: 1, latitude: 38.7169, longitude: -9.1399), // Lisboa
  Ponto(id: 2, idMapa: 1, latitude: 41.1496, longitude: -8.6109), // Porto
  Ponto(id: 3, idMapa: 1, latitude: 40.6405, longitude: -8.6538), // Aveiro
  Ponto(id: 4, idMapa: 1, latitude: 41.263184, longitude: -7.584726), // Vila Real
];

// CAMPOS
final List<Campo> mockCampos = [
  CampoPriv(
    id: 1,
    idPonto: 1,
    idMapa: 1,
    nome: 'Campo Grande',
    comprimento: 100.0,
    largura: 60.0,
    ocupado: false,
    descricao: 'Relvado sintético, ideal para 11x11',
    ponto: mockPontos[0],
    idArrendador: 1, // Associado ao arrendador com ID 1
    preco: 50.0,
    diasFuncionamento: {
      'Segunda-feira': [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 18, minute: 0)],
      'Quarta-feira': [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 18, minute: 0)],
      'Sexta-feira': [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 18, minute: 0)],
    },
  ),
  CampoPub(
    id: 2,
    idPonto: 2,
    idMapa: 1,
    nome: 'Campo Ribeirinho',
    comprimento: 90.0,
    largura: 55.0,
    ocupado: true,
    descricao: 'Relva natural, vista para o Douro',
    ponto: mockPontos[1],
    entidadePublicaResp: "Câmara Municipal",
  ),
  CampoPriv(
    id: 3,
    idPonto: 3,
    idMapa: 2,
    nome: 'Campo Universitário',
    comprimento: 80.0,
    largura: 50.0,
    ocupado: false,
    descricao: 'Muito procurado por estudantes',
    ponto: mockPontos[2],
    idArrendador: 1, // Associado ao arrendador com ID 1
    preco: 45.0,
    diasFuncionamento: {
      'Terça-feira': [TimeOfDay(hour: 10, minute: 0), TimeOfDay(hour: 17, minute: 0)],
      'Quinta-feira': [TimeOfDay(hour: 10, minute: 0), TimeOfDay(hour: 17, minute: 0)],
    },
  ),
  CampoPriv(
    id: 4,
    idPonto: 1,
    idMapa: 1,
    nome: 'Campo Municipal',
    comprimento: 110.0,
    largura: 70.0,
    ocupado: true,
    descricao: 'Campo com iluminação noturna',
    ponto: mockPontos[3],
    imagem: 'img/icon_campo.jpg',
    idArrendador: 2, // Associado ao arrendador com ID 2
    preco: 55.0,
    diasFuncionamento: {
      'Segunda-feira': [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 20, minute: 0)],
      'Quarta-feira': [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 20, minute: 0)],
      'Sábado': [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 20, minute: 0)],
    },
  ),
  CampoPriv(
    id: 5,
    idPonto: 2,
    idMapa: 1,
    nome: 'Campo de Futsal',
    comprimento: 40.0,
    largura: 20.0,
    ocupado: false,
    descricao: 'Campo coberto, ideal para futsal',
    ponto: mockPontos[1],
    idArrendador: 2, // Associado ao arrendador com ID 2
    preco: 35.0,
    diasFuncionamento: {
      'Segunda-feira': [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 18, minute: 0)],
      'Quarta-feira': [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 18, minute: 0)],
    },
  ),
  CampoPub(
    id: 6,
    idPonto: 3,
    idMapa: 2,
    nome: 'Campo de Basquetebol',
    comprimento: 28.0,
    largura: 15.0,
    ocupado: false,
    descricao: 'Campo ao ar livre, ideal para basquete',
    ponto: mockPontos[2],
    entidadePublicaResp: "Câmara Municipal",
  )
];

// PARTIDAS
List<Partida> mockPartidas = [
  Partida(
    id: 1,
    data: DateTime.now(),
    hora: getTimeMinusTenMinutes(),
    duracao: 40.0,
    campo: mockCampos[5],
    resultado: '0:0',
    jogadores: [
      mockUsers[3] as Jogador,
      mockUsers[4] as Jogador,
      mockUsers[2] as Jogador,
      mockUsers[5] as Jogador,
      mockUsers[6] as Jogador,
    ],
    chat: [
      Msg(
        conteudo: 'Bora Bora!',
        remetente: mockUsers[6] as Jogador,
        timestamp: DateTime.now(),
      ),
      Msg(
        conteudo: 'Vamos lá, pessoal!',
        remetente: mockUsers[3] as Jogador,
        timestamp: DateTime.now(),
      ),
      Msg(
        conteudo: 'Estou dentro do campo!',
        remetente: mockUsers[4] as Jogador,
        timestamp: DateTime.now(),
      ),
    ],
    estado: EstadoPartida.emAndamento,
    tipo: TipoPartida.publica,
  ),
  Partida(
    id: 2,
    data: DateTime.now().add(Duration(days: 1)),
    hora: getTimeMinusTenMinutes(),
    duracao: 60.0,
    campo: mockCampos[1],
    resultado: null,
    jogadores: [mockUsers[9] as Jogador],
    chat: [Msg(conteudo: 'Estou na entrada do campo à espera de pessoal', remetente: mockUsers[9] as Jogador, timestamp: DateTime.now())],
    estado: EstadoPartida.aguardando,
    tipo: TipoPartida.publica,
  ),
];

getMockUsers(int id) {
  if (mockUsers.containsKey(id)) {
    return mockUsers[id];
  } else {
    throw Exception('Utilizador não encontrado');
  }
}

// UTILIZADORES
final Map<int, Utilizador> mockUsers = {
  // Arrendadores
  1: Arrendador(
    id: 1,
    nome: 'João Silva',
    nivel: 2.0,
    email: 'joao.silva@example.com',
    numTele: 912345678,
    password: 'senha123',
    nacionalidade: 'Português',
    idade: 35,
    descricao: 'Arrendador experiente com vários campos disponíveis.',
    noCampos: 3,
    iban: "BR99123456789",
    utilizador: 'joaosilva',
    createDate: DateTime.now(),
  )..adicionarMetodoPagamento('metodo1', 'Cartão de Crédito')
    ..adicionarMetodoPagamento('metodo2', 'MB Way'),
  2: Arrendador(
    id: 2,
    nome: 'Ana Costa',
    nivel: 3.0,
    email: 'ana.costa@example.com',
    numTele: 915678901,
    password: 'senha321',
    nacionalidade: 'Moçambicana',
    idade: 37,
    descricao: 'Gestora de campos desportivos com foco em futebol.',
    noCampos: 4,
    iban: "PT50556677889",
    utilizador: 'anacosta',
    createDate: DateTime.now(),
  )..adicionarMetodoPagamento('metodo1', 'MB Way')
    ..adicionarMetodoPagamento('metodo2', 'Transferência Bancária'),

  // Jogadores
  3: Jogador(
    id: 3,
    nome: 'Maria Oliveira',
    email: 'maria.oliveira@example.com',
    numTele: 913456789,
    password: 'senha456',
    nacionalidade: 'Angolana',
    idade: 25,
    descricao: 'Jogadora de futebol amadora, adora praticar desportos.',
    utilizador: 'mariaoliveira',
    createDate: DateTime.now(),
    nivel: 5, // Adicionado nível
  )..setAltura(1.70)
    ..setPeso(65.0)
    ..adicionarDesporto(Desportos.futebol)
    ..adicionarDesporto(Desportos.basquetebol),
  4: Jogador(
    id: 4,
    nome: 'Carlos Santos',
    email: 'carlos.santos@example.com',
    numTele: 914567890,
    password: 'senha789',
    nacionalidade: 'Angolano',
    idade: 42,
    descricao: 'Jogador experiente em eventos desportivos.',
    utilizador: 'carlossantos',
    createDate: DateTime.now(),
    nivel: 7, // Adicionado nível
  )..setAltura(1.85)
    ..setPeso(80.0)
    ..adicionarDesporto(Desportos.futebol)
    ..adicionarDesporto(Desportos.basquetebol),
  5: Jogador(
    id: 5,
    nome: 'Pedro Almeida',
    email: 'pedro@example.pt',
    numTele: 916789012,
    password: 'senha987',
    nacionalidade: 'Angolano',
    idade: 28,
    descricao: 'Jogador de futebol amador, adora praticar desportos.',
    utilizador: 'pedroalmeida',
    createDate: DateTime.now(),
    nivel: 4, // Adicionado nível
  )..setAltura(1.80)
    ..setPeso(75.0)
    ..adicionarDesporto(Desportos.futebol)
    ..adicionarDesporto(Desportos.basquetebol),
  6: Jogador(
    id: 6,
    nome: 'Luís Ferreira',
    email: 'luisF@example.pt',
    numTele: 917890123,
    password: 'senha654',
    nacionalidade: 'Angolano',
    idade: 30,
    descricao: 'Jogador de basquetebol, sempre em busca de novos desafios.',
    utilizador: 'luisferreira',
    createDate: DateTime.now(),
    nivel: 6, // Adicionado nível
  )..setAltura(1.90)
    ..setPeso(85.0)
    ..adicionarDesporto(Desportos.basquetebol)
    ..adicionarDesporto(Desportos.futsal),
  
  9: Jogador(
    id: 9,
    nome: 'Ana Luis',
    email: 'anaL@example.pt',
    numTele: 918901234,
    password: 'senha321',
    nacionalidade: 'Angolana',
    idade: 20,
    descricao: 'Jogadora de voleibol, apaixonada por desporto.',
    utilizador: 'analuis',
    createDate: DateTime.now(),
    nivel: 3, // Adicionado nível
  )..setAltura(1.75)
    ..setPeso(60.0)
    ..adicionarDesporto(Desportos.voleibol),

};

enum LoginResult { success, wrongPassword, userNotFound }

LoginResult verificarLogin(
  String email,
  String password, {
  StringBuffer? userId,
}) {
  late final Utilizador user;
  try {
    adicionarCamposAosArrendadores();
    mockCampos[5].setPartida(mockPartidas[0]);
    mockCampos[2].setPartida(mockPartidas[1]);
    user = mockUsers.values.firstWhere((user) => user.email == email);
  } catch (e) {
    debugPrint('Erro ao encontrar o utilizador: $e');
    return LoginResult.userNotFound;
  }

  if (!mockUsers.containsKey(user.id)) {
    return LoginResult.userNotFound;
  }


  if (user.password != password) {
    debugPrint('Senha incorreta para o utilizador: $email');
    return LoginResult.wrongPassword;
  }

  if (userId != null) {
    userId.write(user.id);
  }

  return LoginResult.success;
}

void adicionarCamposAosArrendadores() {
  for (var campo in mockCampos) {
    if (campo is CampoPriv) {
      final arrendador = mockUsers[campo.idArrendador];
      if (arrendador is Arrendador) {
        if (arrendador.camposPrivados.contains(campo)) {
          continue;
        }
        arrendador.adicionarCampo(campo);
      }
    }
  }
}

TimeOfDay getTimeMinusTenMinutes() {
  final now = DateTime.now();
  final updated = now.subtract(Duration(minutes: 10));
  return TimeOfDay(hour: updated.hour, minute: updated.minute);
}

void adicionarMsg(Msg msg, int idPartida) {
  if (mockPartidas.length > idPartida) {
    final partida = mockPartidas[idPartida];
    final msg = partida.chat?.last;
    final jogador = msg?.remetente;
    if (jogador?.id == 3) {
      partida.chat?.add(Msg(
        conteudo: 'Vamos lá, pessoal!',
        remetente: jogador!,
        timestamp: DateTime.now(),
      ));
    }
    } else {
    throw Exception('Partida não encontrada');
  }
}
