import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../models/exercise_model.dart';
import 'exercise_local_datasource.dart';

class ExerciseLocalDataSourceImpl implements ExerciseLocalDataSource {
  final DatabaseHelper databaseHelper;

  ExerciseLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> cacheExercise(ExerciseModel exercise) async {
    final db = await databaseHelper.database;
    await db.insert(
      'exercises',
      exercise.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<ExerciseModel>> getCachedExercises() async {
    final db = await databaseHelper.database;
    final maps = await db.query('exercises');

    if (maps.isNotEmpty) {
      return maps.map((map) => ExerciseModel.fromJson(map)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> deleteExercise(String id) async {
    final db = await databaseHelper.database;
    await db.delete(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
