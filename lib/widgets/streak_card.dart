import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({
    super.key,
    required this.streak,
    required this.freezes,
    required this.onTap,
  });

  final int streak;
  final int freezes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Text(
              '🔥',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$streak day streak',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.ink,
                    ),
                  ),
                  Text(
                    '$freezes freezes available',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.muted,
            ),
          ],
        ),
      ),
    );
  }
}
