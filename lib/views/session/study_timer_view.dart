import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/subject.dart';
import '../../viewmodels/session_view_model.dart';
import '../../viewmodels/subject_view_model.dart';
import '../../widgets/subject_icon_tile.dart';
import 'categorize_session_view.dart';

class StudyTimerView extends StatefulWidget {
  const StudyTimerView({
    super.key,
    this.subject,
    required this.viewModel,
    required this.subjectViewModel,
    required this.onSessionSaved,
  });

  final Subject? subject;
  final SessionViewModel viewModel;
  final SubjectViewModel subjectViewModel;
  final VoidCallback onSessionSaved;

  @override
  State<StudyTimerView> createState() => _StudyTimerViewState();
}

class _StudyTimerViewState extends State<StudyTimerView> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsed = DateTime.now().difference(_startTime);
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _endSession() {
    _stopTimer();

    if (widget.subject != null) {
      // Direct save if subject was already chosen
      widget.viewModel.saveSession(
        subjectId: widget.subject!.id,
        startedAt: _startTime,
        duration: _elapsed,
      );
      widget.onSessionSaved();
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      // Navigate to categorization if it was a quick start
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CategorizeSessionView(
            startedAt: _startTime,
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
                  const Text(
                    'Study Session',
                    style: TextStyle(
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
                  _formatDuration(_elapsed),
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
              padding: const EdgeInsets.all(48),
              child: SizedBox(
                width: double.infinity,
                height: 80,
                child: ElevatedButton(
                  onPressed: _endSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
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
