import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../viewmodels/stats_view_model.dart';

class StatsView extends StatelessWidget {
  const StatsView({
    super.key,
    required this.viewModel,
  });

  final StatsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                32,
                28,
                32,
                40,
              ),
              children: [
                const Text(
                  'Statistics',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.2,
                    color: AppTheme.ink,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  _dateRange(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppTheme.muted,
                  ),
                ),

                const SizedBox(height: 42),

                _buildWeeklyChart(),

                const SizedBox(height: 28),

                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'TOTAL SESSIONS',
                        value:
                        '${viewModel.totalSessions}',
                        unit: 'sessions',
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: _buildStatCard(
                        title: 'AVG DURATION',
                        value:
                        '${viewModel.averageDurationMinutes}',
                        unit: 'min',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                _buildTotalStudyTime(),

                const SizedBox(height: 28),

                _buildSubjectBreakdown(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeeklyChart() {
    final weeklyMinutes =
        viewModel.weeklyStudyMinutes;

    final maxMinutes = weeklyMinutes.isEmpty
        ? 1
        : weeklyMinutes.reduce(
          (a, b) => a > b ? a : b,
    );

    const labels = [
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
      'S',
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(
        28,
        28,
        28,
        26,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'WEEKLY STUDY HOURS',
            style: TextStyle(
              fontSize: 17,
              letterSpacing: 1.4,
              color: AppTheme.muted,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 50),

          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.end,
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: List.generate(
                7,
                    (index) {
                  final minutes =
                  weeklyMinutes[index];

                  final height = minutes == 0
                      ? 7.0
                      : 7 +
                      (minutes /
                          maxMinutes) *
                          55;

                  final isToday =
                      index ==
                          DateTime.now()
                              .weekday -
                              1;

                  return Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.end,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _formatHours(minutes),
                              style: TextStyle(
                                fontSize: 15,
                                color: isToday
                                    ? AppTheme.primary
                                    : AppTheme.muted,
                                fontWeight:
                                isToday
                                    ? FontWeight.w500
                                    : FontWeight
                                    .normal,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          Container(
                            height: height,
                            decoration:
                            BoxDecoration(
                              color: isToday
                                  ? AppTheme.primary
                                  : AppTheme.primary
                                  .withValues(
                                alpha: 0.3,
                              ),
                              borderRadius:
                              BorderRadius
                                  .circular(8),
                            ),
                          ),

                          const SizedBox(height: 14),

                          Text(
                            labels[index],
                            style:
                            TextStyle(
                              fontSize: 16,
                              color: isToday
                                  ? AppTheme.ink
                                  : AppTheme.muted,
                              fontWeight:
                              isToday
                                  ? FontWeight.w500
                                  : FontWeight
                                  .normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
  }) {
    return Container(
      height: 188,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              letterSpacing: 1.3,
              color: AppTheme.muted,
            ),
          ),

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.ink,
                  ),
                ),
              ),

              const SizedBox(width: 7),

              Padding(
                padding:
                const EdgeInsets.only(
                  bottom: 8,
                ),
                child: Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.muted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalStudyTime() {
    final hours =
        viewModel.totalStudyHours;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        32,
        30,
        32,
        34,
      ),
      decoration: BoxDecoration(
        color: AppTheme.ink,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'TOTAL STUDY TIME',
            style: TextStyle(
              fontSize: 17,
              letterSpacing: 1.4,
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 22),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.bottomLeft,
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.end,
              children: [
                Text(
                  hours.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 68,
                    height: 0.95,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 10),

                const Padding(
                  padding:
                  EdgeInsets.only(bottom: 8),
                  child: Text(
                    'hours',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'this week',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectBreakdown() {
    final breakdown =
        viewModel.subjectBreakdown;

    if (breakdown.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.divider,
          ),
        ),
        child: const Text(
          'No subject data yet.',
          style: TextStyle(
            fontSize: 17,
            color: AppTheme.muted,
          ),
        ),
      );
    }

    final sorted =
    breakdown.entries.toList()
      ..sort(
            (a, b) => b.value.compareTo(a.value),
      );

    final maxMinutes = sorted.first.value
        .inMinutes
        .clamp(1, 1000000);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        28,
        28,
        28,
        30,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'SUBJECT BREAKDOWN',
            style: TextStyle(
              fontSize: 17,
              letterSpacing: 1.4,
              color: AppTheme.muted,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 28),

          ...sorted.map(
                (entry) {
              final minutes =
                  entry.value.inMinutes;

              final percentage =
                  minutes / maxMinutes;

              return Padding(
                padding:
                const EdgeInsets.only(
                  bottom: 22,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.key,
                            maxLines: 1,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style:
                            const TextStyle(
                              fontSize: 19,
                              color:
                              AppTheme.ink,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Text(
                          _formatDuration(
                            entry.value,
                          ),
                          style:
                          const TextStyle(
                            fontSize: 17,
                            color:
                            AppTheme.muted,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Align(
                      alignment:
                      Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor:
                        percentage,
                        child: Container(
                          height: 5,
                          decoration:
                          BoxDecoration(
                            color:
                            AppTheme.primary,
                            borderRadius:
                            BorderRadius
                                .circular(10),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Container(
                      height: 5,
                      decoration:
                      BoxDecoration(
                        color: AppTheme.primary
                            .withValues(
                          alpha: 0.1,
                        ),
                        borderRadius:
                        BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _dateRange() {
    final start = viewModel.weekStart;
    final end = viewModel.weekEnd;

    return '${_month(start.month)} '
        '${start.day} – '
        '${_month(end.month)} '
        '${end.day}, '
        '${end.year}';
  }

  String _formatHours(int minutes) {
    if (minutes == 0) {
      return '0h';
    }

    final hours = minutes ~/ 60;
    final remaining = minutes % 60;

    if (hours == 0) {
      return '${remaining}m';
    }

    if (remaining == 0) {
      return '$hours.0h';
    }

    final decimal =
        hours + remaining / 60;

    return '${decimal.toStringAsFixed(1)}h';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes =
    duration.inMinutes.remainder(60);

    if (hours == 0) {
      return '${minutes}m';
    }

    if (minutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${minutes}m';
  }

  String _month(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }
}