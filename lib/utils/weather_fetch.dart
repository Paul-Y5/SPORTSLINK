import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WeatherFetch {
  static const String apiKey = 'bc35b345b195561b94ded97bb766a4a1';

  Future<String> getCityFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      // Usa o pacote geocoding para obter o nome da cidade
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality ?? 'Cidade não encontrada';
      } else {
        return 'Cidade não encontrada';
      }
    } catch (e) {
      return 'Erro ao obter cidade';
    }
  }

  Future<Map<String, String>> fetchWeather(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final weather = data['weather'][0]['description'];
        final temp = data['main']['temp'];
        final wind = data['wind']['speed'];

        String weatherStatus =
            '${temp.toStringAsFixed(0)}°C, ${weather[0].toUpperCase()}${weather.substring(1)}';
        String weatherFeedback;

        if ((temp > 15 && temp < 35) &&
            (weather.contains('clear') || weather.contains('cloud')) &&
            wind < 8) {
          weatherFeedback = '✅ Está ótimo para jogar ao ar livre!';
        } else {
          weatherFeedback =
              '⚠️ Hoje talvez seja melhor jogar num local coberto.';
        }

        return {
          'weatherStatus': weatherStatus,
          'weatherFeedback': weatherFeedback,
          'city': city, // Inclua o nome da cidade
        };
      } else {
        return {
          'weatherStatus': 'Erro ao carregar tempo',
          'weatherFeedback': '',
        };
      }
    } catch (e) {
      return {'weatherStatus': 'Erro de conexão', 'weatherFeedback': ''};
    }
  }

  Future<Map<String, String>> getLocationAndFetchWeather() async {
    try {
      // Solicita permissão de localização
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return {
          'weatherStatus': 'Permissão de localização negada.',
          'weatherFeedback': '⚠️ Não foi possível obter a localização.',
        };
      }

      // Obtém a localização atual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high, // Define a precisão desejada
      );

      // Converte as coordenadas em uma cidade
      String city = await getCityFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Busca o clima para a cidade obtida
      return await fetchWeather(city);
    } catch (e) {
      return {
        'weatherStatus': 'Erro ao obter localização.',
        'weatherFeedback': '⚠️ Não foi possível determinar o clima.',
      };
    }
  }
}
