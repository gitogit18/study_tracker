import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../viewmodels/auth_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: AppTheme.primary,
                  size: 50,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Study Tracker',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.2,
                  color: AppTheme.ink,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Track your learning journey and build a better future.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: AppTheme.muted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 64),
              if (authViewModel.isLoading)
                const CircularProgressIndicator(color: AppTheme.primary)
              else
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: authViewModel.signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.ink,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: AppTheme.divider),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
                          height: 24,
                          // Note: In a real app, use a local asset
                          errorBuilder: (_, __, ___) => const Icon(Icons.login),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
