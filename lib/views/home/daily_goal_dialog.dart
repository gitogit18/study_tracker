import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class DailyGoalDialog extends StatefulWidget {
  const DailyGoalDialog({super.key});

  @override
  State<DailyGoalDialog> createState() => _DailyGoalDialogState();
}

class _DailyGoalDialogState extends State<DailyGoalDialog> {
  final _customController = TextEditingController();
  int? _selectedMinutes;
  String? _errorText;

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _validate(String val) {
    if (val.isEmpty) {
      setState(() => _errorText = null);
      return;
    }

    final minutes = int.tryParse(val);
    setState(() {
      if (minutes == null) {
        _errorText = 'Please enter a valid number';
      } else if (minutes < 10) {
        _errorText = 'Minimal 10 minutes';
      } else {
        _errorText = null;
      }
    });
  }

  bool get _isValid {
    int? minutes;
    if (_selectedMinutes != null) {
      minutes = _selectedMinutes;
    } else if (_customController.text.isNotEmpty) {
      minutes = int.tryParse(_customController.text);
    }
    return minutes != null && minutes >= 10;
  }

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
              'Daily Commitment',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Set your study goal for today.',
              style: TextStyle(fontSize: 16, color: AppTheme.muted),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildQuickOption(30, '30m'),
                _buildQuickOption(45, '45m'),
                _buildQuickOption(60, '60m'),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'OR CUSTOM (MINUTES)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: AppTheme.muted,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _customController,
              keyboardType: TextInputType.number,
              onChanged: (val) {
                if (val.isNotEmpty) {
                  setState(() {
                    _selectedMinutes = null;
                  });
                  _validate(val);
                } else {
                  setState(() => _errorText = null);
                }
              },
              decoration: InputDecoration(
                hintText: 'e.g. 120',
                filled: true,
                fillColor: AppTheme.divider.withValues(alpha: 0.2),
                errorText: _errorText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isValid ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.ink,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppTheme.muted,
                  disabledForegroundColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Set Goal',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickOption(int minutes, String label) {
    final isSelected = _selectedMinutes == minutes;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedMinutes = selected ? minutes : null;
          if (selected) _customController.clear();
        });
      },
      selectedColor: AppTheme.primary.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primary : AppTheme.ink,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  void _submit() {
    int? minutes;
    if (_selectedMinutes != null) {
      minutes = _selectedMinutes;
    } else if (_customController.text.isNotEmpty) {
      minutes = int.tryParse(_customController.text);
    }

    if (minutes != null) {
      if (minutes < 10) {
        setState(() => _errorText = 'Minimal 10 minutes');
        return;
      }
      Navigator.pop(context, Duration(minutes: minutes));
    }
  }
}

Future<Duration?> showDailyGoalDialog(BuildContext context) {
  return showDialog<Duration?>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const DailyGoalDialog(),
  );
}
