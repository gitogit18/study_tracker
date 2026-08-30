import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'repositories/study_repository.dart';
import 'viewmodels/auth_view_model.dart';
import 'viewmodels/history_view_model.dart';
import 'viewmodels/home_view_model.dart';
import 'viewmodels/session_view_model.dart';
import 'viewmodels/stats_view_model.dart';
import 'viewmodels/subject_view_model.dart';
import 'views/auth/login_view.dart';
import 'views/main_shell.dart';

class StudyTrackerApp extends StatelessWidget {
  const StudyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(context.read<AuthService>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Focusly',
        theme: AppTheme.lightTheme,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    if (authViewModel.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      );
    }

    if (!authViewModel.isAuthenticated) {
      return const LoginView();
    }

    final user = authViewModel.user!;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudyRepository(user.uid)),
        ChangeNotifierProxyProvider<StudyRepository, HomeViewModel>(
          create: (context) => HomeViewModel(context.read<StudyRepository>()),
          update: (_, repo, model) => model!..load(),
        ),
        ChangeNotifierProxyProvider<StudyRepository, SubjectViewModel>(
          create: (context) => SubjectViewModel(context.read<StudyRepository>()),
          update: (_, repo, model) => model!..load(),
        ),
        ChangeNotifierProxyProvider<StudyRepository, HistoryViewModel>(
          create: (context) => HistoryViewModel(context.read<StudyRepository>()),
          update: (_, repo, model) => model!..load(),
        ),
        ChangeNotifierProxyProvider<StudyRepository, StatsViewModel>(
          create: (context) => StatsViewModel(context.read<StudyRepository>()),
          update: (_, repo, model) => model!..load(),
        ),
        ChangeNotifierProvider(
          create: (context) => SessionViewModel(context.read<StudyRepository>()),
        ),
      ],
      child: Consumer5<HomeViewModel, SubjectViewModel, HistoryViewModel,
          StatsViewModel, SessionViewModel>(
        builder: (context, home, subject, history, stats, session, _) {
          return MainShell(
            homeViewModel: home,
            subjectViewModel: subject,
            historyViewModel: history,
            statsViewModel: stats,
            sessionViewModel: session,
            onDataChanged: () {
              home.load();
              subject.load();
              history.load();
              stats.load();
            },
          );
        },
      ),
    );
  }
}
