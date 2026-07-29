import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9), Color(0xFFA5D6A7)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          // Main White Card
                          Container(
                            padding: const EdgeInsets.all(32.0),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryDark.withOpacity(
                                    0.08,
                                  ),
                                  blurRadius: 30,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Tree Icon com fundo degradê
                                Container(
                                  width: 88,
                                  height: 88,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFE8F5E9),
                                        Color(0xFFA5D6A7),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryLight
                                            .withOpacity(0.25),
                                        blurRadius: 16,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.tree,
                                      color: AppColors.primaryDark,
                                      size: 42,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // App name
                                Text(
                                  'Run4Tree',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.primaryDark,
                                        letterSpacing: -0.5,
                                      ),
                                ),
                                const SizedBox(height: 10),

                                // Subtitle
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(height: 1.5),
                                    children: [
                                      const TextSpan(
                                        text: 'Sua corrida planta ',
                                      ),
                                      TextSpan(
                                        text: 'árvores reais.\n',
                                        style: const TextStyle(
                                          color: AppColors.primaryLight,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: 'Funciona 100% offline.',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 36),

                                // Divisor com ícone
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: Colors.grey.shade200,
                                        thickness: 1.5,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Icon(
                                        Icons.eco_rounded,
                                        color: AppColors.primaryLight,
                                        size: 20,
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.grey.shade200,
                                        thickness: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 28),

                                // Feature rows
                                _buildFeatureRow(
                                  Icons.wifi_off_rounded,
                                  'Sem internet necessária',
                                  'Registre corridas em qualquer lugar',
                                ),
                                const SizedBox(height: 14),
                                _buildFeatureRow(
                                  Icons.lock_open_rounded,
                                  'Sem cadastro ou senha',
                                  'Comece a correr em segundos',
                                ),
                                const SizedBox(height: 14),
                                _buildFeatureRow(
                                  FontAwesomeIcons.tree,
                                  'Cada km vira uma árvore',
                                  'Acompanhe seu impacto real',
                                  isFa: true,
                                ),
                                const SizedBox(height: 36),

                                // Botão principal
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/home',
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.directions_run_rounded,
                                      size: 22,
                                    ),
                                    label: const Text(
                                      'Começar agora',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Counter social proof
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.tree,
                                        size: 14,
                                        color: AppColors.primaryDark,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '12.430 árvores já plantadas pela comunidade',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontSize: 11,
                                              color: AppColors.primaryDark,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Bottom Chips
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildChip(
                                context,
                                Icons.check_circle_outline_rounded,
                                'SUSTENTÁVEL',
                              ),
                              const SizedBox(width: 12),
                              _buildChip(
                                context,
                                Icons.bolt_rounded,
                                'GAMIFICADO',
                              ),
                              const SizedBox(width: 12),
                              _buildChip(
                                context,
                                Icons.wifi_off_rounded,
                                'OFFLINE',
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(
    dynamic icon,
    String title,
    String subtitle, {
    bool isFa = false,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              icon as IconData,
              size: 22,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryDark),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
