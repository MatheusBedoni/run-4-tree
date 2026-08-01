import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class ExercisesPage extends StatelessWidget {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Corridas e Exercícios',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          bottom: const TabBar(
            labelColor: AppColors.primaryDark,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primaryDark,
            tabs: [
              Tab(text: 'Corridas', icon: Icon(Icons.directions_run_rounded)),
              Tab(text: 'Exercícios', icon: Icon(Icons.fitness_center_rounded)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Esqueleto da aba de Corridas
            Center(
              child: Text(
                'Histórico de Corridas em breve...',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            ),
            // Esqueleto da aba de Exercícios
            Center(
              child: Text(
                'Lista de Exercícios em breve...',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
