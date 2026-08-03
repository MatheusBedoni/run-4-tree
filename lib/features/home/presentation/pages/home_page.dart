import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:run_4_tree/features/exercises/presentation/pages/exercises_page.dart';

import '../../../../../core/constants/map_styles.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/run_stats_entity.dart';
import '../../domain/usecases/get_run_stats_usecase.dart';
import '../controllers/home_controller.dart';

enum RunState { idle, running, paused }

/// HomePage — Tela principal do Run4Tree.
///
/// Layout baseado no protótipo:
///   • Google Maps em tela cheia com estilo cartoon (Pokémon GO)
///   • Cards flutuantes de stats (clima, árvores, distância)
///   • Avatar do usuário no canto superior esquerdo
///   • Mascote centralizado com animação de pulso + flutuação
///   • Anel de progresso animado na parte inferior
///   • Bottom navigation bar customizada
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // ─── Controller ────────────────────────────────────────────────────────────
  late final HomeController _controller;

  // ─── Animações ─────────────────────────────────────────────────────────────
  late final AnimationController _progressAnimCtrl;
  late final Animation<double> _progressAnim;

  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  late final AnimationController _floatCtrl;
  late final Animation<double> _floatAnim;

  // ─── Mapa ──────────────────────────────────────────────────────────────────
  GoogleMapController? _mapController;

  // ─── Variáveis (preparadas para receber dados reais) ───────────────────────
  String? _userAvatarUrl;
  String? _mascotImageUrl;

  // Posição inicial padrão (São Paulo)
  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-23.550520, -46.633308),
    zoom: 16.5,
  );

  // ─── Nav ───────────────────────────────────────────────────────────────────
  int _selectedNavIndex = 0;

  // ─── Run State ─────────────────────────────────────────────────────────────
  RunState _runState = RunState.idle;
  int _runSeconds = 0;
  Timer? _runTimer;

  // ─── Tracking ──────────────────────────────────────────────────────────────
  List<LatLng> _routePoints = [];
  Set<Polyline> _polylines = {};
  StreamSubscription<Position>? _locationSub;
  double _runDistanceKm = 0.0;
  LatLng? _lastTrackingPosition;

  // ─── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    _controller = HomeController(
      GetRunStatsUseCase(const HomeRepositoryImpl()),
    );
    _controller.addListener(_onStatsLoaded);
    _controller.loadStats();

    // Progresso circular: anima de 0 → valor real quando dados chegam
    _progressAnimCtrl = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );
    _progressAnim = CurvedAnimation(
      parent: _progressAnimCtrl,
      curve: Curves.easeOutCubic,
    );

    // Pulso do mascote
    _pulseCtrl = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.95,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    // Flutuação vertical do mascote
    _floatCtrl = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(
      begin: -6.0,
      end: 6.0,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
  }

  void _onStatsLoaded() {
    if (_controller.stats != null && !_controller.isLoading) {
      _progressAnimCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _runTimer?.cancel();
    _locationSub?.cancel();
    _controller.removeListener(_onStatsLoaded);
    _controller.dispose();
    _progressAnimCtrl.dispose();
    _pulseCtrl.dispose();
    _floatCtrl.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _runState = RunState.running);
    _runTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _runSeconds++);
    });
    _startTracking();
  }

  void _pauseTimer() {
    setState(() => _runState = RunState.paused);
    _runTimer?.cancel();
    _pauseTracking();
  }

  void _resumeTimer() {
    setState(() => _runState = RunState.running);
    _runTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _runSeconds++);
    });
    _resumeTracking();
  }

  void _stopTimer() {
    _runTimer?.cancel();
    _stopTracking();
    setState(() {
      _runState = RunState.idle;
      _runSeconds = 0;
    });
  }

  // ─── GPS Tracking ──────────────────────────────────────────────────────────

  void _startTracking() {
    _routePoints = [];
    _lastTrackingPosition = null;
    _runDistanceKm = 0.0;
    _subscribeToLocationStream();
  }

  void _pauseTracking() {
    _locationSub?.cancel();
    _locationSub = null;
  }

  void _resumeTracking() {
    // Não limpa os pontos ao resumir — continua o trajeto
    _subscribeToLocationStream();
  }

  void _stopTracking() {
    _locationSub?.cancel();
    _locationSub = null;
    setState(() {
      _routePoints = [];
      _polylines = {};
      _runDistanceKm = 0.0;
      _lastTrackingPosition = null;
    });
  }

  void _subscribeToLocationStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 5, // atualiza a cada 5 metros
    );
    _locationSub =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((pos) {
      final newPoint = LatLng(pos.latitude, pos.longitude);
      setState(() {
        if (_lastTrackingPosition != null) {
          final meters = Geolocator.distanceBetween(
            _lastTrackingPosition!.latitude,
            _lastTrackingPosition!.longitude,
            newPoint.latitude,
            newPoint.longitude,
          );
          _runDistanceKm += meters / 1000.0;
        }
        _routePoints.add(newPoint);
        _lastTrackingPosition = newPoint;
        _polylines = {
          Polyline(
            polylineId: const PolylineId('run_route'),
            points: List.from(_routePoints),
            color: AppColors.accentOrange,
            width: 5,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            jointType: JointType.round,
          ),
        };
      });
      // Centraliza o mapa na posição atual durante a corrida
      _mapController?.animateCamera(CameraUpdate.newLatLng(newPoint));
    });
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedNavIndex,
        children: [
          _buildMapPage(),
          const ExercisesPage(),
          const Center(child: Text('Jardim (Em breve)')),
          const Center(child: Text('Perfil (Em breve)')),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildMapPage() {
    return Stack(
      children: [
        // ── 1. Google Maps (tela cheia) ─────────────────────────────────
        _buildMap(),

        // ── 2. Gradient overlay no topo (legibilidade dos cards) ────────
        _buildTopGradient(),

        // ── 3. Gradient overlay na base ─────────────────────────────────
        _buildBottomGradient(),

        // ── 4. Overlay do topo: avatar + stats ──────────────────────────
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserAvatar(),
                const Spacer(),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) {
                    final stats = _controller.stats;
                    if (stats == null) return const SizedBox();
                    return _buildStatsColumn(stats);
                  },
                ),
              ],
            ),
          ),
        ),

        // ── 5. HUD de corrida (tempo + km) ───────────────────────────────
        if (_runState != RunState.idle) _buildRunHUD(),

        // ── 6. Mascote centralizado ──────────────────────────────────────
        if (_runState == RunState.idle) _buildMascotOverlay(),

        // ── 7. Anel de progresso ─────────────────────────────────────────
        if (_runState == RunState.idle) _buildProgressOverlay(),

        // ── 8. Run Controls ──────────────────────────────────────────────
        _buildRunControls(),
      ],
    );
  }

  // ─── Map ───────────────────────────────────────────────────────────────────

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: _initialPosition,
      style: MapStyles.cartoonStyle, // API moderna (não-deprecated)
      onMapCreated: (controller) {
        _mapController = controller;
        _determinePositionAndMoveMap();
      },
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      polylines: _polylines,
    );
  }

  Future<void> _determinePositionAndMoveMap() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Testa se os serviços de localização estão habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Serviços de localização desabilitados.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Permissões de localização negadas.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Permissões de localização permanentemente negadas.');
      return;
    }

    // Permissão concedida, pega a posição
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16.5,
          ),
        ),
      );
      // Força a atualização do estado para garantir que o myLocationEnabled desenhe o ponto se não tinha antes (embora o GoogleMap cuide disso se as permissões mudarem).
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Erro ao obter localização: $e');
    }
  }

  // ─── Gradients ─────────────────────────────────────────────────────────────

  Widget _buildTopGradient() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 180,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x88000000), Colors.transparent],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomGradient() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 260,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xCC000000), Colors.transparent],
          ),
        ),
      ),
    );
  }

  // ─── Avatar ────────────────────────────────────────────────────────────────

  Widget _buildUserAvatar() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.accentOrange, Color(0xFFE67E22)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentOrange.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        image: _userAvatarUrl != null
            ? DecorationImage(
                image: NetworkImage(_userAvatarUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: _userAvatarUrl == null
          ? const Center(
              child: FaIcon(
                FontAwesomeIcons.seedling,
                color: Colors.white,
                size: 20,
              ),
            )
          : null,
    );
  }

  // ─── Stats cards ───────────────────────────────────────────────────────────

  Widget _buildStatsColumn(RunStatsEntity stats) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildStatCard(
          iconWidget: Icon(
            Icons.wb_sunny_rounded,
            color: const Color(0xFFFFC107),
            size: 22,
          ),
          topLine: '${stats.weatherTemp}°',
          bottomLine: null,
        ),
        const SizedBox(height: 8),
        _buildStatCard(
          iconWidget: FaIcon(
            FontAwesomeIcons.tree,
            color: AppColors.primaryLight,
            size: 20,
          ),
          topLine: '${stats.treesPlanted}',
          bottomLine: null,
        ),
        const SizedBox(height: 8),
        _buildStatCard(
          iconWidget: Icon(
            Icons.directions_run_rounded,
            color: AppColors.skyBlue,
            size: 22,
          ),
          topLine: stats.distanceKm.toStringAsFixed(2),
          bottomLine: 'km',
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required Widget iconWidget,
    required String topLine,
    String? bottomLine,
  }) {
    return Container(
      width: 62,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.93),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(height: 5),
          Text(
            topLine,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
          if (bottomLine != null) ...[
            const SizedBox(height: 1),
            Text(
              bottomLine,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Mascote ───────────────────────────────────────────────────────────────

  Widget _buildMascotOverlay() {
    return Positioned(
      left: 0,
      right: 0,
      top: MediaQuery.of(context).size.height * 0.38,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnim, _floatAnim]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnim.value),
            child: Transform.scale(scale: _pulseAnim.value, child: child),
          );
        },
        child: Center(child: _buildMascot()),
      ),
    );
  }

  Widget _buildMascot() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Halo externo pulsante
        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accentOrange.withValues(alpha: 0.25),
          ),
        ),
        // Corpo do mascote
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFC107), AppColors.accentOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentOrange.withValues(alpha: 0.6),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
            image: _mascotImageUrl != null
                ? DecorationImage(
                    image: NetworkImage(_mascotImageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: _mascotImageUrl == null
              ? const Center(
                  child: FaIcon(
                    FontAwesomeIcons.leaf,
                    color: Colors.white,
                    size: 28,
                  ),
                )
              : null,
        ),
      ],
    );
  }

  // ─── Progress ring ─────────────────────────────────────────────────────────

  Widget _buildProgressOverlay() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: kBottomNavigationBarHeight + 24,
      child: Center(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            final targetProgress = _controller.stats?.progressPercent ?? 0.0;
            return AnimatedBuilder(
              animation: _progressAnim,
              builder: (context, _) {
                final animatedProgress = targetProgress * _progressAnim.value;
                return _buildProgressRing(animatedProgress, targetProgress);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressRing(double animatedProgress, double targetProgress) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 88,
          height: 88,
          child: CustomPaint(
            painter: _ProgressRingPainter(progress: animatedProgress),
            child: Center(
              child: Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.progressGreen.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.seedling,
                    color: AppColors.primaryDark,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6,
              ),
            ],
          ),
          child: Text(
            '${(targetProgress * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Run HUD (tempo + km durante a corrida) ───────────────────────────────

  Widget _buildRunHUD() {
    final h = _runSeconds ~/ 3600;
    final m = (_runSeconds % 3600) ~/ 60;
    final s = _runSeconds % 60;
    final timeStr = h > 0
        ? '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}'
        : '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';

    return Positioned(
      top: MediaQuery.of(context).padding.top + 72,
      left: 16,
      right: 16,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _runState == RunState.paused
                ? Colors.amber.withValues(alpha: 0.6)
                : AppColors.accentOrange.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (_runState == RunState.paused
                      ? Colors.amber
                      : AppColors.accentOrange)
                  .withValues(alpha: 0.25),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildHUDStat(
              icon: Icons.timer_rounded,
              value: timeStr,
              label: 'TEMPO',
              color: AppColors.accentOrange,
            ),
            Container(
              width: 1,
              height: 44,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            _buildHUDStat(
              icon: Icons.route_rounded,
              value: _runDistanceKm.toStringAsFixed(2),
              label: 'KM',
              color: AppColors.progressGreen,
            ),
            if (_runState == RunState.paused) ...[
              Container(
                width: 1,
                height: 44,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              _buildHUDStat(
                icon: Icons.pause_circle_rounded,
                value: 'PAUSA',
                label: '',
                color: Colors.amber,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHUDStat({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
            height: 1.1,
          ),
        ),
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: Colors.white.withValues(alpha: 0.55),
              letterSpacing: 1.8,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  // ─── Run Controls ──────────────────────────────────────────────────────────

  Widget _buildRunControls() {
    if (_runState == RunState.idle) {
      return Positioned(
        bottom: kBottomNavigationBarHeight + 140,
        left: 0,
        right: 0,
        child: Center(
          child: ElevatedButton.icon(
            onPressed: _startTimer,
            icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
            label: const Text(
              'INICIAR CORRIDA',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentOrange,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 10,
              shadowColor: AppColors.accentOrange.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    // Controles durante corrida (HUD exibe o tempo/km no topo)
    return Positioned(
      bottom: kBottomNavigationBarHeight + 32,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botão Pause / Resume
          _buildControlButton(
            heroTag: 'pause_resume',
            onPressed: _runState == RunState.running ? _pauseTimer : _resumeTimer,
            icon: _runState == RunState.running
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
            backgroundColor:
                _runState == RunState.running ? Colors.amber : AppColors.progressGreen,
            size: 64,
          ),
          const SizedBox(width: 28),
          // Botão Stop
          _buildControlButton(
            heroTag: 'stop',
            onPressed: _stopTimer,
            icon: Icons.stop_rounded,
            backgroundColor: Colors.redAccent,
            size: 56,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String heroTag,
    required VoidCallback onPressed,
    required IconData icon,
    required Color backgroundColor,
    double size = 60,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.5),
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: size * 0.5),
        ),
      ),
    );
  }

  // ─── Bottom navigation ─────────────────────────────────────────────────────

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.map_rounded, 'Mapa'),
              _buildNavItem(1, Icons.fitness_center_rounded, 'Exercícios'),
              _buildNavItem(2, Icons.local_florist_rounded, 'Jardim'),
              _buildNavItem(3, Icons.person_rounded, 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedNavIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 250),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.navSelected
                    : Colors.grey.shade400,
                size: 24,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppColors.navSelected
                    : Colors.grey.shade400,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Custom Painter: Progress Ring ─────────────────────────────────────────

class _ProgressRingPainter extends CustomPainter {
  final double progress;

  const _ProgressRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 10) / 2;
    const strokeWidth = 7.0;

    // Track (fundo)
    final trackPaint = Paint()
      ..color = AppColors.progressTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    // Progresso com gradiente sweep
    final rect = Rect.fromCircle(center: center, radius: radius);
    final progressPaint = Paint()
      ..shader = const SweepGradient(
        colors: [AppColors.primaryLight, AppColors.progressGreen],
        startAngle: 0,
        endAngle: math.pi * 2,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2, // começa do topo
      2 * math.pi * progress, // varre o arco proporcional
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter old) => old.progress != progress;
}
