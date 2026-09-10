import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/firestore_safe_call.dart';
import '../../domain/entities/global_planted_tree_entity.dart';
import '../../domain/repositories/global_forest_repository.dart';

/// Implementação concreta do [GlobalForestRepository] usando Cloud Firestore.
///
/// Coleção `global_planted_trees`: sem autenticação (o app não tem login),
/// mas somente-criação — as regras de segurança do Firestore proíbem update
/// e delete, e exigem que `certificateUrl` seja um link https de verdade,
/// então qualquer registro pode ser auditado publicamente pelo certificado
/// real da Tree-Nation.
class GlobalForestRepositoryImpl implements GlobalForestRepository {
  static const String _collection = 'global_planted_trees';

  final FirebaseFirestore _firestore;

  GlobalForestRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> publishPlantedTree(GlobalPlantedTreeEntity tree) {
    return safeFirestoreCall('publishPlantedTree', () async {
      await _firestore.collection(_collection).add({
        'certificateUrl': tree.certificateUrl,
        'collectUrl': tree.collectUrl,
        'country': tree.country,
        'projectName': tree.projectName,
        'speciesName': tree.speciesName,
        'co2LifeTimeKg': tree.co2LifeTimeKg,
        'plantedAt': Timestamp.fromDate(tree.plantedAt),
      });
    }).then((_) {});
  }

  @override
  Future<int?> getTotalTreesPlanted() {
    return safeFirestoreCall('getTotalTreesPlanted', () async {
      final snapshot = await _firestore.collection(_collection).count().get();
      return snapshot.count ?? 0;
    });
  }

  @override
  Future<List<GlobalPlantedTreeEntity>?> getRecentPlantedTrees({int limit = 30}) {
    return safeFirestoreCall('getRecentPlantedTrees', () async {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('plantedAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return GlobalPlantedTreeEntity(
          id: doc.id,
          certificateUrl: data['certificateUrl'] as String? ?? '',
          collectUrl: data['collectUrl'] as String? ?? '',
          country: data['country'] as String? ?? '',
          projectName: data['projectName'] as String? ?? '',
          speciesName: data['speciesName'] as String? ?? '',
          co2LifeTimeKg: (data['co2LifeTimeKg'] as num?)?.toDouble() ?? 0,
          plantedAt: (data['plantedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    });
  }
}
