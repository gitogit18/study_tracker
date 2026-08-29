import 'package:flutter/material.dart';

import 'package:study_tracker/core/theme/app_theme.dart';
import 'package:study_tracker/core/utils/formatters.dart';
import 'package:study_tracker/viewmodels/home_view_model.dart';
import 'package:study_tracker/widgets/subject_row.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              24,
              28,
              24,
              32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),

                const SizedBox(height: 34),

                _buildStudyCard(
                  context,
                  viewModel,
                ),

                const SizedBox(height: 24),

                _buildStartButton(context),

                const SizedBox(height: 42),

                _buildRecentSessions(
                  context,
                  viewModel,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();

    final weekday = _weekday(now.weekday);
    final month = _month(now.month);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$weekday, ${month.toUpperCase()} ${now.day}',
          style: const TextStyle(
            fontSize: 16,
            letterSpacing: 1.2,
            color: AppTheme.muted,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'Good afternoon, Alex.',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(
            fontSize: 38,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildStudyCard(
      BuildContext context,
      HomeViewModel viewModel,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppTheme.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "TODAY'S STUDY TIME",
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 1.3,
              color: AppTheme.muted,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 20),

          _buildDuration(
            viewModel.todayStudyTime,
          ),

          const SizedBox(height: 38),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily goal: ${formatDuration(viewModel.dailyGoal)}',
                style: const TextStyle(
                  fontSize: 17,
                  color: Color(0xFF686966),
                ),
              ),

              Text(
                '${viewModel.progressPercent}%',
                style: const TextStyle(
                  fontSize: 18,
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: viewModel.progress,
              minHeight: 8,
              backgroundColor:
              const Color(0xFFECEDE9),
              valueColor:
              const AlwaysStoppedAnimation<Color>(
                AppTheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            '${formatDuration(viewModel.remainingTime)} left to reach your goal',
            style: const TextStyle(
              fontSize: 17,
              color: AppTheme.muted,
            ),
          ),

          const SizedBox(height: 34),

          Container(
            height: 1,
            color: AppTheme.divider,
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              const Text(
                '🔥',
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(width: 12),

              Text(
                '${viewModel.streak} day streak',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(width: 8),

              const Text(
                '— keep it going',
                style: TextStyle(
                  fontSize: 17,
                  color: AppTheme.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$hours',
          style: const TextStyle(
            fontSize: 70,
            height: 0.9,
            fontWeight: FontWeight.w400,
          ),
        ),

        const Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 22,
            bottom: 7,
          ),
          child: Text(
            'h',
            style: TextStyle(
              fontSize: 30,
              color: Color(0xFF6D6E6B),
            ),
          ),
        ),

        Text(
          '$minutes',
          style: const TextStyle(
            fontSize: 70,
            height: 0.9,
            fontWeight: FontWeight.w400,
          ),
        ),

        const Padding(
          padding: EdgeInsets.only(
            left: 8,
            bottom: 7,
          ),
          child: Text(
            'm',
            style: TextStyle(
              fontSize: 30,
              color: Color(0xFF6D6E6B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 114,
      child: ElevatedButton(
        onPressed: () {
          // We'll connect this to Choose Subject
          // in the next step.
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.ink,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_arrow,
              size: 26,
            ),

            SizedBox(width: 14),

            Text(
              'Start Session',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSessions(
      BuildContext context,
      HomeViewModel viewModel,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RECENT SESSIONS',
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 1.3,
            color: AppTheme.muted,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 20),

        ...viewModel.recentSessions.map(
              (session) {
            final subject =
            viewModel.getSubject(session.subjectId);

            if (subject == null) {
              return const SizedBox();
            }

            return Padding(
              padding: const EdgeInsets.only(
                bottom: 12,
              ),
              child: SubjectRow(
                subject: subject,
                trailing: Text(
                  formatDuration(session.duration),
                ),
                subtitle:
                formatTime(session.startedAt),
              ),
            );
          },
        ),
      ],
    );
  }

  String _weekday(int day) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return days[day - 1];
  }

  String _month(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }
}
