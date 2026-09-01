import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/subject.dart';
import '../../viewmodels/subject_view_model.dart';
import '../../widgets/subject_icon_tile.dart';

class NewSubjectView extends StatefulWidget {
  const NewSubjectView({
    super.key,
    required this.viewModel,
    required this.onCreated,
    this.subject,
  });

  final SubjectViewModel viewModel;
  final VoidCallback onCreated;
  final Subject? subject;

  @override
  State<NewSubjectView> createState() => _NewSubjectViewState();
}

class _NewSubjectViewState extends State<NewSubjectView> {
  late final TextEditingController _nameController;
  late SubjectIcon _selectedIcon;
  late Color _selectedColor;

  final List<Color> _colors = [
    const Color(0xFF4D8073),
    const Color(0xFF7E6BA8),
    const Color(0xFFC77B45),
    const Color(0xFF5277AD),
    const Color(0xFFB45E58),
    const Color(0xFF986B59),
    const Color(0xFF181C1A),
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject?.name ?? '');
    _selectedIcon = widget.subject?.icon ?? SubjectIcon.code;
    _selectedColor = widget.subject?.color ?? const Color(0xFF4D8073);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.subject != null;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Subject' : 'New Subject'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'NAME',
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 1.2,
                color: AppTheme.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'e.g. Mobile Development',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'ICON & COLOR',
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 1.2,
                color: AppTheme.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: SubjectIcon.values.map((icon) {
                final isSelected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    decoration: BoxDecoration(
                      border: isSelected
                          ? Border.all(color: AppTheme.primary, width: 2)
                          : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SubjectIconTile(
                      subject: Subject(
                        id: '',
                        name: '',
                        icon: icon,
                        color: _selectedColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              children: _colors.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: _saveSubject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.ink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  isEditing ? 'Update Subject' : 'Create Subject',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveSubject() {
    if (_nameController.text.trim().isEmpty) return;

    if (widget.subject != null) {
      final updatedSubject = Subject(
        id: widget.subject!.id,
        name: _nameController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
      );
      widget.viewModel.updateSubject(updatedSubject);
    } else {
      final newSubject = Subject(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
      );
      widget.viewModel.addSubject(newSubject);
    }

    widget.onCreated();
    Navigator.pop(context);
  }
}
