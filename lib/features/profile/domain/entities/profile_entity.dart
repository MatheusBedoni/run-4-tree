class ProfileEntity {
  final String name;
  final String email;
  final String? avatarUrl;
  final int treesPlanted;
  final double totalDistanceKm;
  final DateTime memberSince;

  const ProfileEntity({
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.treesPlanted,
    required this.totalDistanceKm,
    required this.memberSince,
  });
}
