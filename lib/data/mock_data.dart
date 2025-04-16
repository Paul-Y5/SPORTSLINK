import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/models/campo_pub.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/models/mapa.dart';
import 'package:sports_link/models/ponto.dart';

/// MAPAS
final List<Mapa> mockMapas = [
  Mapa(id: 1, ultimoUpdate: DateTime.now().subtract(Duration(days: 1))),
  Mapa(id: 2, ultimoUpdate: DateTime.now().subtract(Duration(days: 2))),
];

/// PONTOS
final List<Ponto> mockPontos = [
  Ponto(id: 1, idMapa: 1, latitude: 38.7169, longitude: -9.1399), // Lisboa
  Ponto(id: 2, idMapa: 1, latitude: 41.1496, longitude: -8.6109), // Porto
  Ponto(id: 3, idMapa: 2, latitude: 40.6405, longitude: -8.6538), // Aveiro
];

/// JOGADORES
final List<Jogador> mockJogadores = [
  Jogador(
    id: 1,
    nome: 'Rui Silva',
    email: 'rui@gmail.com',
    numTele: 912345678,
    password: '123456',
    nacionalidade: 'Português',
    idade: 25,
    descricao: 'Médio ofensivo com boa visão de jogo',
    utilizador: 'rui25',
    createDate: DateTime.now().subtract(Duration(days: 15)),
  ),
  Jogador(
    id: 2,
    nome: 'Ana Costa',
    email: 'ana.costa@gmail.com',
    numTele: 934567891,
    password: 'abc123',
    nacionalidade: 'Portuguesa',
    idade: 22,
    descricao: 'Guarda-redes com reflexos rápidos',
    utilizador: 'ana22',
    createDate: DateTime.now().subtract(Duration(days: 5)),
  ),
];

/// ARRENDADORES
final List<Arrendador> mockArrendadores = [
  Arrendador(
    id: 3,
    nome: 'João Campos',
    email: 'joao.campos@gmail.com',
    numTele: 913456789,
    password: 'campo123',
    nacionalidade: 'Português',
    idade: 38,
    descricao: 'Gestor de campos em Lisboa',
    utilizador: 'joao38',
    createDate: DateTime.now().subtract(Duration(days: 30)),
    noCampos: 2,
    iban: 123456789,
  ),
  Arrendador(
    id: 4,
    nome: 'Marta Ferreira',
    email: 'marta.ferreira@gmail.com',
    numTele: 926789123,
    password: 'ferreira22',
    nacionalidade: 'Portuguesa',
    idade: 31,
    descricao: 'Responsável pelo campo municipal do Porto',
    utilizador: 'marta31',
    createDate: DateTime.now().subtract(Duration(days: 10)),
    noCampos: 1,
    iban: 987654321,
  ),
];

/// CAMPOS
final List<Campo> mockCampos = [
  CampoPriv (
    id: 1,
    idPonto: 1,
    idMapa: 1,
    nome: 'Campo Grande',
    comprimento: 100.0,
    largura: 60.0,
    ocupado: false,
    descricao: 'Relvado sintético, ideal para 11x11',
    ponto: mockPontos[0],

    idArrendador: 3,
  ),
  CampoPub (
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
  CampoPriv (
    id: 3,
    idPonto: 3,
    idMapa: 2,
    nome: 'Campo Universitário',
    comprimento: 80.0,
    largura: 50.0,
    ocupado: false,
    descricao: 'Muito procurado por estudantes',
    ponto: mockPontos[2],

    idArrendador: 3,
  ),

  CampoPub (
    id: 4,
    idPonto: 1,
    idMapa: 1,
    nome: 'Campo Municipal',
    comprimento: 110.0,
    largura: 70.0,
    ocupado: true,
    descricao: 'Campo com iluminação noturna',
    ponto: mockPontos[0],

    entidadePublicaResp: "Câmara Municipal",
  ),

  CampoPriv (
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
  ),

  CampoPub (
    id: 6,
    idPonto: 3,
    idMapa: 2,
    nome: 'Campo de Praia',
    comprimento: 50.0,
    largura: 30.0,
    ocupado: true,
    descricao: 'Campo de areia, ideal para futebol de praia',
    ponto: mockPontos[2],

    entidadePublicaResp: "Câmara Municipal de Aveiro",
  ),

  CampoPriv (
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

  CampoPriv (
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
  ),

  CampoPub (
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
