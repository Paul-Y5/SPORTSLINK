import 'package:flutter/material.dart';
import 'package:sports_link/widgets/weather_icons_helper.dart';

class WeatherInfo extends StatelessWidget {
  final String city;
  final String weatherStatus;
  final String weatherFeedback;

  const WeatherInfo({
    super.key,
    required this.city,
    required this.weatherStatus,
    required this.weatherFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(128, 0, 0, 0), // Fundo com transparência
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(getWeatherIcon(weatherStatus), color: Colors.white, size: 50),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📍 $city — $weatherStatus',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weatherFeedback,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}