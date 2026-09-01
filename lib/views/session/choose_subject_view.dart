import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/subject.dart';
import '../../viewmodels/session_view_model.dart';
import '../../viewmodels/subject_view_model.dart';
import '../../widgets/subject_row.dart';
import '../subjects/manage_subjects_view.dart';
import '../subjects/new_subject_view.dart';
import 'study_timer_view.dart';
import 'duration_selection_dialog.dart';

class ChooseSubjectView extends StatelessWidget {
  const ChooseSubjectView({
    super.key,
    required this.viewModel,
    required this.sessionViewModel,
    required this.onSessionSaved,
    this.showBackButton = true,
  });

  final SubjectViewModel viewModel;
  final SessionViewModel sessionViewModel;
  final VoidCallback onSessionSaved;
  final bool showBackButton;

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
              padding: const EdgeInsets.fromLTRB(
                44,
                24,
                44,
                40,
              ),
              children: [
                _buildTopBar(context),

                const SizedBox(height: 42),

                const Text(
                  'Choose a subject',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                    color: AppTheme.ink,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'What are you studying today?',
                  style: TextStyle(
                    fontSize: 25,
                    color: AppTheme.muted,
                  ),
                ),

                const SizedBox(height: 38),

                _buildSearchField(),

                const SizedBox(height: 34),

                if (subjects.isEmpty)
                  _buildEmptyState()
                else
                  _buildSubjectList(
                    context,
                    subjects,
                  ),

                const SizedBox(height: 16),

                _buildCreateSubjectButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context) {
    if (!showBackButton) {
      return const SizedBox(height: 32);
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(12),
        child: const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chevron_left_rounded,
                color: AppTheme.primary,
                size: 32,
              ),
              Text(
                'Back',
                style: TextStyle(
                  fontSize: 22,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      onChanged: viewModel.setSearch,

      style: const TextStyle(
        fontSize: 21,
        color: AppTheme.ink,
      ),

      decoration: InputDecoration(
        hintText: 'Search your subjects...',

        hintStyle: const TextStyle(
          fontSize: 21,
          color: AppTheme.muted,
        ),

        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 30,
          color: AppTheme.muted,
        ),

        filled: true,
        fillColor: Colors.white,

        contentPadding:
        const EdgeInsets.symmetric(
          vertical: 22,
          horizontal: 8,
        ),

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(26),

          borderSide: const BorderSide(
            color: AppTheme.divider,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(26),

          borderSide: const BorderSide(
            color: AppTheme.divider,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(26),

          borderSide: const BorderSide(
            color: AppTheme.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectList(
    BuildContext context,
    List<Subject> subjects,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ALL SUBJECTS',
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 1.5,
                color: AppTheme.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ManageSubjectsView(
                      viewModel: viewModel,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.tune_rounded, size: 20),
              label: const Text(
                'Manage',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                backgroundColor: AppTheme.primary.withValues(alpha: 0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...subjects.map(
              (subject) => Padding(
            padding:
            const EdgeInsets.only(
              bottom: 16,
            ),
            child: SubjectRow(
              subject: subject,

              onTap: () {
                _selectSubject(
                  context,
                  subject,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(30),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(24),
      ),

      child: const Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 42,
            color: AppTheme.muted,
          ),

          SizedBox(height: 14),

          Text(
            'No subjects found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 6),

          Text(
            'Try another search or create a new subject.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateSubjectButton(
      BuildContext context,
      ) {
    return OutlinedButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewSubjectView(
              viewModel: viewModel,
              onCreated: () {},
            ),
          ),
        );
      },

      style: OutlinedButton.styleFrom(
        minimumSize:
        const Size.fromHeight(112),

        backgroundColor: Colors.white,

        side: const BorderSide(
          color: Color(0xFFD9D9D5),
        ),

        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(24),
        ),
      ),

      child: const Row(
        children: [
          SizedBox(width: 20),

          Icon(
            Icons.add_rounded,
            size: 36,
            color: AppTheme.muted,
          ),

          SizedBox(width: 24),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create new subject',
                  style: TextStyle(
                    fontSize: 22,
                    color: AppTheme.ink,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Add a custom subject',
                  style: TextStyle(
                    fontSize: 17,
                    color: AppTheme.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectSubject(
      BuildContext context,
      Subject subject,
      ) async {
    final result = await showDurationSelectionDialog(context);
    if (result == null) return;

    final initialDuration = result == Duration.zero ? null : result;

    sessionViewModel.selectSubject(
      subject.id,
    );

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StudyTimerView(
            subject: subject,
            initialDuration: initialDuration,
            viewModel: sessionViewModel,
            subjectViewModel: viewModel,
            onSessionSaved: onSessionSaved,
          ),
        ),
      );
    }
  }
}