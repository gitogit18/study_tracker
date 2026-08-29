import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/subject.dart';
import 'subject_icon_tile.dart';

class SubjectRow extends StatelessWidget {
  const SubjectRow({
    super.key,
    required this.subject,
    this.onTap,
    this.trailing,
    this.subtitle,
  });

  final Subject subject;
  final VoidCallback? onTap;
  final Widget? trailing;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,

      borderRadius:
      BorderRadius.circular(24),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          constraints: BoxConstraints(
            minHeight: subtitle == null ? 104 : 120,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 16,
          ),
          child: Row(
            children: [
              SubjectIconTile(
                subject: subject,
                size: 58,
              ),

              const SizedBox(width: 24),

              Expanded(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      subject.name,

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight:
                        FontWeight.w500,
                        color: AppTheme.ink,
                      ),
                    ),

                    if (subtitle != null) ...[
                      const SizedBox(height: 5),

                      Text(
                        subtitle!,

                        style:
                        const TextStyle(
                          fontSize: 16,
                          color:
                          AppTheme.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              trailing ??
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 28,
                    color: Color(0xFFB8B9B6),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}