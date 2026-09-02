// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RunSessionsTable extends RunSessions
    with TableInfo<$RunSessionsTable, RunSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RunSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _distanceKmMeta = const VerificationMeta(
    'distanceKm',
  );
  @override
  late final GeneratedColumn<double> distanceKm = GeneratedColumn<double>(
    'distance_km',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _averageSpeedMeta = const VerificationMeta(
    'averageSpeed',
  );
  @override
  late final GeneratedColumn<double> averageSpeed = GeneratedColumn<double>(
    'average_speed',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _maxSpeedMeta = const VerificationMeta(
    'maxSpeed',
  );
  @override
  late final GeneratedColumn<double> maxSpeed = GeneratedColumn<double>(
    'max_speed',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _paceMeta = const VerificationMeta('pace');
  @override
  late final GeneratedColumn<double> pace = GeneratedColumn<double>(
    'pace',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _polylineMeta = const VerificationMeta(
    'polyline',
  );
  @override
  late final GeneratedColumn<String> polyline = GeneratedColumn<String>(
    'polyline',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<String> temperature = GeneratedColumn<String>(
    'temperature',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isNightMeta = const VerificationMeta(
    'isNight',
  );
  @override
  late final GeneratedColumn<bool> isNight = GeneratedColumn<bool>(
    'is_night',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_night" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _treesEarnedMeta = const VerificationMeta(
    'treesEarned',
  );
  @override
  late final GeneratedColumn<int> treesEarned = GeneratedColumn<int>(
    'trees_earned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _exerciseTypeMeta = const VerificationMeta(
    'exerciseType',
  );
  @override
  late final GeneratedColumn<String> exerciseType = GeneratedColumn<String>(
    'exercise_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('run'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    durationSeconds,
    distanceKm,
    calories,
    averageSpeed,
    maxSpeed,
    pace,
    polyline,
    temperature,
    isNight,
    treesEarned,
    exerciseType,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'run_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RunSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('distance_km')) {
      context.handle(
        _distanceKmMeta,
        distanceKm.isAcceptableOrUnknown(data['distance_km']!, _distanceKmMeta),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('average_speed')) {
      context.handle(
        _averageSpeedMeta,
        averageSpeed.isAcceptableOrUnknown(
          data['average_speed']!,
          _averageSpeedMeta,
        ),
      );
    }
    if (data.containsKey('max_speed')) {
      context.handle(
        _maxSpeedMeta,
        maxSpeed.isAcceptableOrUnknown(data['max_speed']!, _maxSpeedMeta),
      );
    }
    if (data.containsKey('pace')) {
      context.handle(
        _paceMeta,
        pace.isAcceptableOrUnknown(data['pace']!, _paceMeta),
      );
    }
    if (data.containsKey('polyline')) {
      context.handle(
        _polylineMeta,
        polyline.isAcceptableOrUnknown(data['polyline']!, _polylineMeta),
      );
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    }
    if (data.containsKey('is_night')) {
      context.handle(
        _isNightMeta,
        isNight.isAcceptableOrUnknown(data['is_night']!, _isNightMeta),
      );
    }
    if (data.containsKey('trees_earned')) {
      context.handle(
        _treesEarnedMeta,
        treesEarned.isAcceptableOrUnknown(
          data['trees_earned']!,
          _treesEarnedMeta,
        ),
      );
    }
    if (data.containsKey('exercise_type')) {
      context.handle(
        _exerciseTypeMeta,
        exerciseType.isAcceptableOrUnknown(
          data['exercise_type']!,
          _exerciseTypeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RunSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RunSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      distanceKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_km'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      averageSpeed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}average_speed'],
      )!,
      maxSpeed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_speed'],
      )!,
      pace: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pace'],
      )!,
      polyline: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}polyline'],
      )!,
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temperature'],
      ),
      isNight: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_night'],
      )!,
      treesEarned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trees_earned'],
      )!,
      exerciseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RunSessionsTable createAlias(String alias) {
    return $RunSessionsTable(attachedDatabase, alias);
  }
}

class RunSession extends DataClass implements Insertable<RunSession> {
  /// Identificador único, autoincrement.
  final int id;

  /// Duração total da sessão em segundos.
  final int durationSeconds;

  /// Distância percorrida em quilômetros.
  final double distanceKm;

  /// Calorias estimadas queimadas.
  final double calories;

  /// Velocidade média em km/h.
  final double averageSpeed;

  /// Velocidade máxima atingida em km/h.
  final double maxSpeed;

  /// Ritmo (min/km).
  final double pace;

  /// Polyline serializada como JSON string (List<List<double>>).
  final String polyline;

  /// Temperatura no momento da corrida (ex: "25°C").
  final String? temperature;

  /// Se a corrida foi noturna.
  final bool isNight;

  /// Quantidade de árvores ganhas nessa corrida.
  final int treesEarned;

  /// Tipo de exercício: "run", "walk" ou "bike".
  final String exerciseType;

