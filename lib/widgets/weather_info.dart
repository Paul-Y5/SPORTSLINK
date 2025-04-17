import 'package:flutter/material.dart';
import 'package:sports_link/models/utilizador.dart';
import 'package:sports_link/widgets/weather_icons_helper.dart';

class WeatherInfo extends StatelessWidget {
  final Utilizador currentUser;
  final String city;
  final String weatherStatus;
  final String weatherFeedback;

  const WeatherInfo({
    super.key,
    required this.currentUser,
    required this.city,
    required this.weatherStatus,
    required this.weatherFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 25.0),
      child: Container(
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(128, 0, 0, 0), // Fundo com transparência
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mensagem de boas-vindas centralizada
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Olá, ',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: currentUser.nome,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Linha com ícone + clima
            Row(
              children: [
                Icon(
                  getWeatherIcon(weatherStatus),
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📍 $city — $weatherStatus',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weatherFeedback,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}