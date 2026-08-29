import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../models/subject.dart';
import '../../viewmodels/session_view_model.dart';
import '../../viewmodels/subject_view_model.dart';
import '../../widgets/subject_row.dart';

class CategorizeSessionView extends StatelessWidget {
  const CategorizeSessionView({
    super.key,
    required this.startedAt,
    required this.duration,
    required this.viewModel,
    required this.sessionViewModel,
    required this.onSessionSaved,
  });

  final DateTime startedAt;
  final Duration duration;
  final SubjectViewModel viewModel;
  final SessionViewModel sessionViewModel;
  final VoidCallback onSessionSaved;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        final subjects = viewModel.filteredSubjects;

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(44, 40, 44, 40),
              children: [
                const Text(
                  'Great job!',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                    color: AppTheme.ink,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'You studied for ${formatDuration(duration)}. Which subject was this for?',
                  style: const TextStyle(
                    fontSize: 22,
                    color: AppTheme.muted,
                  ),
                ),
                const SizedBox(height: 48),
                if (subjects.isEmpty)
                  _buildEmptyState(context)
                else
                  _buildSubjectList(context, subjects),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubjectList(BuildContext context, List<Subject> subjects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SELECT SUBJECT',
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 1.5,
            color: AppTheme.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        ...subjects.map(
          (subject) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SubjectRow(
              subject: subject,
              onTap: () => _categorize(context, subject),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.subject_rounded, size: 64, color: AppTheme.muted),
          const SizedBox(height: 24),
          const Text(
            'No subjects created yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.ink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  void _categorize(BuildContext context, Subject subject) {
    sessionViewModel.saveSession(
      subjectId: subject.id,
      startedAt: startedAt,
      duration: duration,
    );
    onSessionSaved();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