  /// Data e hora de criação da sessão.
  final DateTime createdAt;
  const RunSession({
    required this.id,
    required this.durationSeconds,
    required this.distanceKm,
    required this.calories,
    required this.averageSpeed,
    required this.maxSpeed,
    required this.pace,
    required this.polyline,
    this.temperature,
    required this.isNight,
    required this.treesEarned,
    required this.exerciseType,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['distance_km'] = Variable<double>(distanceKm);
    map['calories'] = Variable<double>(calories);
    map['average_speed'] = Variable<double>(averageSpeed);
    map['max_speed'] = Variable<double>(maxSpeed);
    map['pace'] = Variable<double>(pace);
    map['polyline'] = Variable<String>(polyline);
    if (!nullToAbsent || temperature != null) {
      map['temperature'] = Variable<String>(temperature);
    }
    map['is_night'] = Variable<bool>(isNight);
    map['trees_earned'] = Variable<int>(treesEarned);
    map['exercise_type'] = Variable<String>(exerciseType);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RunSessionsCompanion toCompanion(bool nullToAbsent) {
    return RunSessionsCompanion(
      id: Value(id),
      durationSeconds: Value(durationSeconds),
      distanceKm: Value(distanceKm),
      calories: Value(calories),
      averageSpeed: Value(averageSpeed),
      maxSpeed: Value(maxSpeed),
      pace: Value(pace),
      polyline: Value(polyline),
      temperature: temperature == null && nullToAbsent
          ? const Value.absent()
          : Value(temperature),
      isNight: Value(isNight),
      treesEarned: Value(treesEarned),
      exerciseType: Value(exerciseType),
      createdAt: Value(createdAt),
    );
  }

  factory RunSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RunSession(
      id: serializer.fromJson<int>(json['id']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      distanceKm: serializer.fromJson<double>(json['distanceKm']),
      calories: serializer.fromJson<double>(json['calories']),
      averageSpeed: serializer.fromJson<double>(json['averageSpeed']),
      maxSpeed: serializer.fromJson<double>(json['maxSpeed']),
      pace: serializer.fromJson<double>(json['pace']),
      polyline: serializer.fromJson<String>(json['polyline']),
      temperature: serializer.fromJson<String?>(json['temperature']),
      isNight: serializer.fromJson<bool>(json['isNight']),
      treesEarned: serializer.fromJson<int>(json['treesEarned']),
      exerciseType: serializer.fromJson<String>(json['exerciseType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'distanceKm': serializer.toJson<double>(distanceKm),
      'calories': serializer.toJson<double>(calories),
      'averageSpeed': serializer.toJson<double>(averageSpeed),
      'maxSpeed': serializer.toJson<double>(maxSpeed),
      'pace': serializer.toJson<double>(pace),
      'polyline': serializer.toJson<String>(polyline),
      'temperature': serializer.toJson<String?>(temperature),
      'isNight': serializer.toJson<bool>(isNight),
      'treesEarned': serializer.toJson<int>(treesEarned),
      'exerciseType': serializer.toJson<String>(exerciseType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RunSession copyWith({
    int? id,
    int? durationSeconds,
    double? distanceKm,
    double? calories,
    double? averageSpeed,
    double? maxSpeed,
    double? pace,
    String? polyline,
    Value<String?> temperature = const Value.absent(),
    bool? isNight,
    int? treesEarned,
    String? exerciseType,
    DateTime? createdAt,
  }) => RunSession(
    id: id ?? this.id,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    distanceKm: distanceKm ?? this.distanceKm,
    calories: calories ?? this.calories,
    averageSpeed: averageSpeed ?? this.averageSpeed,
    maxSpeed: maxSpeed ?? this.maxSpeed,
    pace: pace ?? this.pace,
    polyline: polyline ?? this.polyline,
    temperature: temperature.present ? temperature.value : this.temperature,
    isNight: isNight ?? this.isNight,
    treesEarned: treesEarned ?? this.treesEarned,
    exerciseType: exerciseType ?? this.exerciseType,
    createdAt: createdAt ?? this.createdAt,
  );
  RunSession copyWithCompanion(RunSessionsCompanion data) {
    return RunSession(
      id: data.id.present ? data.id.value : this.id,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      distanceKm: data.distanceKm.present
          ? data.distanceKm.value
          : this.distanceKm,
      calories: data.calories.present ? data.calories.value : this.calories,
      averageSpeed: data.averageSpeed.present
          ? data.averageSpeed.value
          : this.averageSpeed,
      maxSpeed: data.maxSpeed.present ? data.maxSpeed.value : this.maxSpeed,
      pace: data.pace.present ? data.pace.value : this.pace,
      polyline: data.polyline.present ? data.polyline.value : this.polyline,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      isNight: data.isNight.present ? data.isNight.value : this.isNight,
      treesEarned: data.treesEarned.present
          ? data.treesEarned.value
          : this.treesEarned,
      exerciseType: data.exerciseType.present
          ? data.exerciseType.value
          : this.exerciseType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RunSession(')
          ..write('id: $id, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('calories: $calories, ')
          ..write('averageSpeed: $averageSpeed, ')
          ..write('maxSpeed: $maxSpeed, ')
          ..write('pace: $pace, ')
          ..write('polyline: $polyline, ')
          ..write('temperature: $temperature, ')
          ..write('isNight: $isNight, ')
          ..write('treesEarned: $treesEarned, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    durationSeconds,
    distanceKm,
    calories,
    averageSpeed,
    maxSpeed,
    pace,
    polyline,
    temperature,
    isNight,
    treesEarned,
    exerciseType,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RunSession &&
          other.id == this.id &&
          other.durationSeconds == this.durationSeconds &&
          other.distanceKm == this.distanceKm &&
          other.calories == this.calories &&
          other.averageSpeed == this.averageSpeed &&
          other.maxSpeed == this.maxSpeed &&
          other.pace == this.pace &&
          other.polyline == this.polyline &&
          other.temperature == this.temperature &&
          other.isNight == this.isNight &&
          other.treesEarned == this.treesEarned &&
          other.exerciseType == this.exerciseType &&
          other.createdAt == this.createdAt);
}

class RunSessionsCompanion extends UpdateCompanion<RunSession> {
  final Value<int> id;
  final Value<int> durationSeconds;
  final Value<double> distanceKm;
  final Value<double> calories;
  final Value<double> averageSpeed;
  final Value<double> maxSpeed;
  final Value<double> pace;
  final Value<String> polyline;
  final Value<String?> temperature;
  final Value<bool> isNight;
  final Value<int> treesEarned;
  final Value<String> exerciseType;
  final Value<DateTime> createdAt;
  const RunSessionsCompanion({
    this.id = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.calories = const Value.absent(),
    this.averageSpeed = const Value.absent(),
    this.maxSpeed = const Value.absent(),
    this.pace = const Value.absent(),
    this.polyline = const Value.absent(),
    this.temperature = const Value.absent(),
    this.isNight = const Value.absent(),
    this.treesEarned = const Value.absent(),
    this.exerciseType = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RunSessionsCompanion.insert({
    this.id = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.calories = const Value.absent(),
    this.averageSpeed = const Value.absent(),
    this.maxSpeed = const Value.absent(),
    this.pace = const Value.absent(),
    this.polyline = const Value.absent(),
    this.temperature = const Value.absent(),
    this.isNight = const Value.absent(),
    this.treesEarned = const Value.absent(),
    this.exerciseType = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<RunSession> custom({
    Expression<int>? id,
    Expression<int>? durationSeconds,
    Expression<double>? distanceKm,
    Expression<double>? calories,
    Expression<double>? averageSpeed,
    Expression<double>? maxSpeed,
    Expression<double>? pace,
    Expression<String>? polyline,
    Expression<String>? temperature,
    Expression<bool>? isNight,
    Expression<int>? treesEarned,
    Expression<String>? exerciseType,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (distanceKm != null) 'distance_km': distanceKm,
      if (calories != null) 'calories': calories,
      if (averageSpeed != null) 'average_speed': averageSpeed,
      if (maxSpeed != null) 'max_speed': maxSpeed,
      if (pace != null) 'pace': pace,
      if (polyline != null) 'polyline': polyline,
      if (temperature != null) 'temperature': temperature,
      if (isNight != null) 'is_night': isNight,
      if (treesEarned != null) 'trees_earned': treesEarned,
      if (exerciseType != null) 'exercise_type': exerciseType,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RunSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? durationSeconds,
    Value<double>? distanceKm,
    Value<double>? calories,
    Value<double>? averageSpeed,
    Value<double>? maxSpeed,
    Value<double>? pace,
    Value<String>? polyline,
    Value<String?>? temperature,
    Value<bool>? isNight,
    Value<int>? treesEarned,
    Value<String>? exerciseType,
    Value<DateTime>? createdAt,
  }) {
    return RunSessionsCompanion(
      id: id ?? this.id,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      distanceKm: distanceKm ?? this.distanceKm,
      calories: calories ?? this.calories,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      pace: pace ?? this.pace,
      polyline: polyline ?? this.polyline,
      temperature: temperature ?? this.temperature,
      isNight: isNight ?? this.isNight,
      treesEarned: treesEarned ?? this.treesEarned,
      exerciseType: exerciseType ?? this.exerciseType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (distanceKm.present) {
      map['distance_km'] = Variable<double>(distanceKm.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (averageSpeed.present) {
      map['average_speed'] = Variable<double>(averageSpeed.value);
    }
    if (maxSpeed.present) {
      map['max_speed'] = Variable<double>(maxSpeed.value);
    }
    if (pace.present) {
      map['pace'] = Variable<double>(pace.value);
    }
    if (polyline.present) {
      map['polyline'] = Variable<String>(polyline.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<String>(temperature.value);
    }
    if (isNight.present) {
      map['is_night'] = Variable<bool>(isNight.value);
    }
    if (treesEarned.present) {
      map['trees_earned'] = Variable<int>(treesEarned.value);
    }
    if (exerciseType.present) {
      map['exercise_type'] = Variable<String>(exerciseType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RunSessionsCompanion(')
          ..write('id: $id, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('calories: $calories, ')
          ..write('averageSpeed: $averageSpeed, ')
          ..write('maxSpeed: $maxSpeed, ')
          ..write('pace: $pace, ')
          ..write('polyline: $polyline, ')
          ..write('temperature: $temperature, ')
          ..write('isNight: $isNight, ')
          ..write('treesEarned: $treesEarned, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationInMinutesMeta = const VerificationMeta(
    'durationInMinutes',
  );
  @override
  late final GeneratedColumn<int> durationInMinutes = GeneratedColumn<int>(
    'duration_in_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caloriesBurnedMeta = const VerificationMeta(
    'caloriesBurned',
  );
  @override
  late final GeneratedColumn<double> caloriesBurned = GeneratedColumn<double>(
    'calories_burned',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    category,
    durationInMinutes,
    caloriesBurned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('duration_in_minutes')) {
      context.handle(
        _durationInMinutesMeta,
        durationInMinutes.isAcceptableOrUnknown(
          data['duration_in_minutes']!,
          _durationInMinutesMeta,
        ),
      );
    }
    if (data.containsKey('calories_burned')) {
      context.handle(
        _caloriesBurnedMeta,
        caloriesBurned.isAcceptableOrUnknown(
          data['calories_burned']!,
          _caloriesBurnedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      durationInMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_in_minutes'],
      ),
      caloriesBurned: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories_burned'],
      ),
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  /// Identificador do exercício (UUID vindo da API ou gerado local).
  final String id;

  /// Nome do exercício.
  final String name;

  /// Descrição do exercício.
  final String description;

  /// Categoria (ex: "cardio", "força").
  final String category;

  /// Duração em minutos (opcional).
  final int? durationInMinutes;

  /// Calorias queimadas (opcional).
  final double? caloriesBurned;
  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.durationInMinutes,
    this.caloriesBurned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || durationInMinutes != null) {
      map['duration_in_minutes'] = Variable<int>(durationInMinutes);
    }
    if (!nullToAbsent || caloriesBurned != null) {
      map['calories_burned'] = Variable<double>(caloriesBurned);
    }
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      category: Value(category),
      durationInMinutes: durationInMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationInMinutes),
      caloriesBurned: caloriesBurned == null && nullToAbsent
          ? const Value.absent()
          : Value(caloriesBurned),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      durationInMinutes: serializer.fromJson<int?>(json['durationInMinutes']),
      caloriesBurned: serializer.fromJson<double?>(json['caloriesBurned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'durationInMinutes': serializer.toJson<int?>(durationInMinutes),
      'caloriesBurned': serializer.toJson<double?>(caloriesBurned),
    };
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    Value<int?> durationInMinutes = const Value.absent(),
    Value<double?> caloriesBurned = const Value.absent(),
  }) => Exercise(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    category: category ?? this.category,
    durationInMinutes: durationInMinutes.present
        ? durationInMinutes.value
        : this.durationInMinutes,
    caloriesBurned: caloriesBurned.present
        ? caloriesBurned.value
        : this.caloriesBurned,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      durationInMinutes: data.durationInMinutes.present
          ? data.durationInMinutes.value
          : this.durationInMinutes,
      caloriesBurned: data.caloriesBurned.present
          ? data.caloriesBurned.value
          : this.caloriesBurned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('durationInMinutes: $durationInMinutes, ')
          ..write('caloriesBurned: $caloriesBurned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    category,
    durationInMinutes,
    caloriesBurned,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.category == this.category &&
          other.durationInMinutes == this.durationInMinutes &&
          other.caloriesBurned == this.caloriesBurned);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> category;
  final Value<int?> durationInMinutes;
  final Value<double?> caloriesBurned;
  final Value<int> rowid;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.durationInMinutes = const Value.absent(),
    this.caloriesBurned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesCompanion.insert({
    required String id,
    required String name,
    required String description,
    required String category,
    this.durationInMinutes = const Value.absent(),
    this.caloriesBurned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       description = Value(description),
       category = Value(category);
  static Insertable<Exercise> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? category,
    Expression<int>? durationInMinutes,
    Expression<double>? caloriesBurned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (durationInMinutes != null) 'duration_in_minutes': durationInMinutes,
      if (caloriesBurned != null) 'calories_burned': caloriesBurned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String>? category,
    Value<int?>? durationInMinutes,
    Value<double?>? caloriesBurned,
    Value<int>? rowid,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      durationInMinutes: durationInMinutes ?? this.durationInMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (durationInMinutes.present) {
      map['duration_in_minutes'] = Variable<int>(durationInMinutes.value);
    }
    if (caloriesBurned.present) {
      map['calories_burned'] = Variable<double>(caloriesBurned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('durationInMinutes: $durationInMinutes, ')
          ..write('caloriesBurned: $caloriesBurned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TreeProgressTable extends TreeProgress
    with TableInfo<$TreeProgressTable, TreeProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TreeProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _revenueAccumulatedUsdMeta =
      const VerificationMeta('revenueAccumulatedUsd');
  @override
  late final GeneratedColumn<double> revenueAccumulatedUsd =
      GeneratedColumn<double>(
        'revenue_accumulated_usd',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _treesPlantedMeta = const VerificationMeta(
    'treesPlanted',
  );
  @override
  late final GeneratedColumn<int> treesPlanted = GeneratedColumn<int>(
    'trees_planted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    revenueAccumulatedUsd,
    treesPlanted,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tree_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<TreeProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('revenue_accumulated_usd')) {
      context.handle(
        _revenueAccumulatedUsdMeta,
        revenueAccumulatedUsd.isAcceptableOrUnknown(
          data['revenue_accumulated_usd']!,
          _revenueAccumulatedUsdMeta,
        ),
      );
    }
    if (data.containsKey('trees_planted')) {
      context.handle(
        _treesPlantedMeta,
        treesPlanted.isAcceptableOrUnknown(
          data['trees_planted']!,
          _treesPlantedMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TreeProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TreeProgressData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      revenueAccumulatedUsd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}revenue_accumulated_usd'],
      )!,
      treesPlanted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trees_planted'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TreeProgressTable createAlias(String alias) {
    return $TreeProgressTable(attachedDatabase, alias);
  }
}

class TreeProgressData extends DataClass
    implements Insertable<TreeProgressData> {
  final int id;

  /// Receita de anúncios (USD) acumulada, ainda não convertida em árvore.
  final double revenueAccumulatedUsd;

  /// Total de árvores plantadas via Tree-Nation a partir de anúncios.
  final int treesPlanted;
  final DateTime updatedAt;
  const TreeProgressData({
    required this.id,
    required this.revenueAccumulatedUsd,
    required this.treesPlanted,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['revenue_accumulated_usd'] = Variable<double>(revenueAccumulatedUsd);
    map['trees_planted'] = Variable<int>(treesPlanted);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TreeProgressCompanion toCompanion(bool nullToAbsent) {
    return TreeProgressCompanion(
      id: Value(id),
      revenueAccumulatedUsd: Value(revenueAccumulatedUsd),
      treesPlanted: Value(treesPlanted),
      updatedAt: Value(updatedAt),
    );
  }

  factory TreeProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TreeProgressData(
      id: serializer.fromJson<int>(json['id']),
      revenueAccumulatedUsd: serializer.fromJson<double>(
        json['revenueAccumulatedUsd'],
      ),
      treesPlanted: serializer.fromJson<int>(json['treesPlanted']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'revenueAccumulatedUsd': serializer.toJson<double>(revenueAccumulatedUsd),
      'treesPlanted': serializer.toJson<int>(treesPlanted),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TreeProgressData copyWith({
    int? id,
    double? revenueAccumulatedUsd,
    int? treesPlanted,
    DateTime? updatedAt,
  }) => TreeProgressData(
    id: id ?? this.id,
    revenueAccumulatedUsd: revenueAccumulatedUsd ?? this.revenueAccumulatedUsd,
    treesPlanted: treesPlanted ?? this.treesPlanted,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TreeProgressData copyWithCompanion(TreeProgressCompanion data) {
    return TreeProgressData(
      id: data.id.present ? data.id.value : this.id,
      revenueAccumulatedUsd: data.revenueAccumulatedUsd.present
          ? data.revenueAccumulatedUsd.value
          : this.revenueAccumulatedUsd,
      treesPlanted: data.treesPlanted.present
          ? data.treesPlanted.value
          : this.treesPlanted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TreeProgressData(')
          ..write('id: $id, ')
          ..write('revenueAccumulatedUsd: $revenueAccumulatedUsd, ')
          ..write('treesPlanted: $treesPlanted, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, revenueAccumulatedUsd, treesPlanted, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TreeProgressData &&
          other.id == this.id &&
          other.revenueAccumulatedUsd == this.revenueAccumulatedUsd &&
          other.treesPlanted == this.treesPlanted &&
          other.updatedAt == this.updatedAt);
}

class TreeProgressCompanion extends UpdateCompanion<TreeProgressData> {
  final Value<int> id;
  final Value<double> revenueAccumulatedUsd;
  final Value<int> treesPlanted;
  final Value<DateTime> updatedAt;
  const TreeProgressCompanion({
    this.id = const Value.absent(),
    this.revenueAccumulatedUsd = const Value.absent(),
    this.treesPlanted = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TreeProgressCompanion.insert({
    this.id = const Value.absent(),
    this.revenueAccumulatedUsd = const Value.absent(),
    this.treesPlanted = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<TreeProgressData> custom({
    Expression<int>? id,
    Expression<double>? revenueAccumulatedUsd,
    Expression<int>? treesPlanted,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revenueAccumulatedUsd != null)
        'revenue_accumulated_usd': revenueAccumulatedUsd,
      if (treesPlanted != null) 'trees_planted': treesPlanted,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TreeProgressCompanion copyWith({
    Value<int>? id,
    Value<double>? revenueAccumulatedUsd,
    Value<int>? treesPlanted,
    Value<DateTime>? updatedAt,
  }) {
    return TreeProgressCompanion(
      id: id ?? this.id,
      revenueAccumulatedUsd:
          revenueAccumulatedUsd ?? this.revenueAccumulatedUsd,
      treesPlanted: treesPlanted ?? this.treesPlanted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (revenueAccumulatedUsd.present) {
      map['revenue_accumulated_usd'] = Variable<double>(
        revenueAccumulatedUsd.value,
      );
    }
    if (treesPlanted.present) {
      map['trees_planted'] = Variable<int>(treesPlanted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TreeProgressCompanion(')
          ..write('id: $id, ')
          ..write('revenueAccumulatedUsd: $revenueAccumulatedUsd, ')
          ..write('treesPlanted: $treesPlanted, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UserProfileTable extends UserProfile
    with TableInfo<$UserProfileTable, UserProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weeklyGoalKmMeta = const VerificationMeta(
    'weeklyGoalKm',
  );
  @override
  late final GeneratedColumn<double> weeklyGoalKm = GeneratedColumn<double>(
    'weekly_goal_km',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    age,
    weeklyGoalKm,
    weightKg,
    heightCm,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('weekly_goal_km')) {
      context.handle(
        _weeklyGoalKmMeta,
        weeklyGoalKm.isAcceptableOrUnknown(
          data['weekly_goal_km']!,
          _weeklyGoalKmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weeklyGoalKmMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      weeklyGoalKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weekly_goal_km'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UserProfileTable createAlias(String alias) {
    return $UserProfileTable(attachedDatabase, alias);
  }
}

class UserProfileData extends DataClass implements Insertable<UserProfileData> {
  final int id;
  final String name;
  final int age;

  /// Meta de quilômetros por semana definida pelo usuário.
  final double weeklyGoalKm;
  final double weightKg;
  final double heightCm;
  final DateTime createdAt;
  const UserProfileData({
    required this.id,
    required this.name,
    required this.age,
    required this.weeklyGoalKm,
    required this.weightKg,
    required this.heightCm,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['age'] = Variable<int>(age);
    map['weekly_goal_km'] = Variable<double>(weeklyGoalKm);
    map['weight_kg'] = Variable<double>(weightKg);
    map['height_cm'] = Variable<double>(heightCm);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UserProfileCompanion toCompanion(bool nullToAbsent) {
    return UserProfileCompanion(
      id: Value(id),
      name: Value(name),
      age: Value(age),
      weeklyGoalKm: Value(weeklyGoalKm),
      weightKg: Value(weightKg),
      heightCm: Value(heightCm),
      createdAt: Value(createdAt),
    );
  }

  factory UserProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int>(json['age']),
      weeklyGoalKm: serializer.fromJson<double>(json['weeklyGoalKm']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      heightCm: serializer.fromJson<double>(json['heightCm']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int>(age),
      'weeklyGoalKm': serializer.toJson<double>(weeklyGoalKm),
      'weightKg': serializer.toJson<double>(weightKg),
      'heightCm': serializer.toJson<double>(heightCm),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserProfileData copyWith({
    int? id,
    String? name,
    int? age,
    double? weeklyGoalKm,
    double? weightKg,
    double? heightCm,
    DateTime? createdAt,
  }) => UserProfileData(
    id: id ?? this.id,
    name: name ?? this.name,
    age: age ?? this.age,
    weeklyGoalKm: weeklyGoalKm ?? this.weeklyGoalKm,
    weightKg: weightKg ?? this.weightKg,
    heightCm: heightCm ?? this.heightCm,
    createdAt: createdAt ?? this.createdAt,
  );
  UserProfileData copyWithCompanion(UserProfileCompanion data) {
    return UserProfileData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      weeklyGoalKm: data.weeklyGoalKm.present
          ? data.weeklyGoalKm.value
          : this.weeklyGoalKm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('weeklyGoalKm: $weeklyGoalKm, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, age, weeklyGoalKm, weightKg, heightCm, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileData &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.weeklyGoalKm == this.weeklyGoalKm &&
          other.weightKg == this.weightKg &&
          other.heightCm == this.heightCm &&
          other.createdAt == this.createdAt);
}

class UserProfileCompanion extends UpdateCompanion<UserProfileData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> age;
  final Value<double> weeklyGoalKm;
  final Value<double> weightKg;
  final Value<double> heightCm;
  final Value<DateTime> createdAt;
  const UserProfileCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.weeklyGoalKm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UserProfileCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int age,
    required double weeklyGoalKm,
    required double weightKg,
    required double heightCm,
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       age = Value(age),
       weeklyGoalKm = Value(weeklyGoalKm),
       weightKg = Value(weightKg),
       heightCm = Value(heightCm);
  static Insertable<UserProfileData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? age,
    Expression<double>? weeklyGoalKm,
    Expression<double>? weightKg,
    Expression<double>? heightCm,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (weeklyGoalKm != null) 'weekly_goal_km': weeklyGoalKm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UserProfileCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? age,
    Value<double>? weeklyGoalKm,
    Value<double>? weightKg,
    Value<double>? heightCm,
    Value<DateTime>? createdAt,
  }) {
    return UserProfileCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      weeklyGoalKm: weeklyGoalKm ?? this.weeklyGoalKm,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (weeklyGoalKm.present) {
      map['weekly_goal_km'] = Variable<double>(weeklyGoalKm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('weeklyGoalKm: $weeklyGoalKm, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PlantedTreesTable extends PlantedTrees
    with TableInfo<$PlantedTreesTable, PlantedTree> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlantedTreesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _treeNationIdMeta = const VerificationMeta(
    'treeNationId',
  );
  @override
  late final GeneratedColumn<int> treeNationId = GeneratedColumn<int>(
    'tree_nation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
    'token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _collectUrlMeta = const VerificationMeta(
    'collectUrl',
  );
  @override
  late final GeneratedColumn<String> collectUrl = GeneratedColumn<String>(
    'collect_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _certificateUrlMeta = const VerificationMeta(
    'certificateUrl',
  );
  @override
  late final GeneratedColumn<String> certificateUrl = GeneratedColumn<String>(
    'certificate_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectNameMeta = const VerificationMeta(
    'projectName',
  );
  @override
  late final GeneratedColumn<String> projectName = GeneratedColumn<String>(
    'project_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectUrlMeta = const VerificationMeta(
    'projectUrl',
  );
  @override
  late final GeneratedColumn<String> projectUrl = GeneratedColumn<String>(
    'project_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speciesIdMeta = const VerificationMeta(
    'speciesId',
  );
  @override
  late final GeneratedColumn<int> speciesId = GeneratedColumn<int>(
    'species_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speciesNameMeta = const VerificationMeta(
    'speciesName',
  );
  @override
  late final GeneratedColumn<String> speciesName = GeneratedColumn<String>(
    'species_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speciesLifeTimeCo2Meta =
      const VerificationMeta('speciesLifeTimeCo2');
  @override
  late final GeneratedColumn<double> speciesLifeTimeCo2 =
      GeneratedColumn<double>(
        'species_life_time_co2',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _paymentIdMeta = const VerificationMeta(
    'paymentId',
  );
  @override
  late final GeneratedColumn<int> paymentId = GeneratedColumn<int>(
    'payment_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plantedAtMeta = const VerificationMeta(
    'plantedAt',
  );
  @override
  late final GeneratedColumn<DateTime> plantedAt = GeneratedColumn<DateTime>(
    'planted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    treeNationId,
    token,
    collectUrl,
    certificateUrl,
    country,
    projectId,
    projectName,
    projectUrl,
    speciesId,
    speciesName,
    speciesLifeTimeCo2,
    paymentId,
    plantedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planted_trees';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlantedTree> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tree_nation_id')) {
      context.handle(
        _treeNationIdMeta,
        treeNationId.isAcceptableOrUnknown(
          data['tree_nation_id']!,
          _treeNationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_treeNationIdMeta);
    }
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (data.containsKey('collect_url')) {
      context.handle(
        _collectUrlMeta,
        collectUrl.isAcceptableOrUnknown(data['collect_url']!, _collectUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_collectUrlMeta);
    }
    if (data.containsKey('certificate_url')) {
      context.handle(
        _certificateUrlMeta,
        certificateUrl.isAcceptableOrUnknown(
          data['certificate_url']!,
          _certificateUrlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_certificateUrlMeta);
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    } else if (isInserting) {
      context.missing(_countryMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('project_name')) {
      context.handle(
        _projectNameMeta,
        projectName.isAcceptableOrUnknown(
          data['project_name']!,
          _projectNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_projectNameMeta);
    }
    if (data.containsKey('project_url')) {
      context.handle(
        _projectUrlMeta,
        projectUrl.isAcceptableOrUnknown(data['project_url']!, _projectUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_projectUrlMeta);
    }
    if (data.containsKey('species_id')) {
      context.handle(
        _speciesIdMeta,
        speciesId.isAcceptableOrUnknown(data['species_id']!, _speciesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_speciesIdMeta);
    }
    if (data.containsKey('species_name')) {
      context.handle(
        _speciesNameMeta,
        speciesName.isAcceptableOrUnknown(
          data['species_name']!,
          _speciesNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_speciesNameMeta);
    }
    if (data.containsKey('species_life_time_co2')) {
      context.handle(
        _speciesLifeTimeCo2Meta,
        speciesLifeTimeCo2.isAcceptableOrUnknown(
          data['species_life_time_co2']!,
          _speciesLifeTimeCo2Meta,
        ),
      );
    }
    if (data.containsKey('payment_id')) {
      context.handle(
        _paymentIdMeta,
        paymentId.isAcceptableOrUnknown(data['payment_id']!, _paymentIdMeta),
      );
    }
    if (data.containsKey('planted_at')) {
      context.handle(
        _plantedAtMeta,
        plantedAt.isAcceptableOrUnknown(data['planted_at']!, _plantedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlantedTree map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlantedTree(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      treeNationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tree_nation_id'],
      )!,
      token: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token'],
      )!,
      collectUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collect_url'],
      )!,
      certificateUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}certificate_url'],
      )!,
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      projectName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_name'],
      )!,
      projectUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_url'],
      )!,
      speciesId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}species_id'],
      )!,
      speciesName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species_name'],
      )!,
      speciesLifeTimeCo2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}species_life_time_co2'],
      )!,
      paymentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_id'],
      ),
      plantedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}planted_at'],
      )!,
    );
  }

  @override
  $PlantedTreesTable createAlias(String alias) {
    return $PlantedTreesTable(attachedDatabase, alias);
  }
}

class PlantedTree extends DataClass implements Insertable<PlantedTree> {
  final int id;

  /// Id da árvore na Tree-Nation (`trees[].id`).
  final int treeNationId;
  final String token;
  final String collectUrl;
  final String certificateUrl;
  final String country;
  final int projectId;
  final String projectName;
  final String projectUrl;
  final int speciesId;
  final String speciesName;

  /// CO2 (kg) que a espécie compensa ao longo de sua vida útil.
  final double speciesLifeTimeCo2;
  final int? paymentId;
  final DateTime plantedAt;
  const PlantedTree({
    required this.id,
    required this.treeNationId,
    required this.token,
    required this.collectUrl,
    required this.certificateUrl,
    required this.country,
    required this.projectId,
    required this.projectName,
    required this.projectUrl,
    required this.speciesId,
    required this.speciesName,
    required this.speciesLifeTimeCo2,
    this.paymentId,
    required this.plantedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tree_nation_id'] = Variable<int>(treeNationId);
    map['token'] = Variable<String>(token);
    map['collect_url'] = Variable<String>(collectUrl);
    map['certificate_url'] = Variable<String>(certificateUrl);
    map['country'] = Variable<String>(country);
    map['project_id'] = Variable<int>(projectId);
    map['project_name'] = Variable<String>(projectName);
    map['project_url'] = Variable<String>(projectUrl);
    map['species_id'] = Variable<int>(speciesId);
    map['species_name'] = Variable<String>(speciesName);
    map['species_life_time_co2'] = Variable<double>(speciesLifeTimeCo2);
    if (!nullToAbsent || paymentId != null) {
      map['payment_id'] = Variable<int>(paymentId);
    }
    map['planted_at'] = Variable<DateTime>(plantedAt);
    return map;
  }

  PlantedTreesCompanion toCompanion(bool nullToAbsent) {
    return PlantedTreesCompanion(
      id: Value(id),
      treeNationId: Value(treeNationId),
      token: Value(token),
      collectUrl: Value(collectUrl),
      certificateUrl: Value(certificateUrl),
      country: Value(country),
      projectId: Value(projectId),
      projectName: Value(projectName),
      projectUrl: Value(projectUrl),
      speciesId: Value(speciesId),
      speciesName: Value(speciesName),
      speciesLifeTimeCo2: Value(speciesLifeTimeCo2),
      paymentId: paymentId == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentId),
      plantedAt: Value(plantedAt),
    );
  }

  factory PlantedTree.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlantedTree(
      id: serializer.fromJson<int>(json['id']),
      treeNationId: serializer.fromJson<int>(json['treeNationId']),
      token: serializer.fromJson<String>(json['token']),
      collectUrl: serializer.fromJson<String>(json['collectUrl']),
      certificateUrl: serializer.fromJson<String>(json['certificateUrl']),
      country: serializer.fromJson<String>(json['country']),
      projectId: serializer.fromJson<int>(json['projectId']),
      projectName: serializer.fromJson<String>(json['projectName']),
      projectUrl: serializer.fromJson<String>(json['projectUrl']),
      speciesId: serializer.fromJson<int>(json['speciesId']),
      speciesName: serializer.fromJson<String>(json['speciesName']),
      speciesLifeTimeCo2: serializer.fromJson<double>(
        json['speciesLifeTimeCo2'],
      ),
      paymentId: serializer.fromJson<int?>(json['paymentId']),
      plantedAt: serializer.fromJson<DateTime>(json['plantedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'treeNationId': serializer.toJson<int>(treeNationId),
      'token': serializer.toJson<String>(token),
      'collectUrl': serializer.toJson<String>(collectUrl),
      'certificateUrl': serializer.toJson<String>(certificateUrl),
      'country': serializer.toJson<String>(country),
      'projectId': serializer.toJson<int>(projectId),
      'projectName': serializer.toJson<String>(projectName),
      'projectUrl': serializer.toJson<String>(projectUrl),
      'speciesId': serializer.toJson<int>(speciesId),
      'speciesName': serializer.toJson<String>(speciesName),
      'speciesLifeTimeCo2': serializer.toJson<double>(speciesLifeTimeCo2),
      'paymentId': serializer.toJson<int?>(paymentId),
      'plantedAt': serializer.toJson<DateTime>(plantedAt),
    };
  }

  PlantedTree copyWith({
    int? id,
    int? treeNationId,
    String? token,
    String? collectUrl,
    String? certificateUrl,
    String? country,
    int? projectId,
    String? projectName,
    String? projectUrl,
    int? speciesId,
    String? speciesName,
    double? speciesLifeTimeCo2,
    Value<int?> paymentId = const Value.absent(),
    DateTime? plantedAt,
  }) => PlantedTree(
    id: id ?? this.id,
    treeNationId: treeNationId ?? this.treeNationId,
    token: token ?? this.token,
    collectUrl: collectUrl ?? this.collectUrl,
    certificateUrl: certificateUrl ?? this.certificateUrl,
    country: country ?? this.country,
    projectId: projectId ?? this.projectId,
    projectName: projectName ?? this.projectName,
    projectUrl: projectUrl ?? this.projectUrl,
    speciesId: speciesId ?? this.speciesId,
    speciesName: speciesName ?? this.speciesName,
    speciesLifeTimeCo2: speciesLifeTimeCo2 ?? this.speciesLifeTimeCo2,
    paymentId: paymentId.present ? paymentId.value : this.paymentId,
    plantedAt: plantedAt ?? this.plantedAt,
  );
  PlantedTree copyWithCompanion(PlantedTreesCompanion data) {
    return PlantedTree(
      id: data.id.present ? data.id.value : this.id,
      treeNationId: data.treeNationId.present
          ? data.treeNationId.value
          : this.treeNationId,
      token: data.token.present ? data.token.value : this.token,
      collectUrl: data.collectUrl.present
          ? data.collectUrl.value
          : this.collectUrl,
      certificateUrl: data.certificateUrl.present
          ? data.certificateUrl.value
          : this.certificateUrl,
      country: data.country.present ? data.country.value : this.country,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      projectName: data.projectName.present
          ? data.projectName.value
          : this.projectName,
      projectUrl: data.projectUrl.present
          ? data.projectUrl.value
          : this.projectUrl,
      speciesId: data.speciesId.present ? data.speciesId.value : this.speciesId,
      speciesName: data.speciesName.present
          ? data.speciesName.value
          : this.speciesName,
      speciesLifeTimeCo2: data.speciesLifeTimeCo2.present
          ? data.speciesLifeTimeCo2.value
          : this.speciesLifeTimeCo2,
      paymentId: data.paymentId.present ? data.paymentId.value : this.paymentId,
      plantedAt: data.plantedAt.present ? data.plantedAt.value : this.plantedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlantedTree(')
          ..write('id: $id, ')
          ..write('treeNationId: $treeNationId, ')
          ..write('token: $token, ')
          ..write('collectUrl: $collectUrl, ')
          ..write('certificateUrl: $certificateUrl, ')
          ..write('country: $country, ')
          ..write('projectId: $projectId, ')
          ..write('projectName: $projectName, ')
          ..write('projectUrl: $projectUrl, ')
          ..write('speciesId: $speciesId, ')
          ..write('speciesName: $speciesName, ')
          ..write('speciesLifeTimeCo2: $speciesLifeTimeCo2, ')
          ..write('paymentId: $paymentId, ')
          ..write('plantedAt: $plantedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    treeNationId,
    token,
    collectUrl,
    certificateUrl,
    country,
    projectId,
    projectName,
    projectUrl,
    speciesId,
    speciesName,
    speciesLifeTimeCo2,
    paymentId,
    plantedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlantedTree &&
          other.id == this.id &&
          other.treeNationId == this.treeNationId &&
          other.token == this.token &&
          other.collectUrl == this.collectUrl &&
          other.certificateUrl == this.certificateUrl &&
          other.country == this.country &&
          other.projectId == this.projectId &&
          other.projectName == this.projectName &&
          other.projectUrl == this.projectUrl &&
          other.speciesId == this.speciesId &&
          other.speciesName == this.speciesName &&
          other.speciesLifeTimeCo2 == this.speciesLifeTimeCo2 &&
          other.paymentId == this.paymentId &&
          other.plantedAt == this.plantedAt);
}

class PlantedTreesCompanion extends UpdateCompanion<PlantedTree> {
  final Value<int> id;
  final Value<int> treeNationId;
  final Value<String> token;
  final Value<String> collectUrl;
  final Value<String> certificateUrl;
  final Value<String> country;
  final Value<int> projectId;
  final Value<String> projectName;
  final Value<String> projectUrl;
  final Value<int> speciesId;
  final Value<String> speciesName;
  final Value<double> speciesLifeTimeCo2;
  final Value<int?> paymentId;
  final Value<DateTime> plantedAt;
  const PlantedTreesCompanion({
    this.id = const Value.absent(),
    this.treeNationId = const Value.absent(),
    this.token = const Value.absent(),
    this.collectUrl = const Value.absent(),
    this.certificateUrl = const Value.absent(),
    this.country = const Value.absent(),
    this.projectId = const Value.absent(),
    this.projectName = const Value.absent(),
    this.projectUrl = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.speciesName = const Value.absent(),
    this.speciesLifeTimeCo2 = const Value.absent(),
    this.paymentId = const Value.absent(),
    this.plantedAt = const Value.absent(),
  });
  PlantedTreesCompanion.insert({
    this.id = const Value.absent(),
    required int treeNationId,
    required String token,
    required String collectUrl,
    required String certificateUrl,
    required String country,
    required int projectId,
    required String projectName,
    required String projectUrl,
    required int speciesId,
    required String speciesName,
    this.speciesLifeTimeCo2 = const Value.absent(),
    this.paymentId = const Value.absent(),
    this.plantedAt = const Value.absent(),
  }) : treeNationId = Value(treeNationId),
       token = Value(token),
       collectUrl = Value(collectUrl),
       certificateUrl = Value(certificateUrl),
       country = Value(country),
       projectId = Value(projectId),
       projectName = Value(projectName),
       projectUrl = Value(projectUrl),
       speciesId = Value(speciesId),
       speciesName = Value(speciesName);
  static Insertable<PlantedTree> custom({
    Expression<int>? id,
    Expression<int>? treeNationId,
    Expression<String>? token,
    Expression<String>? collectUrl,
    Expression<String>? certificateUrl,
    Expression<String>? country,
    Expression<int>? projectId,
    Expression<String>? projectName,
    Expression<String>? projectUrl,
    Expression<int>? speciesId,
    Expression<String>? speciesName,
    Expression<double>? speciesLifeTimeCo2,
    Expression<int>? paymentId,
    Expression<DateTime>? plantedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (treeNationId != null) 'tree_nation_id': treeNationId,
      if (token != null) 'token': token,
      if (collectUrl != null) 'collect_url': collectUrl,
      if (certificateUrl != null) 'certificate_url': certificateUrl,
      if (country != null) 'country': country,
      if (projectId != null) 'project_id': projectId,
      if (projectName != null) 'project_name': projectName,
      if (projectUrl != null) 'project_url': projectUrl,
      if (speciesId != null) 'species_id': speciesId,
      if (speciesName != null) 'species_name': speciesName,
      if (speciesLifeTimeCo2 != null)
        'species_life_time_co2': speciesLifeTimeCo2,
      if (paymentId != null) 'payment_id': paymentId,
      if (plantedAt != null) 'planted_at': plantedAt,
    });
  }

  PlantedTreesCompanion copyWith({
    Value<int>? id,
    Value<int>? treeNationId,
    Value<String>? token,
    Value<String>? collectUrl,
    Value<String>? certificateUrl,
    Value<String>? country,
    Value<int>? projectId,
    Value<String>? projectName,
    Value<String>? projectUrl,
    Value<int>? speciesId,
    Value<String>? speciesName,
    Value<double>? speciesLifeTimeCo2,
    Value<int?>? paymentId,
    Value<DateTime>? plantedAt,
  }) {
    return PlantedTreesCompanion(
      id: id ?? this.id,
      treeNationId: treeNationId ?? this.treeNationId,
      token: token ?? this.token,
      collectUrl: collectUrl ?? this.collectUrl,
      certificateUrl: certificateUrl ?? this.certificateUrl,
      country: country ?? this.country,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      projectUrl: projectUrl ?? this.projectUrl,
      speciesId: speciesId ?? this.speciesId,
      speciesName: speciesName ?? this.speciesName,
      speciesLifeTimeCo2: speciesLifeTimeCo2 ?? this.speciesLifeTimeCo2,
      paymentId: paymentId ?? this.paymentId,
      plantedAt: plantedAt ?? this.plantedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (treeNationId.present) {
      map['tree_nation_id'] = Variable<int>(treeNationId.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (collectUrl.present) {
      map['collect_url'] = Variable<String>(collectUrl.value);
    }
    if (certificateUrl.present) {
      map['certificate_url'] = Variable<String>(certificateUrl.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (projectName.present) {
      map['project_name'] = Variable<String>(projectName.value);
    }
    if (projectUrl.present) {
      map['project_url'] = Variable<String>(projectUrl.value);
    }
    if (speciesId.present) {
      map['species_id'] = Variable<int>(speciesId.value);
    }
    if (speciesName.present) {
      map['species_name'] = Variable<String>(speciesName.value);
    }
    if (speciesLifeTimeCo2.present) {
      map['species_life_time_co2'] = Variable<double>(speciesLifeTimeCo2.value);
    }
    if (paymentId.present) {
      map['payment_id'] = Variable<int>(paymentId.value);
    }
    if (plantedAt.present) {
      map['planted_at'] = Variable<DateTime>(plantedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlantedTreesCompanion(')
          ..write('id: $id, ')
          ..write('treeNationId: $treeNationId, ')
          ..write('token: $token, ')
          ..write('collectUrl: $collectUrl, ')
          ..write('certificateUrl: $certificateUrl, ')
          ..write('country: $country, ')
          ..write('projectId: $projectId, ')
          ..write('projectName: $projectName, ')
          ..write('projectUrl: $projectUrl, ')
          ..write('speciesId: $speciesId, ')
          ..write('speciesName: $speciesName, ')
          ..write('speciesLifeTimeCo2: $speciesLifeTimeCo2, ')
          ..write('paymentId: $paymentId, ')
          ..write('plantedAt: $plantedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RunSessionsTable runSessions = $RunSessionsTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $TreeProgressTable treeProgress = $TreeProgressTable(this);
  late final $UserProfileTable userProfile = $UserProfileTable(this);
  late final $PlantedTreesTable plantedTrees = $PlantedTreesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    runSessions,
    exercises,
    treeProgress,
    userProfile,
    plantedTrees,
  ];
}

typedef $$RunSessionsTableCreateCompanionBuilder =
    RunSessionsCompanion Function({
      Value<int> id,
      Value<int> durationSeconds,
      Value<double> distanceKm,
      Value<double> calories,
      Value<double> averageSpeed,
      Value<double> maxSpeed,
      Value<double> pace,
      Value<String> polyline,
      Value<String?> temperature,
      Value<bool> isNight,
      Value<int> treesEarned,
      Value<String> exerciseType,
      Value<DateTime> createdAt,
    });
typedef $$RunSessionsTableUpdateCompanionBuilder =
    RunSessionsCompanion Function({
      Value<int> id,
      Value<int> durationSeconds,
      Value<double> distanceKm,
      Value<double> calories,
      Value<double> averageSpeed,
      Value<double> maxSpeed,
      Value<double> pace,
      Value<String> polyline,
      Value<String?> temperature,
      Value<bool> isNight,
      Value<int> treesEarned,
      Value<String> exerciseType,
      Value<DateTime> createdAt,
    });

class $$RunSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $RunSessionsTable> {
  $$RunSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get averageSpeed => $composableBuilder(
    column: $table.averageSpeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxSpeed => $composableBuilder(
    column: $table.maxSpeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pace => $composableBuilder(
    column: $table.pace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get polyline => $composableBuilder(
    column: $table.polyline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isNight => $composableBuilder(
    column: $table.isNight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get treesEarned => $composableBuilder(
    column: $table.treesEarned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RunSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RunSessionsTable> {
  $$RunSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averageSpeed => $composableBuilder(
    column: $table.averageSpeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxSpeed => $composableBuilder(
    column: $table.maxSpeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pace => $composableBuilder(
    column: $table.pace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get polyline => $composableBuilder(
    column: $table.polyline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isNight => $composableBuilder(
    column: $table.isNight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get treesEarned => $composableBuilder(
    column: $table.treesEarned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RunSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RunSessionsTable> {
  $$RunSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get averageSpeed => $composableBuilder(
    column: $table.averageSpeed,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxSpeed =>
      $composableBuilder(column: $table.maxSpeed, builder: (column) => column);

  GeneratedColumn<double> get pace =>
      $composableBuilder(column: $table.pace, builder: (column) => column);

  GeneratedColumn<String> get polyline =>
      $composableBuilder(column: $table.polyline, builder: (column) => column);

  GeneratedColumn<String> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isNight =>
      $composableBuilder(column: $table.isNight, builder: (column) => column);

  GeneratedColumn<int> get treesEarned => $composableBuilder(
    column: $table.treesEarned,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RunSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RunSessionsTable,
          RunSession,
          $$RunSessionsTableFilterComposer,
          $$RunSessionsTableOrderingComposer,
          $$RunSessionsTableAnnotationComposer,
          $$RunSessionsTableCreateCompanionBuilder,
          $$RunSessionsTableUpdateCompanionBuilder,
          (
            RunSession,
            BaseReferences<_$AppDatabase, $RunSessionsTable, RunSession>,
          ),
          RunSession,
          PrefetchHooks Function()
        > {
  $$RunSessionsTableTableManager(_$AppDatabase db, $RunSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RunSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RunSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RunSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<double> distanceKm = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> averageSpeed = const Value.absent(),
                Value<double> maxSpeed = const Value.absent(),
                Value<double> pace = const Value.absent(),
                Value<String> polyline = const Value.absent(),
                Value<String?> temperature = const Value.absent(),
                Value<bool> isNight = const Value.absent(),
                Value<int> treesEarned = const Value.absent(),
                Value<String> exerciseType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RunSessionsCompanion(
                id: id,
                durationSeconds: durationSeconds,
                distanceKm: distanceKm,
                calories: calories,
                averageSpeed: averageSpeed,
                maxSpeed: maxSpeed,
                pace: pace,
                polyline: polyline,
                temperature: temperature,
                isNight: isNight,
                treesEarned: treesEarned,
                exerciseType: exerciseType,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<double> distanceKm = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> averageSpeed = const Value.absent(),
                Value<double> maxSpeed = const Value.absent(),
                Value<double> pace = const Value.absent(),
                Value<String> polyline = const Value.absent(),
                Value<String?> temperature = const Value.absent(),
                Value<bool> isNight = const Value.absent(),
                Value<int> treesEarned = const Value.absent(),
                Value<String> exerciseType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RunSessionsCompanion.insert(
                id: id,
                durationSeconds: durationSeconds,
                distanceKm: distanceKm,
                calories: calories,
                averageSpeed: averageSpeed,
                maxSpeed: maxSpeed,
                pace: pace,
                polyline: polyline,
                temperature: temperature,
                isNight: isNight,
                treesEarned: treesEarned,
                exerciseType: exerciseType,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RunSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RunSessionsTable,
      RunSession,
      $$RunSessionsTableFilterComposer,
      $$RunSessionsTableOrderingComposer,
      $$RunSessionsTableAnnotationComposer,
      $$RunSessionsTableCreateCompanionBuilder,
      $$RunSessionsTableUpdateCompanionBuilder,
      (
        RunSession,
        BaseReferences<_$AppDatabase, $RunSessionsTable, RunSession>,
      ),
      RunSession,
      PrefetchHooks Function()
    >;
typedef $$ExercisesTableCreateCompanionBuilder =
    ExercisesCompanion Function({
      required String id,
      required String name,
      required String description,
      required String category,
      Value<int?> durationInMinutes,
      Value<double?> caloriesBurned,
      Value<int> rowid,
    });
typedef $$ExercisesTableUpdateCompanionBuilder =
    ExercisesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> description,
      Value<String> category,
      Value<int?> durationInMinutes,
      Value<double?> caloriesBurned,
      Value<int> rowid,
    });

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationInMinutes => $composableBuilder(
    column: $table.durationInMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesBurned => $composableBuilder(
    column: $table.caloriesBurned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationInMinutes => $composableBuilder(
    column: $table.durationInMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesBurned => $composableBuilder(
    column: $table.caloriesBurned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get durationInMinutes => $composableBuilder(
    column: $table.durationInMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get caloriesBurned => $composableBuilder(
    column: $table.caloriesBurned,
    builder: (column) => column,
  );
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, BaseReferences<_$AppDatabase, $ExercisesTable, Exercise>),
          Exercise,
          PrefetchHooks Function()
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int?> durationInMinutes = const Value.absent(),
                Value<double?> caloriesBurned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                name: name,
                description: description,
                category: category,
                durationInMinutes: durationInMinutes,
                caloriesBurned: caloriesBurned,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String description,
                required String category,
                Value<int?> durationInMinutes = const Value.absent(),
                Value<double?> caloriesBurned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                name: name,
                description: description,
                category: category,
                durationInMinutes: durationInMinutes,
                caloriesBurned: caloriesBurned,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, BaseReferences<_$AppDatabase, $ExercisesTable, Exercise>),
      Exercise,
      PrefetchHooks Function()
    >;
typedef $$TreeProgressTableCreateCompanionBuilder =
    TreeProgressCompanion Function({
      Value<int> id,
      Value<double> revenueAccumulatedUsd,
      Value<int> treesPlanted,
      Value<DateTime> updatedAt,
    });
typedef $$TreeProgressTableUpdateCompanionBuilder =
    TreeProgressCompanion Function({
      Value<int> id,
      Value<double> revenueAccumulatedUsd,
      Value<int> treesPlanted,
      Value<DateTime> updatedAt,
    });

class $$TreeProgressTableFilterComposer
    extends Composer<_$AppDatabase, $TreeProgressTable> {
  $$TreeProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get revenueAccumulatedUsd => $composableBuilder(
    column: $table.revenueAccumulatedUsd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get treesPlanted => $composableBuilder(
    column: $table.treesPlanted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TreeProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $TreeProgressTable> {
  $$TreeProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get revenueAccumulatedUsd => $composableBuilder(
    column: $table.revenueAccumulatedUsd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get treesPlanted => $composableBuilder(
    column: $table.treesPlanted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TreeProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $TreeProgressTable> {
  $$TreeProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get revenueAccumulatedUsd => $composableBuilder(
    column: $table.revenueAccumulatedUsd,
    builder: (column) => column,
  );

  GeneratedColumn<int> get treesPlanted => $composableBuilder(
    column: $table.treesPlanted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TreeProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TreeProgressTable,
          TreeProgressData,
          $$TreeProgressTableFilterComposer,
          $$TreeProgressTableOrderingComposer,
          $$TreeProgressTableAnnotationComposer,
          $$TreeProgressTableCreateCompanionBuilder,
          $$TreeProgressTableUpdateCompanionBuilder,
          (
            TreeProgressData,
            BaseReferences<_$AppDatabase, $TreeProgressTable, TreeProgressData>,
          ),
          TreeProgressData,
          PrefetchHooks Function()
        > {
  $$TreeProgressTableTableManager(_$AppDatabase db, $TreeProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TreeProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TreeProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TreeProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> revenueAccumulatedUsd = const Value.absent(),
                Value<int> treesPlanted = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TreeProgressCompanion(
                id: id,
                revenueAccumulatedUsd: revenueAccumulatedUsd,
                treesPlanted: treesPlanted,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> revenueAccumulatedUsd = const Value.absent(),
                Value<int> treesPlanted = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TreeProgressCompanion.insert(
                id: id,
                revenueAccumulatedUsd: revenueAccumulatedUsd,
                treesPlanted: treesPlanted,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TreeProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TreeProgressTable,
      TreeProgressData,
      $$TreeProgressTableFilterComposer,
      $$TreeProgressTableOrderingComposer,
      $$TreeProgressTableAnnotationComposer,
      $$TreeProgressTableCreateCompanionBuilder,
      $$TreeProgressTableUpdateCompanionBuilder,
      (
        TreeProgressData,
        BaseReferences<_$AppDatabase, $TreeProgressTable, TreeProgressData>,
      ),
      TreeProgressData,
      PrefetchHooks Function()
    >;
typedef $$UserProfileTableCreateCompanionBuilder =
    UserProfileCompanion Function({
      Value<int> id,
      required String name,
      required int age,
      required double weeklyGoalKm,
      required double weightKg,
      required double heightCm,
      Value<DateTime> createdAt,
    });
typedef $$UserProfileTableUpdateCompanionBuilder =
    UserProfileCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> age,
      Value<double> weeklyGoalKm,
      Value<double> weightKg,
      Value<double> heightCm,
      Value<DateTime> createdAt,
    });

class $$UserProfileTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weeklyGoalKm => $composableBuilder(
    column: $table.weeklyGoalKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weeklyGoalKm => $composableBuilder(
    column: $table.weeklyGoalKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<double> get weeklyGoalKm => $composableBuilder(
    column: $table.weeklyGoalKm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UserProfileTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfileTable,
          UserProfileData,
          $$UserProfileTableFilterComposer,
          $$UserProfileTableOrderingComposer,
          $$UserProfileTableAnnotationComposer,
          $$UserProfileTableCreateCompanionBuilder,
          $$UserProfileTableUpdateCompanionBuilder,
          (
            UserProfileData,
            BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileData>,
          ),
          UserProfileData,
          PrefetchHooks Function()
        > {
  $$UserProfileTableTableManager(_$AppDatabase db, $UserProfileTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<double> weeklyGoalKm = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<double> heightCm = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UserProfileCompanion(
                id: id,
                name: name,
                age: age,
                weeklyGoalKm: weeklyGoalKm,
                weightKg: weightKg,
                heightCm: heightCm,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int age,
                required double weeklyGoalKm,
                required double weightKg,
                required double heightCm,
                Value<DateTime> createdAt = const Value.absent(),
              }) => UserProfileCompanion.insert(
                id: id,
                name: name,
                age: age,
                weeklyGoalKm: weeklyGoalKm,
                weightKg: weightKg,
                heightCm: heightCm,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfileTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfileTable,
      UserProfileData,
      $$UserProfileTableFilterComposer,
      $$UserProfileTableOrderingComposer,
      $$UserProfileTableAnnotationComposer,
      $$UserProfileTableCreateCompanionBuilder,
      $$UserProfileTableUpdateCompanionBuilder,
      (
        UserProfileData,
        BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileData>,
      ),
      UserProfileData,
      PrefetchHooks Function()
    >;
typedef $$PlantedTreesTableCreateCompanionBuilder =
    PlantedTreesCompanion Function({
      Value<int> id,
      required int treeNationId,
      required String token,
      required String collectUrl,
      required String certificateUrl,
      required String country,
      required int projectId,
      required String projectName,
      required String projectUrl,
      required int speciesId,
      required String speciesName,
      Value<double> speciesLifeTimeCo2,
      Value<int?> paymentId,
      Value<DateTime> plantedAt,
    });
typedef $$PlantedTreesTableUpdateCompanionBuilder =
    PlantedTreesCompanion Function({
      Value<int> id,
      Value<int> treeNationId,
      Value<String> token,
      Value<String> collectUrl,
      Value<String> certificateUrl,
      Value<String> country,
      Value<int> projectId,
      Value<String> projectName,
      Value<String> projectUrl,
      Value<int> speciesId,
      Value<String> speciesName,
      Value<double> speciesLifeTimeCo2,
      Value<int?> paymentId,
      Value<DateTime> plantedAt,
    });

class $$PlantedTreesTableFilterComposer
    extends Composer<_$AppDatabase, $PlantedTreesTable> {
  $$PlantedTreesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get treeNationId => $composableBuilder(
    column: $table.treeNationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get collectUrl => $composableBuilder(
    column: $table.collectUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get certificateUrl => $composableBuilder(
    column: $table.certificateUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectName => $composableBuilder(
    column: $table.projectName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectUrl => $composableBuilder(
    column: $table.projectUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get speciesId => $composableBuilder(
    column: $table.speciesId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speciesName => $composableBuilder(
    column: $table.speciesName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speciesLifeTimeCo2 => $composableBuilder(
    column: $table.speciesLifeTimeCo2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paymentId => $composableBuilder(
    column: $table.paymentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get plantedAt => $composableBuilder(
    column: $table.plantedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlantedTreesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlantedTreesTable> {
  $$PlantedTreesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get treeNationId => $composableBuilder(
    column: $table.treeNationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get collectUrl => $composableBuilder(
    column: $table.collectUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get certificateUrl => $composableBuilder(
    column: $table.certificateUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectName => $composableBuilder(
    column: $table.projectName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectUrl => $composableBuilder(
    column: $table.projectUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get speciesId => $composableBuilder(
    column: $table.speciesId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speciesName => $composableBuilder(
    column: $table.speciesName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speciesLifeTimeCo2 => $composableBuilder(
    column: $table.speciesLifeTimeCo2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paymentId => $composableBuilder(
    column: $table.paymentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get plantedAt => $composableBuilder(
    column: $table.plantedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlantedTreesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlantedTreesTable> {
  $$PlantedTreesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get treeNationId => $composableBuilder(
    column: $table.treeNationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<String> get collectUrl => $composableBuilder(
    column: $table.collectUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get certificateUrl => $composableBuilder(
    column: $table.certificateUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<int> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get projectName => $composableBuilder(
    column: $table.projectName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get projectUrl => $composableBuilder(
    column: $table.projectUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get speciesId =>
      $composableBuilder(column: $table.speciesId, builder: (column) => column);

  GeneratedColumn<String> get speciesName => $composableBuilder(
    column: $table.speciesName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get speciesLifeTimeCo2 => $composableBuilder(
    column: $table.speciesLifeTimeCo2,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paymentId =>
      $composableBuilder(column: $table.paymentId, builder: (column) => column);

  GeneratedColumn<DateTime> get plantedAt =>
      $composableBuilder(column: $table.plantedAt, builder: (column) => column);
}

class $$PlantedTreesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlantedTreesTable,
          PlantedTree,
          $$PlantedTreesTableFilterComposer,
          $$PlantedTreesTableOrderingComposer,
          $$PlantedTreesTableAnnotationComposer,
          $$PlantedTreesTableCreateCompanionBuilder,
          $$PlantedTreesTableUpdateCompanionBuilder,
          (
            PlantedTree,
            BaseReferences<_$AppDatabase, $PlantedTreesTable, PlantedTree>,
          ),
          PlantedTree,
          PrefetchHooks Function()
        > {
  $$PlantedTreesTableTableManager(_$AppDatabase db, $PlantedTreesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlantedTreesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlantedTreesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlantedTreesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> treeNationId = const Value.absent(),
                Value<String> token = const Value.absent(),
                Value<String> collectUrl = const Value.absent(),
                Value<String> certificateUrl = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<String> projectName = const Value.absent(),
                Value<String> projectUrl = const Value.absent(),
                Value<int> speciesId = const Value.absent(),
                Value<String> speciesName = const Value.absent(),
                Value<double> speciesLifeTimeCo2 = const Value.absent(),
                Value<int?> paymentId = const Value.absent(),
                Value<DateTime> plantedAt = const Value.absent(),
              }) => PlantedTreesCompanion(
                id: id,
                treeNationId: treeNationId,
                token: token,
                collectUrl: collectUrl,
                certificateUrl: certificateUrl,
                country: country,
                projectId: projectId,
                projectName: projectName,
                projectUrl: projectUrl,
                speciesId: speciesId,
                speciesName: speciesName,
                speciesLifeTimeCo2: speciesLifeTimeCo2,
                paymentId: paymentId,
                plantedAt: plantedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int treeNationId,
                required String token,
                required String collectUrl,
                required String certificateUrl,
                required String country,
                required int projectId,
                required String projectName,
                required String projectUrl,
                required int speciesId,
                required String speciesName,
                Value<double> speciesLifeTimeCo2 = const Value.absent(),
                Value<int?> paymentId = const Value.absent(),
                Value<DateTime> plantedAt = const Value.absent(),
              }) => PlantedTreesCompanion.insert(
                id: id,
                treeNationId: treeNationId,
                token: token,
                collectUrl: collectUrl,
                certificateUrl: certificateUrl,
                country: country,
                projectId: projectId,
                projectName: projectName,
                projectUrl: projectUrl,
                speciesId: speciesId,
                speciesName: speciesName,
                speciesLifeTimeCo2: speciesLifeTimeCo2,
                paymentId: paymentId,
                plantedAt: plantedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlantedTreesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlantedTreesTable,
      PlantedTree,
      $$PlantedTreesTableFilterComposer,
      $$PlantedTreesTableOrderingComposer,
      $$PlantedTreesTableAnnotationComposer,
      $$PlantedTreesTableCreateCompanionBuilder,
      $$PlantedTreesTableUpdateCompanionBuilder,
      (
        PlantedTree,
        BaseReferences<_$AppDatabase, $PlantedTreesTable, PlantedTree>,
      ),
      PlantedTree,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RunSessionsTableTableManager get runSessions =>
      $$RunSessionsTableTableManager(_db, _db.runSessions);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$TreeProgressTableTableManager get treeProgress =>
      $$TreeProgressTableTableManager(_db, _db.treeProgress);
  $$UserProfileTableTableManager get userProfile =>
      $$UserProfileTableTableManager(_db, _db.userProfile);
  $$PlantedTreesTableTableManager get plantedTrees =>
      $$PlantedTreesTableTableManager(_db, _db.plantedTrees);
}
