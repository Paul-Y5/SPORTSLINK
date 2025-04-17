import 'package:weather_icons/weather_icons.dart';
import 'package:flutter/material.dart';

IconData getWeatherIcon(String weatherStatus) {
  // Mapeamento de palavras-chave para ícones
  final Map<String, IconData> weatherIcons = {
    'partly cloudy': WeatherIcons.day_cloudy,
    'fog': WeatherIcons.fog,
    'mist': WeatherIcons.fog,
    'haze': WeatherIcons.fog,
    'smoke': WeatherIcons.fog,
    'cloud': WeatherIcons.cloud,
    'rain': WeatherIcons.rain,
    'snow': WeatherIcons.snow,
    'thunderstorm': WeatherIcons.thunderstorm,
  };

  // Verifica se o clima é "clear" e retorna o ícone apropriado (dia/noite)
  if (weatherStatus.toLowerCase().contains('clear')) {
    return _getClearWeatherIcon();
  }

  // Procura a palavra-chave correspondente no mapeamento
  for (final entry in weatherIcons.entries) {
    if (weatherStatus.toLowerCase().contains(entry.key)) {
      return entry.value;
    }
  }

  // Retorna um ícone genérico se nenhuma condição for encontrada
  return WeatherIcons.na;
}

// Função auxiliar para determinar o ícone de "clear" com base no horário
IconData _getClearWeatherIcon() {
  final int hour = DateTime.now().hour;
  if (hour >= 6 && hour < 18) {
    return WeatherIcons.day_sunny; // Ícone para clima ensolarado durante o dia
  } else {
    return WeatherIcons.night_clear; // Ícone para clima limpo à noite
  }
}