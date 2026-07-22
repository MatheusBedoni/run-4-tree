import '../../domain/entities/exercise_entity.dart';

class ExerciseModel extends ExerciseEntity {
  const ExerciseModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    super.durationInMinutes,
    super.caloriesBurned,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      durationInMinutes: json['durationInMinutes'] as int?,
      caloriesBurned: (json['caloriesBurned'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'durationInMinutes': durationInMinutes,
      'caloriesBurned': caloriesBurned,
    };
  }
}
