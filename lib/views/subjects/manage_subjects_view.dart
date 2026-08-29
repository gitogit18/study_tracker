import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../viewmodels/subject_view_model.dart';
import '../../widgets/subject_row.dart';

class ManageSubjectsView extends StatelessWidget {
  const ManageSubjectsView({
    super.key,
    required this.viewModel,
  });

  final SubjectViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Manage Subjects'),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          final subjects = viewModel.subjects;

          if (subjects.isEmpty) {
            return const Center(
              child: Text('No subjects to manage'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: subjects.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return SubjectRow(
                subject: subject,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                  onPressed: () => _confirmDelete(context, subject.id),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Subject?'),
        content: const Text('This will remove the subject and all its history.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteSubject(id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
