import 'package:flutter/material.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/ponto.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/models/campo_pub.dart';
import 'package:sports_link/models/campo.dart';

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
    imagem:'https://example.com/campo_grande.png',
    idArrendador: 3,
    preco: 50.0, // Preço associado
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
    idArrendador: 3,
    preco: 45.0, // Preço associado
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
    idArrendador: 4,
    preco: 55.0, // Preço associado
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
    idArrendador: 4,
    preco: 35.0, // Preço associado
    diasFuncionamento: {
      'Segunda-feira': [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 18, minute: 0)],
      'Quarta-feira': [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 18, minute: 0)],
    },
  ),
  CampoPriv(
    id: 6,
    idPonto: 3,
    idMapa: 2,
    nome: 'Campo de Praia',
    comprimento: 50.0,
    largura: 30.0,
    ocupado: true,
    descricao: 'Campo de areia, ideal para futebol de praia',
    ponto: mockPontos[2],
    idArrendador: 3,
    preco: 40.0, // Preço associado
    diasFuncionamento: {
      'Sexta-feira': [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 16, minute: 0)],
      'Sábado': [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 16, minute: 0)],
    },
  ),
  CampoPriv(
    id: 7,
    idPonto: 1,
    idMapa: 1,
    nome: 'Campo de Treino',
    comprimento: 70.0,
    largura: 40.0,
    ocupado: false,
    descricao: 'Campo para treinos, com balizas ajustáveis',
    ponto: mockPontos[0],
    idArrendador: 3,
    preco: 30.0, // Preço associado
    diasFuncionamento: {
      'Terça-feira': [TimeOfDay(hour: 7, minute: 0), TimeOfDay(hour: 15, minute: 0)],
      'Quinta-feira': [TimeOfDay(hour: 7, minute: 0), TimeOfDay(hour: 15, minute: 0)],
    },
  ),
  CampoPub (
    id: 8,
    idPonto: 2,
    idMapa: 1,
    nome: 'Campo de Areia',
    comprimento: 60.0,
    largura: 30.0,
    ocupado: true,
    descricao: 'Campo de areia, ideal para treinos de resistência',
    ponto: mockPontos[1],
    entidadePublicaResp: "Câmara Municipal do Porto",
  ),
  CampoPriv(
    id: 9,
    idPonto: 3,
    idMapa: 2,
    nome: 'Campo de Futebol Americano',
    comprimento: 120.0,
    largura: 50.0,
    ocupado: false,
    descricao: 'Campo com marcações para futebol americano',
    ponto: mockPontos[2],
    idArrendador: 3,
    preco: 60.0, // Preço associado
    diasFuncionamento: {
      'Segunda-feira': [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 18, minute: 0)],
      'Sexta-feira': [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 18, minute: 0)],
    },
  ),
  CampoPub(
    id: 10,
    idPonto: 1,
    idMapa: 1,
    nome: 'Campo de Rugby',
    comprimento: 130.0,
    largura: 70.0,
    ocupado: true,
    descricao: 'Campo com marcações para rugby',
    ponto: mockPontos[0],
    entidadePublicaResp: "Câmara Municipal de Lisboa",
  ),
];

// Arrendadores
final List<Arrendador> mockArrendadores = [
  Arrendador(
    id: 1,
    nome: 'João Silva',
    email: 'joao.silva@example.com',
    numTele: 912345678,
    password: 'senha123',
    nacionalidade: 'Português',
    idade: 35,
    descricao: 'Arrendador experiente com vários campos disponíveis.',
    noCampos: 3,
    iban: 123456789,
    utilizador: 'joaosilva',
    createDate: DateTime.now(),
  )..adicionarMetodoPagamento('metodo1', 'Cartão de Crédito')
    ..adicionarMetodoPagamento('metodo2', 'MB Way'),

  Arrendador(
    id: 2,
    nome: 'Maria Oliveira',
    email: 'maria.oliveira@example.com',
    numTele: 913456789,
    password: 'senha456',
    nacionalidade: 'Brasileira',
    idade: 29,
    descricao: 'Especialista em gestão de campos desportivos.',
    noCampos: 2,
    iban: 987654321,
    utilizador: 'mariaoliveira',
    createDate: DateTime.now(),
  )..adicionarMetodoPagamento('metodo1', 'Transferência Bancária')
    ..adicionarMetodoPagamento('metodo2', 'Cartão de Débito'),

  Arrendador(
    id: 3,
    nome: 'Carlos Santos',
    email: 'carlos.santos@example.com',
    numTele: 914567890,
    password: 'senha789',
    nacionalidade: 'Angolano',
    idade: 42,
    descricao: 'Arrendador com experiência em eventos desportivos.',
    noCampos: 5,
    iban: 112233445,
    utilizador: 'carlossantos',
    createDate: DateTime.now(),
  )..adicionarMetodoPagamento('metodo1', 'Dinheiro')
    ..adicionarMetodoPagamento('metodo2', 'Cartão de Crédito'),

  Arrendador(
    id: 4,
    nome: 'Ana Costa',
    email: 'ana.costa@example.com',
    numTele: 915678901,
    password: 'senha321',
    nacionalidade: 'Moçambicana',
    idade: 37,
    descricao: 'Gestora de campos desportivos com foco em futebol.',
    noCampos: 4,
    iban: 556677889,
    utilizador: 'anacosta',
    createDate: DateTime.now(),
  )..adicionarMetodoPagamento('metodo1', 'MB Way')
    ..adicionarMetodoPagamento('metodo2', 'Transferência Bancária'),
];