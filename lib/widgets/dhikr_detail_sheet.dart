// lib/widgets/dhikr_detail_sheet.dart
// نافذة تفاصيل الذكر - الفضل والحديث

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/dhikr_model.dart';
import '../utils/app_theme.dart';

class DhikrDetailSheet extends StatelessWidget {
  final DhikrModel dhikr;

  const DhikrDetailSheet({super.key, required this.dhikr});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الذكر
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withOpacity(0.15),
                              theme.colorScheme.secondary.withOpacity(0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          dhikr.arabicText,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ).animate().fadeIn(duration: 400.ms),
                    ),

                    if (dhikr.meaning.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          dhikr.meaning,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.accentGold,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],

                    if (dhikr.virtue.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _InfoCard(
                        icon: Icons.star_rounded,
                        iconColor: AppTheme.accentGold,
                        title: 'فضل الذكر',
                        content: dhikr.virtue,
                      ),
                    ],

                    if (dhikr.hadith.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _InfoCard(
                        icon: Icons.format_quote_rounded,
                        iconColor: theme.colorScheme.primary,
                        title: 'الأحاديث والآيات',
                        content: dhikr.hadith,
                      ),
                    ],

                    const SizedBox(height: 16),

                    // الهدف الافتراضي
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.flag_rounded,
                              color: AppTheme.accentGold, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'الهدف الافتراضي: ${dhikr.defaultTarget} مرة',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppTheme.accentGold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('حسناً'),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String content;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 2.0,
              fontSize: 15,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1);
  }
}
