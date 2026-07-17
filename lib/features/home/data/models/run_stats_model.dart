import '../../domain/entities/run_stats_entity.dart';

/// Model da camada data: estende a entidade e adiciona serialização JSON.
/// Pronto para integrar com uma API REST ou Firestore no futuro.
class RunStatsModel extends RunStatsEntity {
  const RunStatsModel({
    required super.treesPlanted,
    required super.distanceKm,
    required super.progressPercent,
    required super.weatherTemp,
    required super.weatherCondition,
  });

  /// Cria um [RunStatsModel] a partir de um mapa JSON.
  factory RunStatsModel.fromJson(Map<String, dynamic> json) {
    return RunStatsModel(
      treesPlanted: (json['trees_planted'] as num).toInt(),
      distanceKm: (json['distance_km'] as num).toDouble(),
      progressPercent: (json['progress_percent'] as num).toDouble(),
      weatherTemp: (json['weather_temp'] as num).toInt(),
      weatherCondition: json['weather_condition'] as String,
    );
  }

  /// Serializa o model para JSON.
  Map<String, dynamic> toJson() => {
        'trees_planted': treesPlanted,
        'distance_km': distanceKm,
        'progress_percent': progressPercent,
        'weather_temp': weatherTemp,
        'weather_condition': weatherCondition,
      };
}
