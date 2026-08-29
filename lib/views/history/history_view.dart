import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../models/study_session.dart';
import '../../viewmodels/history_view_model.dart';
import '../../widgets/subject_icon_tile.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({
    super.key,
    required this.viewModel,
  });

  final HistoryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        final sessions = viewModel.sessions;

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
                  'History',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.2,
                    color: AppTheme.ink,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '${sessions.length} '
                      '${sessions.length == 1 ? 'session' : 'sessions'} recorded',
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppTheme.muted,
                  ),
                ),

                const SizedBox(height: 42),

                if (sessions.isEmpty)
                  _buildEmptyState()
                else
                  _buildHistory(
                    context,
                    sessions,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistory(
      BuildContext context,
      List<StudySession> sessions,
      ) {
    final sortedSessions = [...sessions];

    sortedSessions.sort(
          (a, b) => b.startedAt.compareTo(a.startedAt),
    );

    final groups = <String, List<StudySession>>{};

    for (final session in sortedSessions) {
      final key = _dateGroup(session.startedAt);

      groups.putIfAbsent(key, () => []);
      groups[key]!.add(session);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in groups.entries) ...[
          _buildSectionHeader(
            entry.key,
            entry.value,
          ),

          const SizedBox(height: 16),

          ...entry.value.map(
                (session) => Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
              ),
              child: _buildSessionCard(
                context,
                session,
              ),
            ),
          ),

          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(
      String title,
      List<StudySession> sessions,
      ) {
    final total = sessions.fold<Duration>(
      Duration.zero,
          (sum, session) => sum + session.duration,
    );

    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
      CrossAxisAlignment.end,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 17,
            letterSpacing: 1.4,
            color: AppTheme.muted,
            fontWeight: FontWeight.w500,
          ),
        ),

        Text(
          '${formatDuration(total)} total',
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.muted,
          ),
        ),
      ],
    );
  }

  Widget _buildSessionCard(
      BuildContext context,
      StudySession session,
      ) {
    final subject =
    viewModel.repository.subjectById(
      session.subjectId,
    );

    if (subject == null) {
      return const SizedBox.shrink();
    }

    final hasNote =
        session.note?.trim().isNotEmpty ?? false;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        30,
        24,
        30,
        24,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.divider,
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              SubjectIconTile(
                subject: subject,
                size: 68,
              ),

              const SizedBox(width: 22),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.name,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight:
                        FontWeight.w500,
                        color: AppTheme.ink,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      formatTime(
                        session.startedAt,
                      ),
                      style: const TextStyle(
                        fontSize: 17,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Text(
                formatDuration(
                  session.duration,
                ),
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.ink,
                ),
              ),
            ],
          ),

          if (hasNote) ...[
            const SizedBox(height: 20),

            Container(
              height: 1,
              color: AppTheme.divider,
            ),

            const SizedBox(height: 18),

            Text(
              session.note ?? '',
              style: const TextStyle(
                fontSize: 17,
                height: 1.4,
                color: Color(0xFF686966),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 50,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.divider,
        ),
      ),

      child: const Column(
        children: [
          Icon(
            Icons.history_rounded,
            size: 48,
            color: AppTheme.muted,
          ),

          SizedBox(height: 18),

          Text(
            'No sessions yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: AppTheme.ink,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Complete your first study session '
                'and it will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.4,
              color: AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }

  String _dateGroup(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final sessionDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final difference =
        today.difference(sessionDate).inDays;

    if (difference == 0) {
      return 'Today';
    }

    if (difference == 1) {
      return 'Yesterday';
    }

    return '${_weekday(date.weekday)}, '
        '${_month(date.month)} ${date.day}';
  }

  String _weekday(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return weekdays[weekday - 1];
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