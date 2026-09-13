import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../garden/domain/entities/tree_progress_entity.dart';

/// Momento da corrida em que o anúncio bloqueante aparece — define a
/// identidade visual (cores, ícone e textos) da tela de carregamento.
enum RunAdPhase {
  /// Antes de começar a corrida.
  start,

  /// Depois de encerrar a corrida, enquanto a sessão é salva.
  finish,
}

/// Etapas que a tela atravessa: espera do anúncio → resultado.
enum RunAdOverlayStatus {
  /// Anúncio carregando/sendo exibido.
  loading,

  /// Anúncio assistido: a receita virou sementes (e talvez uma árvore).
  rewarded,

  /// Anúncio falhou ou foi fechado antes do fim — nenhuma semente.
  missed,
}

/// Estado da tela de anúncio, controlado por quem dispara o anúncio.
///
/// A tela não some assim que o anúncio termina: ela vira a prova do loop
/// anúncio → sementes → árvore real, mostrando na hora o que aquele anúncio
/// rendeu. É esse momento que deixa claro de onde vem o progresso de plantio.
class RunAdOverlayController extends ChangeNotifier {
  final RunAdPhase phase;

  /// Sementes antes do anúncio. `null` quando os stats ainda não carregaram —
  /// nesse caso o ganho não é exibido, só o total resultante.
  final int? seedsBefore;

  final int? _treesBefore;

  RunAdOverlayController({
    required this.phase,
    double? progressBefore,
    int? treesBefore,
  }) : seedsBefore = progressBefore == null
           ? null
           : (progressBefore * TreeProgressEntity.seedsPerTree).floor().clamp(
               0,
               TreeProgressEntity.seedsPerTree,
             ),
       _treesBefore = treesBefore;

  RunAdOverlayStatus _status = RunAdOverlayStatus.loading;
  RunAdOverlayStatus get status => _status;

  int _seedsAfter = 0;
  int _treesAfter = 0;

  /// Marca o anúncio como assistido e creditado.
  void markRewarded(TreeProgressEntity progress) {
    _seedsAfter = progress.seedsAccumulated;
    _treesAfter = progress.treesPlanted;
    _status = RunAdOverlayStatus.rewarded;
    notifyListeners();
  }

  /// Marca que nenhuma semente foi creditada (falha ou anúncio dispensado).
  void markMissed() {
    if (_status != RunAdOverlayStatus.loading) return;
    _status = RunAdOverlayStatus.missed;
    notifyListeners();
  }

  /// Árvores fechadas por este anúncio (normalmente 0 ou 1).
  int get treesGained {
    final before = _treesBefore;
    if (before == null || _status != RunAdOverlayStatus.rewarded) return 0;
    return math.max(0, _treesAfter - before);
  }

  /// Sementes ganhas neste anúncio. `null` quando não há base de comparação.
  int? get seedsGained {
    final before = seedsBefore;
    if (before == null || _status != RunAdOverlayStatus.rewarded) return null;
    if (treesGained > 0) {
      // O medidor "virou": completou a árvore e recomeçou do resto.
      return (TreeProgressEntity.seedsPerTree - before) +
          _seedsAfter +
          (treesGained - 1) * TreeProgressEntity.seedsPerTree;
    }
    return math.max(0, _seedsAfter - before);
  }

  /// Quantas sementes o medidor deve mostrar no estado atual.
  int get displayedSeeds {
    switch (_status) {
      case RunAdOverlayStatus.loading:
      case RunAdOverlayStatus.missed:
        return seedsBefore ?? 0;
      case RunAdOverlayStatus.rewarded:
        return treesGained > 0 ? TreeProgressEntity.seedsPerTree : _seedsAfter;
    }
  }
}

/// Paleta e ícone de cada fase, para manter o build enxuto.
class _PhaseStyle {
  final List<Color> background;
  final Color accent;
  final Color glow;
  final FaIconData icon;

  const _PhaseStyle({
    required this.background,
    required this.accent,
    required this.glow,
    required this.icon,
  });

