import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../../../profile/domain/usecases/get_profile_usecase.dart';
import '../../../runs/domain/entities/run_session_entity.dart';

/// Controller da [ExerciseDetailsPage] seguindo o padrão ChangeNotifier.
///
/// Decodifica a polyline da corrida, monta os dados do mapa e carrega
/// o perfil do usuário para calcular métricas derivadas (ex: desidratação).
class ExerciseDetailsController extends ChangeNotifier {
  final GetProfileUseCase _getProfileUseCase;
  final RunSessionEntity runSession;

  ExerciseDetailsController(this._getProfileUseCase, this.runSession) {
    _polylinePoints = _decodePolyline(runSession.polyline);
    _setupMapData();
  }

  // ─── Estado ────────────────────────────────────────────────────────────────

  late final List<LatLng> _polylinePoints;
  final Set<Polyline> polylines = {};
  final Set<Marker> markers = {};

  ProfileEntity? _profile;
  bool _isLoading = false;

  List<LatLng> get polylinePoints => _polylinePoints;
  ProfileEntity? get profile => _profile;
  bool get isLoading => _isLoading;

  /// Cálculo estimado de desidratação (suor): ~10ml por kg por hora.
  /// Usa o peso do perfil quando disponível, senão um valor padrão de 70kg.
  double get dehydrationMl {
    final weightKg = _profile?.weightKg ?? 70.0;
    return (runSession.durationSeconds / 3600) * (weightKg * 10);
  }

  // ─── Ações ─────────────────────────────────────────────────────────────────

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      _profile = await _getProfileUseCase();
    } catch (e) {
      debugPrint('ExerciseDetailsController.loadProfile error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Helpers privados ──────────────────────────────────────────────────────

  List<LatLng> _decodePolyline(String polylineString) {
    if (polylineString.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(polylineString);
      return list.map((element) {
        final lat = double.parse(element[0].toString());
        final lng = double.parse(element[1].toString());
        return LatLng(lat, lng);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  void _setupMapData() {
    if (_polylinePoints.isEmpty) return;

    polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: _polylinePoints,
        color: AppColors.primaryDark,
        width: 5,
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId('start'),
        position: _polylinePoints.first,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId('end'),
        position: _polylinePoints.last,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }
}
