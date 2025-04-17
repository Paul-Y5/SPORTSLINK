import 'package:flutter/material.dart';
import 'package:sports_link/models/ponto.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/models/campo_pub.dart';
import 'package:sports_link/models/campo.dart';

// PONTOS
final List<Ponto> mockPontos = [
  Ponto(id: 1, idMapa: 1, latitude: 38.7169, longitude: -9.1399), // Lisboa
  Ponto(id: 2, idMapa: 1, latitude: 41.1496, longitude: -8.6109), // Porto
  Ponto(id: 3, idMapa: 2, latitude: 40.6405, longitude: -8.6538), // Aveiro
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
    imagem: Image.network('https://example.com/campo_grande.png'),
    idArrendador: 3,
    preco: 50.0, // Preço associado
    diasFuncionamento: [
      'Segunda-feira',
      'Quarta-feira',
      'Sexta-feira',
    ], // Dias de funcionamento
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
    imagem: Image.network('https://example.com/campo_universitario.png'),
    idArrendador: 3,
    preco: 45.0, // Preço associado
    diasFuncionamento: ['Terça-feira', 'Quinta-feira'], // Dias de funcionamento
  ),
  CampoPub(
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
    imagem: Image.network('https://example.com/campo_futsal.png'),
    preco: 35.0, // Preço associado
    diasFuncionamento: ['Segunda-feira', 'Quarta-feira'],
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
    imagem: Image.network('https://example.com/campo_praia.png'),
    idArrendador: 3,
    preco: 40.0, // Preço associado
    diasFuncionamento: ['Sexta-feira', 'Sábado'],
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
    imagem: Image.network('https://example.com/campo_treino.png'),
    preco: 30.0, // Preço associado
    diasFuncionamento: ['Terça-feira', 'Quinta-feira'],
  ),
  CampoPub(
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
    imagem: Image.network('https://example.com/campo_futebol_americano.png'),
    preco: 60.0, // Preço associado
    diasFuncionamento: ['Segunda-feira', 'Sexta-feira'],
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
