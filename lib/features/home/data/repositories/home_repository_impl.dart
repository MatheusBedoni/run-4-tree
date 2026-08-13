import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

import '../../../../core/services/weather_service.dart';
import '../../domain/entities/run_stats_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../models/run_stats_model.dart';

/// Implementação concreta do [HomeRepository].
///
/// O clima é obtido em tempo real via [WeatherService] (OpenWeatherMap),
/// usando a localização atual do dispositivo. Árvores plantadas, distância
/// e progresso continuam mockados até a API correspondente estar pronta.
class HomeRepositoryImpl implements HomeRepository {
  final WeatherService _weatherService;

  const HomeRepositoryImpl({
    WeatherService weatherService = const WeatherService(),
  }) : _weatherService = weatherService;

  @override
  Future<RunStatsEntity> getRunStats() async {
    final weather = await _fetchWeather();

    return RunStatsModel(
      treesPlanted: 0,
      distanceKm: 0,
      progressPercent: 0,
      weatherTemp: weather?.temperature?.celsius?.round() ?? 0,
      weatherCondition: _weatherService.mapCondition(weather?.weatherMain),
    );
  }

  Future<Weather?> _fetchWeather() async {
    try {
      final position = await _getCurrentPosition();
      if (position == null) return null;

      return await _weatherService.getCurrentWeather(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      debugPrint('HomeRepositoryImpl._fetchWeather error: $e');
      return null;
    }
  }

  Future<Position?> _getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );
  }
}
