import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/subject.dart';
import '../../viewmodels/session_view_model.dart';
import '../../viewmodels/subject_view_model.dart';
import '../../widgets/subject_icon_tile.dart';
import 'categorize_session_view.dart';
import 'session_summary_dialog.dart';

class StudyTimerView extends StatefulWidget {
  const StudyTimerView({
    super.key,
    this.subject,
    this.initialDuration,
    required this.viewModel,
    required this.subjectViewModel,
    required this.onSessionSaved,
  });

  final Subject? subject;
  final Duration? initialDuration;
  final SessionViewModel viewModel;
  final SubjectViewModel subjectViewModel;
  final VoidCallback onSessionSaved;

  @override
  State<StudyTimerView> createState() => _StudyTimerViewState();
}

class _StudyTimerViewState extends State<StudyTimerView> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  Duration _accumulatedDuration = Duration.zero;
  late DateTime _sessionStartTime;
  late DateTime _currentIntervalStart;
  bool _isCountdown = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _sessionStartTime = DateTime.now();
    _isCountdown = widget.initialDuration != null;
    _startTimer();
  }

  void _startTimer() {
    _currentIntervalStart = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        _elapsed = _accumulatedDuration + now.difference(_currentIntervalStart);

        if (_isCountdown) {
          if (_elapsed >= widget.initialDuration!) {
            _elapsed = widget.initialDuration!;
            _stopTimer();
            _showCompletionDialog();
          }
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _pauseSession() {
    _stopTimer();
    setState(() {
      _accumulatedDuration += DateTime.now().difference(_currentIntervalStart);
      _elapsed = _accumulatedDuration;
      _isPaused = true;
    });
  }

  void _resumeSession() {
    setState(() {
      _isPaused = false;
    });
    _startTimer();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Session Complete!'),
        content: const Text('Great job! You reached your goal.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _endSession();
            },
            child: const Text('DONE'),
          ),
        ],
      ),
    );
  }

  Future<void> _endSession() async {
    _stopTimer();
    
    // Ensure we include the final running interval if not paused
    if (!_isPaused) {
      _elapsed = _accumulatedDuration + DateTime.now().difference(_currentIntervalStart);
    }

    if (widget.subject != null) {
      // Show Summary Dialog for pre-selected subject
      final note = await showSessionSummaryDialog(
        context: context,
        duration: _elapsed,
        subject: widget.subject!,
      );

      if (note != null) {
        widget.viewModel.saveSession(
          subjectId: widget.subject!.id,
          startedAt: _sessionStartTime,
          duration: _elapsed,
          note: note,
        );
        widget.onSessionSaved();
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    } else {
      // Navigate to categorization if it was a quick start
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CategorizeSessionView(
            startedAt: _sessionStartTime,
            duration: _elapsed,
            viewModel: widget.subjectViewModel,
            sessionViewModel: widget.viewModel,
            onSessionSaved: widget.onSessionSaved,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.subject?.color ?? AppTheme.ink;
    final subjectName = widget.subject?.name ?? 'Study Session';

    final displayDuration = _isCountdown
        ? (widget.initialDuration! - _elapsed)
        : _elapsed;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white, size: 32),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    _isCountdown ? 'Countdown' : 'Study Session',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const Spacer(),
            if (widget.subject != null)
              SubjectIconTile(subject: widget.subject!, size: 100)
            else
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.timer_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            const SizedBox(height: 24),
            Text(
              subjectName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _formatDuration(displayDuration),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: OutlinedButton(
                      onPressed: _isPaused ? _resumeSession : _pauseSession,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white, width: 2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded, size: 32),
                          const SizedBox(width: 12),
                          Text(
                            _isPaused ? 'Resume Session' : 'Pause Session',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: ElevatedButton(
                      onPressed: _endSession,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: _isPaused ? 0.8 : 1.0),
                        foregroundColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'End Session',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$minutes:$seconds";
  }
}
