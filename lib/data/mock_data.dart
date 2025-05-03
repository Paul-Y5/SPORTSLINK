import 'package:flutter/material.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/desportos.dart';
import 'package:sports_link/models/jogador.dart';
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
    imagem: 'https://example.com/campo_grande.png',
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
    imagem: 'https://example.com/campo_ribeirinho.png',
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
    imagem: 'https://example.com/campo_universitario.png',
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
];

// PARTIDAS
final List<Partida> mockPartidas = [
  Partida(
    id: 1,
    data: DateTime.now(),
    hora: TimeOfDay(hour: 10, minute: 0),
    duracao: 90.0,
    campo: mockCampos[0],
    resultado: '2-1',
    jogadores: [],
    chat: [],
    estado: EstadoPartida.agendada,
    tipo: TipoPartida.publica,
  ),
  Partida(
    id: 2,
    data: DateTime.now().add(Duration(days: 1)),
    hora: TimeOfDay(hour: 15, minute: 0),
    duracao: 60.0,
    campo: mockCampos[1],
    resultado: null,
    jogadores: [],
    chat: [],
    estado: EstadoPartida.agendada,
    tipo: TipoPartida.privada,
  ),
];

// UTILIZADORES
final Map<int, Utilizador> mockUsers = {
  // Arrendadores
  1: Arrendador(
    id: 1,
    nome: 'João Silva',
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
    nacionalidade: 'Brasileira',
    idade: 29,
    descricao: 'Jogadora com paixão por esportes coletivos.',
    utilizador: 'mariaoliveira',
    createDate: DateTime.now(),
  ),
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
  ).setAltura(1.85)
    ..setPeso(80.0)
    ..adicionarDesporto(Desportos.futebol)
    ..adicionarDesporto(Desportos.basquetebol),
};


enum LoginResult { success, wrongPassword, userNotFound }

LoginResult verificarLogin(
  String email,
  String password, {
  StringBuffer? userId,
}) {
  late final Utilizador user;
  try {
    user = mockUsers.values.firstWhere((user) => user.email == email);
  } catch (e) {
    return LoginResult.userNotFound;
  }

  if (!mockUsers.containsKey(user.id)) {
    return LoginResult.userNotFound;
  }


  if (user.password != password) {
    return LoginResult.wrongPassword;
  }

  if (userId != null) {
    userId.write(user.id);
  }

  return LoginResult.success;
}
