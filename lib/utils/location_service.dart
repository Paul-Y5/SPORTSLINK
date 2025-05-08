import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  /// Obtém a localização atual do usuário.
  /// Retorna um [LatLng] com a latitude e longitude ou `null` se não for possível obter a localização.
  static Future<LatLng?> getCurrentLocation() async {
    try {
      // Solicitar permissão de localização
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        // Obter a posição atual
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        return LatLng(position.latitude, position.longitude);
      }
    } catch (e) {
      // Log de erro
      debugPrint('Erro ao obter localização: $e');
    }

    // Retorna `null` se não for possível obter a localização
    return null;
  }
}