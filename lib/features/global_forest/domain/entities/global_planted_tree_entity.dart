/// Entidade pura do domínio: uma árvore plantada por QUALQUER usuário do
/// app, publicada no mural global (Firestore). Cada uma carrega o link do
/// certificado real da Tree-Nation — auditável por qualquer pessoa, o que
/// desestimula registros falsos mesmo sem autenticação de usuário.
class GlobalPlantedTreeEntity {
  final String id;
  final String certificateUrl;
  final String collectUrl;
  final String country;
  final String projectName;
  final String speciesName;
  final double co2LifeTimeKg;
  final DateTime plantedAt;

  const GlobalPlantedTreeEntity({
    required this.id,
    required this.certificateUrl,
    required this.collectUrl,
    required this.country,
    required this.projectName,
    required this.speciesName,
    required this.co2LifeTimeKg,
    required this.plantedAt,
  });
}
