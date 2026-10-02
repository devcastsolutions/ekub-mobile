import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/dashboard_entities.dart';

class RoundStatusCard extends StatelessWidget {
  final EkubRound round;

  const RoundStatusCard({super.key, required this.round});

  @override
  Widget build(BuildContext context) {
    final isOpen = round.status == 'open';
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isOpen ? AppColors.accent.withOpacity(0.2) : AppColors.success.withOpacity(0.2),
              child: Text(
                '#${round.roundNumber}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isOpen ? AppColors.accent : AppColors.success,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  Text(
                    'Round ${round.roundNumber}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text('Due Date: ${round.dueDate}', style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
            Chip(
              label: Text(round.status.toUpperCase()),
              backgroundColor: isOpen ? AppColors.accent.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
              labelStyle: TextStyle(
                color: isOpen ? AppColors.accent : AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
