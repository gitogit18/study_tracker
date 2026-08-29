import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/subject.dart';
import 'subject_icon_tile.dart';

class SubjectRow extends StatelessWidget {
  const SubjectRow({
    super.key,
    required this.subject,
    this.trailing,
    this.onTap,
    this.subtitle,
  });

  final Subject subject;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.card,

      borderRadius:
      BorderRadius.circular(24),

      child: InkWell(
        onTap: onTap,

        borderRadius:
        BorderRadius.circular(24),

        child: Padding(
          padding: const EdgeInsets.all(18),

          child: Row(
            children: [
              SubjectIconTile(
                subject: subject,
                size: 56,
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      subject.name,

                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (subtitle != null) ...[
                      const SizedBox(height: 5),

                      Text(
                        subtitle!,

                        style: const TextStyle(
                          fontSize: 15,
                          color: AppTheme.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              trailing ??
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFFB7B8B5),
                    size: 28,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}