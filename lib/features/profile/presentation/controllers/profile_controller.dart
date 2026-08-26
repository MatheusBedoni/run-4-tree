import 'package:flutter/foundation.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

class ProfileController extends ChangeNotifier {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileController(this._getProfileUseCase, this._updateProfileUseCase);

  ProfileEntity? _profile;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  ProfileEntity? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  Future<void> loadProfile() async {
    _setLoading(true);
    try {
      _profile = await _getProfileUseCase();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Não foi possível carregar o perfil. Tente novamente.';
      debugPrint('ProfileController.loadProfile error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
    required String name,
    required int age,
    required double weightKg,
    required double heightCm,
    required double weeklyGoalKm,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _updateProfileUseCase(
        name: name,
        age: age,
        weightKg: weightKg,
        heightCm: heightCm,
        weeklyGoalKm: weeklyGoalKm,
      );
      _profile = await _getProfileUseCase();
      return true;
    } catch (e) {
      _errorMessage = 'Não foi possível salvar suas alterações. Tente novamente.';
      debugPrint('ProfileController.updateProfile error: $e');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
