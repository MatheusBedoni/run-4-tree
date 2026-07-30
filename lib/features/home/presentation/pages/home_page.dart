import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  // Posição inicial — São Paulo (ajustar com geolocator em produção)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-23.550520, -46.633308),
    zoom: 16.5,
  );

  // ─── Nav ───────────────────────────────────────────────────────────────────
  int _selectedNavIndex = 0;

  // ─── Run State ─────────────────────────────────────────────────────────────
  RunState _runState = RunState.idle;
  int _runSeconds = 0;
  Timer? _runTimer;

  // ─── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    _controller = HomeController(GetRunStatsUseCase(const HomeRepositoryImpl()));
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
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.06).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Flutuação vertical do mascote
    _floatCtrl = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );
  }

  void _onStatsLoaded() {
    if (_controller.stats != null && !_controller.isLoading) {
      _progressAnimCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _runTimer?.cancel();
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
  }

  void _pauseTimer() {
    setState(() => _runState = RunState.paused);
    _runTimer?.cancel();
  }

  void _resumeTimer() {
    setState(() => _runState = RunState.running);
    _runTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _runSeconds++);
    });
  }

  void _stopTimer() {
    setState(() {
      _runState = RunState.idle;
      _runSeconds = 0;
    });
    _runTimer?.cancel();
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
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

          // ── 5. Mascote centralizado ──────────────────────────────────────
          _buildMascotOverlay(),

          // ── 6. Anel de progresso ─────────────────────────────────────────
          _buildProgressOverlay(),

          // ── 7. Run Controls ──────────────────────────────────────────────
          _buildRunControls(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
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
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
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
            colors: [
              Color(0x88000000),
              Colors.transparent,
            ],
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
            colors: [
              Color(0xCC000000),
              Colors.transparent,
            ],
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
      ),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.seedling,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  // ─── Stats cards ───────────────────────────────────────────────────────────

  Widget _buildStatsColumn(RunStatsEntity stats) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildStatCard(
          iconWidget: Icon(Icons.wb_sunny_rounded,
              color: const Color(0xFFFFC107), size: 22),
          topLine: '${stats.weatherTemp}°',
          bottomLine: null,
        ),
        const SizedBox(height: 8),
        _buildStatCard(
          iconWidget: FaIcon(FontAwesomeIcons.tree,
              color: AppColors.primaryLight, size: 20),
          topLine: '${stats.treesPlanted}',
          bottomLine: null,
        ),
        const SizedBox(height: 8),
        _buildStatCard(
          iconWidget: Icon(Icons.directions_run_rounded,
              color: AppColors.skyBlue, size: 22),
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
            child: Transform.scale(
              scale: _pulseAnim.value,
              child: child,
            ),
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
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.leaf,
              color: Colors.white,
              size: 28,
            ),
          ),
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

  // ─── Run Controls ──────────────────────────────────────────────────────────

  Widget _buildRunControls() {
    if (_runState == RunState.idle) {
      return Positioned(
        bottom: kBottomNavigationBarHeight + 140,
        left: 0,
        right: 0,
        child: Center(
          child: ElevatedButton(
            onPressed: _startTimer,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentOrange,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 8,
            ),
            child: const Text(
              'START RUN',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    final hours = _runSeconds ~/ 3600;
    final minutes = (_runSeconds % 3600) ~/ 60;
    final seconds = _runSeconds % 60;
    final timeStr = hours > 0
        ? '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
        : '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Positioned(
      bottom: kBottomNavigationBarHeight + 130,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              timeStr,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: 'pause_resume',
                onPressed: _runState == RunState.running ? _pauseTimer : _resumeTimer,
                backgroundColor: _runState == RunState.running ? Colors.amber : AppColors.progressGreen,
                child: Icon(_runState == RunState.running ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                heroTag: 'stop',
                onPressed: _stopTimer,
                backgroundColor: Colors.redAccent,
                child: const Icon(Icons.stop_rounded, color: Colors.white, size: 32),
              ),
            ],
          ),
        ],
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
              _buildNavItem(0, Icons.map_rounded, 'Map'),
              _buildNavItem(1, Icons.assignment_rounded, 'Quests'),
              _buildNavItem(2, Icons.local_florist_rounded, 'Garden'),
              _buildNavItem(3, Icons.person_rounded, 'Profile'),
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
                color: isSelected ? AppColors.navSelected : Colors.grey.shade400,
                size: 24,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.navSelected : Colors.grey.shade400,
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
      -math.pi / 2,           // começa do topo
      2 * math.pi * progress,  // varre o arco proporcional
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter old) => old.progress != progress;
}
