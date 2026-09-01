import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../models/subject.dart';
import '../../viewmodels/auth_view_model.dart';
import '../../viewmodels/session_view_model.dart';
import '../../viewmodels/subject_view_model.dart';
import '../../widgets/subject_row.dart';

class CategorizeSessionView extends StatefulWidget {
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
  State<CategorizeSessionView> createState() => _CategorizeSessionViewState();
}

class _CategorizeSessionViewState extends State<CategorizeSessionView> {
  final _noteController = TextEditingController();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();
    final firstName = authViewModel.user?.displayName?.split(' ').first ?? 'Alex';

    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        final subjects = widget.viewModel.filteredSubjects;

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.fromLTRB(44, 40, 44, 40),
                  children: [
                    Text(
                      'Great job, $firstName!',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.8,
                        color: AppTheme.ink,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 22,
                          color: AppTheme.muted,
                          fontFamily: 'SF Pro Display', // Match app font if possible
                        ),
                        children: [
                          const TextSpan(text: 'You studied for '),
                          TextSpan(
                            text: formatDuration(widget.duration),
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    const Text(
                      'NOTES',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: AppTheme.muted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _noteController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'What did you achieve?',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    if (subjects.isEmpty)
                      _buildEmptyState(context)
                    else
                      _buildSubjectList(context, subjects),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    numberOfParticles: 20,
                    colors: const [
                      AppTheme.primary,
                      Colors.amber,
                      Colors.blue,
                      Colors.pink,
                    ],
                  ),
                ),
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
    widget.sessionViewModel.saveSession(
      subjectId: subject.id,
      startedAt: widget.startedAt,
      duration: widget.duration,
      note: _noteController.text.trim(),
    );
    widget.onSessionSaved();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
