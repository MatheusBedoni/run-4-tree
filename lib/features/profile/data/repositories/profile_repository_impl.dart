import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl();

  @override
  Future<ProfileEntity> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return ProfileModel(
      name: 'Corredor Run4Tree',
      email: 'usuario@run4tree.com',
      avatarUrl: null,
      treesPlanted: 0,
      totalDistanceKm: 0,
      memberSince: DateTime(2026, 1, 1),
    );
  }
}
