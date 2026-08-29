import 'package:flutter/material.dart';

import '../viewmodels/history_view_model.dart';
import '../viewmodels/home_view_model.dart';
import '../viewmodels/session_view_model.dart';
import '../viewmodels/stats_view_model.dart';
import '../viewmodels/subject_view_model.dart';
import 'home/home_view.dart';
import 'session/choose_subject_view.dart';
import 'history/history_view.dart';
import 'stats/stats_view.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.homeViewModel,
    required this.subjectViewModel,
    required this.historyViewModel,
    required this.statsViewModel,
    required this.sessionViewModel,
    this.onDataChanged,
  });

  final HomeViewModel homeViewModel;
  final SubjectViewModel subjectViewModel;
  final HistoryViewModel historyViewModel;
  final StatsViewModel statsViewModel;
  final SessionViewModel sessionViewModel;
  final VoidCallback? onDataChanged;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeView(viewModel: widget.homeViewModel),
      const ChooseSubjectView(),
      const HistoryView(),
      const StatsView(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Session',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.calendar_today_outlined,
            ),
            selectedIcon: Icon(
              Icons.calendar_today,
            ),
            label: 'History',
          ),

          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}
