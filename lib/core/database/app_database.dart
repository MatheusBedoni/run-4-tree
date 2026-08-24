import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/exercises_table.dart';
import 'tables/run_sessions_table.dart';
import 'tables/tree_progress_table.dart';

part 'app_database.g.dart';

/// Banco de dados central do aplicativo usando Drift.
///
/// Registra todas as tabelas do app e provê acesso singleton.
/// O código gerado (`app_database.g.dart`) é criado pelo `build_runner`.
@DriftDatabase(tables: [RunSessions, Exercises, TreeProgress])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());

  static AppDatabase? _instance;

  /// Retorna a instância singleton do banco.
  static AppDatabase get instance {
    _instance ??= AppDatabase._();
    return _instance!;
  }

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) => m.createAll(),
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(treeProgress);
          } else if (from < 3) {
            // `seedsAccumulated` (int) virou `revenueAccumulatedUsd` (real).
            // Sem dados de produção a preservar ainda: recria a tabela.
            await m.deleteTable(treeProgress.actualTableName);
            await m.createTable(treeProgress);
          }
        },
      );
}

/// Abre a conexão nativa com o arquivo SQLite.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'run_4_tree.db'));
    return NativeDatabase.createInBackground(file);
  });
}
