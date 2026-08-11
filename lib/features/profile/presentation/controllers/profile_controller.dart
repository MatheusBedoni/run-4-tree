import 'package:flutter/foundation.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';

class ProfileController extends ChangeNotifier {
  final GetProfileUseCase _getProfileUseCase;

  ProfileController(this._getProfileUseCase);

  ProfileEntity? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileEntity? get profile => _profile;
  bool get isLoading => _isLoading;
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

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
