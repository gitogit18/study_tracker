import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class DurationSelectionDialog extends StatelessWidget {
  const DurationSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Duration',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'How long do you want to study?',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.muted,
              ),
            ),
            const SizedBox(height: 24),
            _buildOption(context, '15 Minutes', const Duration(minutes: 15)),
            _buildOption(context, '25 Minutes', const Duration(minutes: 25)),
            _buildOption(context, '45 Minutes', const Duration(minutes: 45)),
            _buildOption(context, 'No Limit', Duration.zero),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL', style: TextStyle(color: AppTheme.muted)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, String title, Duration? duration) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppTheme.ink,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.muted),
      onTap: () => Navigator.pop(context, duration),
    );
  }
}

Future<Duration?> showDurationSelectionDialog(BuildContext context) {
  return showDialog<Duration?>(
    context: context,
    builder: (context) => const DurationSelectionDialog(),
  );
}