  static const start = _PhaseStyle(
    background: [
      AppColors.progressGreen,
      AppColors.primaryLight,
      AppColors.primaryDark,
    ],
    accent: AppColors.progressGreen,
    glow: AppColors.white,
    icon: FontAwesomeIcons.personRunning,
  );

  static const finish = _PhaseStyle(
    background: [
      AppColors.primaryDark,
      AppColors.primaryLight,
      AppColors.accentOrange,
    ],
    accent: AppColors.accentOrange,
    glow: Color(0xFFFFC776),
    icon: FontAwesomeIcons.seedling,
  );
}

/// Tela cheia exibida enquanto o anúncio recompensado carrega, roda e credita.
///
/// Substitui o antigo "fundo preto + CircularProgressIndicator" e, mais
/// importante, explica o modelo do app enquanto o usuário espera: a trilha
/// anúncio → sementes → árvore real fica visível no topo e o medidor de
/// sementes mostra, na hora, o que aquele anúncio rendeu.
class RunAdLoadingOverlay extends StatefulWidget {
  final RunAdOverlayController controller;

  const RunAdLoadingOverlay({super.key, required this.controller});

  @override
  State<RunAdLoadingOverlay> createState() => _RunAdLoadingOverlayState();
}

class _RunAdLoadingOverlayState extends State<RunAdLoadingOverlay>
    with TickerProviderStateMixin {
  /// Rotação do anel orbital e dos satélites (loop contínuo).
  late final AnimationController _orbitCtrl;

  /// Respiração do núcleo central + do brilho de fundo.
  late final AnimationController _breathCtrl;

  /// Ondas que se expandem a partir do centro.
  late final AnimationController _rippleCtrl;

  /// Partículas do fundo.
  late final AnimationController _particleCtrl;

  /// Entrada (fade + slide) dos textos.
  late final AnimationController _entryCtrl;

  /// Alterna a dica exibida enquanto o anúncio carrega.
  Timer? _tipTimer;
  int _tipIndex = 0;

  @override
  void initState() {
    super.initState();

    _orbitCtrl = AnimationController(
      duration: const Duration(milliseconds: 4200),
      vsync: this,
    )..repeat();

    _breathCtrl = AnimationController(
      duration: const Duration(milliseconds: 1700),
      vsync: this,
    )..repeat(reverse: true);

    _rippleCtrl = AnimationController(
      duration: const Duration(milliseconds: 2600),
      vsync: this,
    )..repeat();

    _particleCtrl = AnimationController(
      duration: const Duration(seconds: 14),
      vsync: this,
    )..repeat();

    _entryCtrl = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..forward();

    _tipTimer = Timer.periodic(const Duration(milliseconds: 3400), (_) {
      if (!mounted) return;
      setState(() => _tipIndex++);
    });
  }

  @override
  void dispose() {
    _tipTimer?.cancel();
    _orbitCtrl.dispose();
    _breathCtrl.dispose();
    _rippleCtrl.dispose();
    _particleCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  _PhaseStyle get _style => widget.controller.phase == RunAdPhase.start
      ? _PhaseStyle.start
      : _PhaseStyle.finish;

  @override
  Widget build(BuildContext context) {
    final style = _style;

    // Bloqueia o "voltar" — o fluxo só sai daqui quando o anúncio termina.
    return PopScope(
      canPop: false,
      child: Material(
        color: Colors.transparent,
        child: ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            final l10n = AppLocalizations.of(context)!;
            final controller = widget.controller;
            final status = controller.status;

            return Stack(
              fit: StackFit.expand,
              children: [
                _buildBackground(style),
                _buildParticles(style),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        _buildLoopTrack(l10n, style, status),
                        const Spacer(),
                        _buildOrbitScene(style, controller),
                        const SizedBox(height: 26),
                        _buildTexts(l10n, controller),
                        const SizedBox(height: 22),
                        _buildSeedMeter(l10n, style, controller),
                        const Spacer(),
                        _buildBottomSlot(l10n, style, status),
                        const SizedBox(height: 16),
                        _buildProgressBar(style, status),
                        const SizedBox(height: 12),
                        Text(
                          l10n.homeRunAdFooterNote,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.45),
                            fontSize: 11,
                            letterSpacing: 0.4,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ─── Fundo ─────────────────────────────────────────────────────────────────

  Widget _buildBackground(_PhaseStyle style) {
    return AnimatedBuilder(
      animation: _breathCtrl,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(_breathCtrl.value);
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.35 - 0.06 * t),
              radius: 1.1 + 0.15 * t,
              colors: style.background,
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticles(_PhaseStyle style) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _particleCtrl,
        builder: (context, _) => CustomPaint(
          painter: _ParticleFieldPainter(
            progress: _particleCtrl.value,
            color: style.glow,
          ),
        ),
      ),
    );
  }

  // ─── Trilha do loop: anúncio → sementes → árvore real ─────────────────────

  Widget _buildLoopTrack(
    AppLocalizations l10n,
    _PhaseStyle style,
    RunAdOverlayStatus status,
  ) {
    // Etapa acesa: enquanto carrega só a 1ª; creditado, acende as três.
    final activeStep = status == RunAdOverlayStatus.rewarded ? 2 : 0;

    final steps = <(IconData, String)>[
      (Icons.play_circle_fill_rounded, l10n.homeRunAdLoopWatch),
      (Icons.eco_rounded, l10n.homeRunAdLoopSeeds),
      (Icons.park_rounded, l10n.homeRunAdLoopTree),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 13,
                color: Colors.white.withValues(
                  alpha: i <= activeStep ? 0.6 : 0.25,
                ),
              ),
            ),
          Flexible(
            child: _buildLoopStep(
              icon: steps[i].$1,
              label: steps[i].$2,
              isActive: i <= activeStep,
              isCurrent: i == activeStep,
              style: style,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLoopStep({
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isCurrent,
    required _PhaseStyle style,
  }) {
    return AnimatedBuilder(
      animation: _breathCtrl,
      builder: (context, child) {
        // Só a etapa corrente pulsa, para o olho seguir a sequência.
        final t = isCurrent
            ? Curves.easeInOut.transform(_breathCtrl.value)
            : 0.0;
        return Transform.scale(scale: 1 + 0.04 * t, child: child);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        decoration: BoxDecoration(
          color: isActive
              ? style.accent.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? style.glow.withValues(alpha: 0.55)
                : Colors.white.withValues(alpha: 0.10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive
                  ? style.glow
                  : Colors.white.withValues(alpha: 0.35),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isActive
                      ? Colors.white.withValues(alpha: 0.92)
                      : Colors.white.withValues(alpha: 0.4),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Cena central (ondas + anel + satélites + núcleo) ─────────────────────

  Widget _buildOrbitScene(
    _PhaseStyle style,
    RunAdOverlayController controller,
  ) {
    final isRewarded = controller.status == RunAdOverlayStatus.rewarded;
    final plantedTree = controller.treesGained > 0;

    final coreIcon = plantedTree
        ? FontAwesomeIcons.tree
        : isRewarded
        ? FontAwesomeIcons.seedling
        : style.icon;

    return SizedBox(
      width: 210,
      height: 210,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _rippleCtrl,
            builder: (context, _) => CustomPaint(
              size: const Size.square(210),
              painter: _RipplePainter(
                progress: _rippleCtrl.value,
                color: style.glow,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _orbitCtrl,
            builder: (context, _) => CustomPaint(
              size: const Size.square(182),
              painter: _OrbitRingPainter(
                rotation: _orbitCtrl.value,
                accent: style.accent,
                glow: style.glow,
              ),
            ),
          ),
          // Satélites (folhinhas orbitando o núcleo)
          AnimatedBuilder(
            animation: _orbitCtrl,
            builder: (context, _) {
              final angle = _orbitCtrl.value * 2 * math.pi;
              return Stack(
                alignment: Alignment.center,
                children: List.generate(3, (i) {
                  final a = angle + (i * 2 * math.pi / 3);
                  const radius = 91.0;
                  return Transform.translate(
                    offset: Offset(math.cos(a) * radius, math.sin(a) * radius),
                    child: Transform.rotate(
                      angle: a + math.pi / 2,
                      child: Icon(
                        i.isEven ? Icons.eco_rounded : Icons.park_rounded,
                        size: i.isEven ? 18 : 14,
                        color: style.glow.withValues(alpha: 0.85),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          // Núcleo branco com o ícone do estado atual
          AnimatedBuilder(
            animation: _breathCtrl,
            builder: (context, child) {
              final t = Curves.easeInOut.transform(_breathCtrl.value);
              return Transform.scale(scale: 0.96 + 0.08 * t, child: child);
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: style.glow.withValues(alpha: 0.45),
                    blurRadius: 34,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: FaIcon(
                    coreIcon,
                    key: ValueKey(coreIcon.codePoint),
                    size: 38,
                    color: style.accent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Textos ────────────────────────────────────────────────────────────────

  Widget _buildTexts(AppLocalizations l10n, RunAdOverlayController controller) {
    final isStart = controller.phase == RunAdPhase.start;
    final gained = controller.seedsGained;

    final (title, subtitle) = switch (controller.status) {
      RunAdOverlayStatus.loading =>
        isStart
            ? (l10n.homeRunAdStartTitle, l10n.homeRunAdStartSubtitle)
            : (l10n.homeRunAdFinishTitle, l10n.homeRunAdFinishSubtitle),
      RunAdOverlayStatus.rewarded =>
        controller.treesGained > 0
            ? (l10n.homeRunAdTreeTitle, l10n.homeRunAdTreeSubtitle)
            : (
                gained != null && gained > 0
                    ? l10n.homeRunAdSeedsEarnedTitle(gained)
                    : l10n.homeRunAdRewardTitle,
                l10n.homeRunAdRewardSubtitle,
              ),
      RunAdOverlayStatus.missed => (
        l10n.homeRunAdMissedTitle,
        l10n.homeRunAdMissedSubtitle,
      ),
    };

    final fade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Column(
            key: ValueKey(title),
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: GoogleFonts.bebasNeue().fontFamily,
                  letterSpacing: 2.0,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Medidor de sementes ───────────────────────────────────────────────────

  Widget _buildSeedMeter(
    AppLocalizations l10n,
    _PhaseStyle style,
    RunAdOverlayController controller,
  ) {
    const total = TreeProgressEntity.seedsPerTree;
    final seeds = controller.displayedSeeds;
    final gained = controller.seedsGained;

    return Column(
      children: [
        // Preenche animando do valor anterior para o creditado.
        TweenAnimationBuilder<double>(
          tween: Tween(
            begin: (controller.seedsBefore ?? 0).toDouble(),
            end: seeds.toDouble(),
          ),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(total, (i) {
              final fill = (value - i).clamp(0.0, 1.0);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Transform.scale(
                  scale: 0.8 + 0.25 * fill,
                  child: Icon(
                    fill > 0 ? Icons.eco_rounded : Icons.eco_outlined,
                    size: 18,
                    color: Color.lerp(
                      Colors.white.withValues(alpha: 0.22),
                      style.glow,
                      fill,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.homeRunAdSeedsToNextTree(seeds, total),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            if (gained != null && gained > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: style.accent.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: style.glow.withValues(alpha: 0.5)),
                ),
                child: Text(
                  l10n.homeRunAdSeedsGainedBadge(gained),
                  style: TextStyle(
                    color: style.glow,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // ─── Slot inferior: dica (carregando) ou explicação do crédito ────────────

  Widget _buildBottomSlot(
    AppLocalizations l10n,
    _PhaseStyle style,
    RunAdOverlayStatus status,
  ) {
    final tips = [
      l10n.homeRunAdTip1,
      l10n.homeRunAdTip2,
      l10n.homeRunAdTip3,
      l10n.homeRunAdTip4,
    ];

    final (icon, text) = switch (status) {
      RunAdOverlayStatus.loading => (
        Icons.lightbulb_outline_rounded,
        tips[_tipIndex % tips.length],
      ),
      RunAdOverlayStatus.rewarded => (
        Icons.verified_rounded,
        l10n.homeRunAdRewardExplainer,
      ),
      RunAdOverlayStatus.missed => (
        Icons.info_outline_rounded,
        l10n.homeRunAdMissedExplainer,
      ),
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.25),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: Container(
        key: ValueKey(text),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: style.glow.withValues(alpha: 0.9)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Barra de progresso indeterminada ──────────────────────────────────────

  Widget _buildProgressBar(_PhaseStyle style, RunAdOverlayStatus status) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: SizedBox(
        height: 5,
        child: LinearProgressIndicator(
          // Depois do anúncio não há mais espera: a barra fica cheia.
          value: status == RunAdOverlayStatus.loading ? null : 1.0,
          backgroundColor: Colors.white.withValues(alpha: 0.12),
          valueColor: AlwaysStoppedAnimation<Color>(style.accent),
        ),
      ),
    );
  }
}

// ─── Painters ────────────────────────────────────────────────────────────────

/// Vaga-lumes/folhas subindo lentamente ao fundo.
class _ParticleFieldPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ParticleFieldPainter({required this.progress, required this.color});

  // Semente fixa: as partículas ficam estáveis entre repaints.
  static final math.Random _random = math.Random(42);
  static final List<_Particle> _particles = List.generate(
    26,
    (_) => _Particle(
      x: _random.nextDouble(),
      seed: _random.nextDouble(),
      radius: 1.2 + _random.nextDouble() * 2.6,
      speed: 0.6 + _random.nextDouble() * 0.9,
      drift: (_random.nextDouble() - 0.5) * 0.08,
    ),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in _particles) {
      final t = (p.seed + progress * p.speed) % 1.0;
      final y = size.height * (1.05 - t * 1.1);
      final x =
          size.width * (p.x + math.sin((t + p.seed) * 2 * math.pi) * p.drift);

      // Some nas pontas para a partícula não "piscar" ao reaparecer.
      final alpha = math.sin(t * math.pi).clamp(0.0, 1.0) * 0.5;
      paint.color = color.withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticleFieldPainter old) => old.progress != progress;
}

class _Particle {
  final double x;
  final double seed;
  final double radius;
  final double speed;
  final double drift;

  const _Particle({
    required this.x,
    required this.seed,
    required this.radius,
    required this.speed,
    required this.drift,
  });
}

/// Anel com marcas tracejadas girando + arco de varredura com degradê.
class _OrbitRingPainter extends CustomPainter {
  final double rotation;
  final Color accent;
  final Color glow;

  _OrbitRingPainter({
    required this.rotation,
    required this.accent,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Trilho
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Marcas girando no sentido contrário ao do arco
    final tickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    const ticks = 36;
    for (var i = 0; i < ticks; i++) {
      final a = -rotation * 2 * math.pi + (i * 2 * math.pi / ticks);
      final direction = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(
        center + direction * (radius + 8),
        center + direction * (radius + 14),
        tickPaint,
      );
    }

    // Arco de varredura (indeterminado)
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          accent.withValues(alpha: 0.0),
          accent.withValues(alpha: 0.6),
          glow,
        ],
        stops: const [0.0, 0.65, 1.0],
        startAngle: 0,
        endAngle: math.pi * 2,
        transform: GradientRotation(rotation * 2 * math.pi),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      rotation * 2 * math.pi,
      math.pi * 1.35,
      false,
      sweepPaint,
    );
  }

  @override
  bool shouldRepaint(_OrbitRingPainter old) => old.rotation != rotation;
}

/// Ondas concêntricas saindo do núcleo.
class _RipplePainter extends CustomPainter {
  final double progress;
  final Color color;

  _RipplePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const waves = 3;

    for (var i = 0; i < waves; i++) {
      final t = (progress + i / waves) % 1.0;
      final radius = 50 + t * 56;
      final alpha = (1 - t) * 0.35;
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = color.withValues(alpha: alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2 * (1 - t) + 0.6,
      );
    }
  }

  @override
  bool shouldRepaint(_RipplePainter old) => old.progress != progress;
}
