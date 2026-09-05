import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../viewmodels/streak_view_model.dart';
import '../../widgets/streak_calendar.dart';
import '../../core/utils/formatters.dart';

class StreakView extends StatefulWidget {
  const StreakView({super.key, required this.viewModel});

  final StreakViewModel viewModel;

  @override
  State<StreakView> createState() => _StreakViewState();
}

class _StreakViewState extends State<StreakView> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final viewModel = widget.viewModel;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Streak'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetrics(viewModel),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: StreakCalendar(
                    dailyStatus: viewModel.dailyStatus,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 30),
                if (_selectedDate != null) _buildDayDetails(viewModel, _selectedDate!),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetrics(StreakViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Current Streak',
            '${viewModel.currentStreak}',
            'days',
            '🔥',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            'Longest Streak',
            '${viewModel.longestStreak}',
            'days',
            '🏆',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            'Freezes',
            '${viewModel.freezesAvailable}',
            '/ 2',
            '❄️',
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, String unit, String emoji) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.ink,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayDetails(StreakViewModel viewModel, DateTime date) {
    final status = viewModel.getStatusForDate(date);
    final sessions = viewModel.repository.sessions.where((s) {
      return s.startedAt.year == date.year &&
          s.startedAt.month == date.month &&
          s.startedAt.day == date.day;
    }).toList();

    final totalDuration = sessions.fold(
      Duration.zero,
      (sum, s) => sum + s.duration,
    );

    final minutesVal = viewModel.repository.settings['dailyGoalMinutes'];
    int dailyGoalMinutes = 60;
    if (minutesVal is num) {
      dailyGoalMinutes = minutesVal.toInt();
    } else if (minutesVal is String) {
      dailyGoalMinutes = int.tryParse(minutesVal) ?? 60;
    }
    final dailyGoal = Duration(minutes: dailyGoalMinutes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details for ${_getMonthName(date.month)} ${date.day}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.ink,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Column(
            children: [
              _buildDetailRow('Status', _statusToString(status)),
              const Divider(height: 24),
              _buildDetailRow('Goal', formatDuration(dailyGoal)),
              const Divider(height: 24),
              _buildDetailRow('Total Time', formatDuration(totalDuration)),
              const Divider(height: 24),
              _buildDetailRow('Sessions', '${sessions.length}'),
              const Divider(height: 24),
              _buildDetailRow('Goal Reached', totalDuration >= dailyGoal ? 'Yes' : 'No'),
              if (status == StreakStatus.freezeUsed) ...[
                const Divider(height: 24),
                _buildDetailRow('Freeze Used', 'Yes'),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppTheme.muted),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.ink,
          ),
        ),
      ],
    );
  }

  String _statusToString(StreakStatus status) {
    switch (status) {
      case StreakStatus.completed: return 'Completed';
      case StreakStatus.freezeUsed: return 'Freeze Used';
      case StreakStatus.missed: return 'Missed';
      case StreakStatus.noData: return 'No Activity';
      case StreakStatus.future: return 'Future';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
