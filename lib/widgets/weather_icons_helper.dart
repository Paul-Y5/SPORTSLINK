import 'package:weather_icons/weather_icons.dart';
import 'package:flutter/material.dart';

IconData getWeatherIcon(String weatherStatus) {
  if (weatherStatus.toLowerCase().contains('clear')) {
    return WeatherIcons.day_sunny; // Ícone para clima ensolarado
  } else if (weatherStatus.toLowerCase().contains('cloud')) {
    return WeatherIcons.cloud; // Ícone para clima nublado
  } else if (weatherStatus.toLowerCase().contains('rain')) {
    return WeatherIcons.rain; // Ícone para chuva
  } else if (weatherStatus.toLowerCase().contains('snow')) {
    return WeatherIcons.snow; // Ícone para neve
  } else if (weatherStatus.toLowerCase().contains('thunderstorm')) {
    return WeatherIcons.thunderstorm; // Ícone para tempestade
  } else {
    return WeatherIcons.na; // Ícone genérico para condições desconhecidas
  }
}