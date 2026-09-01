import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../viewmodels/auth_view_model.dart';
import '../../viewmodels/home_view_model.dart';
import '../../viewmodels/session_view_model.dart';
import '../../viewmodels/subject_view_model.dart';
import '../../widgets/subject_row.dart';
import '../session/study_timer_view.dart';
import '../session/duration_selection_dialog.dart';
import 'daily_goal_dialog.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.viewModel,
    required this.sessionViewModel,
    required this.subjectViewModel,
    required this.onSessionSaved,
  });

  final HomeViewModel viewModel;
  final SessionViewModel sessionViewModel;
  final SubjectViewModel subjectViewModel;
  final VoidCallback onSessionSaved;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late ConfettiController _confettiController;
  double _lastProgress = 0.0;
  int _lastSessionCount = 0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _lastProgress = widget.viewModel.progress;
    _lastSessionCount = widget.viewModel.recentSessions.length;
    widget.viewModel.addListener(_onViewModelChanged);
    _checkDailyGoal();
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    _confettiController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    // Only trigger if goal was reached
    if (widget.viewModel.progress >= 1.0 && _lastProgress < 1.0) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _confettiController.play();
      });
    }
    
    _lastProgress = widget.viewModel.progress;
    _lastSessionCount = widget.viewModel.recentSessions.length;
  }

  void _checkDailyGoal() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.viewModel.shouldPromptForGoal) {
        final goal = await showDailyGoalDialog(context);
        if (goal != null) {
          widget.viewModel.setDailyGoal(goal);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        return Stack(
          children: [
            SafeArea(
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
                      widget.viewModel,
                    ),

                    const SizedBox(height: 24),

                    _buildStartButton(context),

                    const SizedBox(height: 42),

                    _buildRecentSessions(
                      context,
                      widget.viewModel,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                numberOfParticles: 30,
                maxBlastForce: 30,
                minBlastForce: 15,
                gravity: 0.3,
                colors: const [
                  AppTheme.primary,
                  Colors.amber,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();
    final firstName = authViewModel.user?.displayName?.split(' ').first ?? 'Alex';

    final now = DateTime.now();

    final weekday = _weekday(now.weekday);
    final month = _month(now.month);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
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
                'Good afternoon, $firstName.',
                softWrap: true,
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
          ),
        ),
        GestureDetector(
          onTap: () => _showProfileDialog(context, authViewModel),
          child: Container(
            width: 54,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.divider),
              image: authViewModel.user?.photoURL != null
                  ? DecorationImage(
                      image: NetworkImage(authViewModel.user!.photoURL!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: authViewModel.user?.photoURL == null
                ? const Icon(Icons.person_outline_rounded, color: AppTheme.muted)
                : null,
          ),
        ),
      ],
    );
  }

  void _showProfileDialog(BuildContext context, AuthViewModel authViewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: authViewModel.user?.photoURL != null
                  ? NetworkImage(authViewModel.user!.photoURL!)
                  : null,
              child: authViewModel.user?.photoURL == null
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              authViewModel.user?.displayName ?? 'User',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              authViewModel.user?.email ?? '',
              style: const TextStyle(color: AppTheme.muted),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              authViewModel.signOut();
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
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

          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: viewModel.progress),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            builder: (context, value, _) {
              return SizedBox(
                height: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LiquidLinearProgressIndicator(
                    value: value,
                    valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                    backgroundColor: const Color(0xFFECEDE9),
                    direction: Axis.horizontal,
                  ),
                ),
              );
            },
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
        onPressed: () async {
          final result = await showDurationSelectionDialog(context);
          if (result == null) return;

          final initialDuration = result == Duration.zero ? null : result;

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudyTimerView(
                  subject: null,
                  initialDuration: initialDuration,
                  viewModel: widget.sessionViewModel,
                  subjectViewModel: widget.subjectViewModel,
                  onSessionSaved: widget.onSessionSaved,
                ),
              ),
            );
          }
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
