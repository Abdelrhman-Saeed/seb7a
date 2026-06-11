// lib/screens/adhkar_screen.dart
// شاشة قائمة الأذكار مع إمكانية الإضافة والتعديل والحذف

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/dhikr_model.dart';
import '../providers/tasbeeh_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/dhikr_detail_sheet.dart';
import '../widgets/add_dhikr_dialog.dart';

class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TasbeehProvider>();
    final theme = Theme.of(context);

    final builtIn = provider.adhkar.where((d) => !d.isCustom).toList();
    final custom = provider.adhkar.where((d) => d.isCustom).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأذكار'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'إضافة ذكر مخصص',
            onPressed: () => _showAddDhikrDialog(context, provider),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // آية قرآنية
          _buildQuoteCard(theme),
          const SizedBox(height: 20),

          // الأذكار الرئيسية
          _buildSectionTitle('الأذكار الرئيسية', theme),
          const SizedBox(height: 10),
          ...builtIn.asMap().entries.map(
                (entry) => _DhikrCard(
              dhikr: entry.value,
              index: entry.key,
              isSelected:
              provider.selectedDhikr.id == entry.value.id,
              onTap: () {
                provider.selectDhikr(entry.value.id);
                Navigator.pop(context);
              },
              onDetail: () => _showDhikrDetail(context, entry.value),
            ),
          ),

          // الأذكار المخصصة
          if (custom.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildSectionTitle('أذكاري المخصصة', theme),
            const SizedBox(height: 10),
            ...custom.asMap().entries.map(
                  (entry) => _DhikrCard(
                dhikr: entry.value,
                index: entry.key,
                isSelected:
                provider.selectedDhikr.id == entry.value.id,
                isCustom: true,
                onTap: () {
                  provider.selectDhikr(entry.value.id);
                  Navigator.pop(context);
                },
                onDetail: () => _showDhikrDetail(context, entry.value),
                onEdit: () =>
                    _showEditDhikrDialog(context, provider, entry.value),
                onDelete: () =>
                    _showDeleteConfirmation(context, provider, entry.value),
              ),
            ),
          ],

          // زر إضافة ذكر مخصص
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _showAddDhikrDialog(context, provider),
            icon: const Icon(Icons.add_rounded),
            label: const Text('إضافة ذكر مخصص'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGreen.withOpacity(0.9),
            AppTheme.lightGreen.withOpacity(0.7),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            '﴿ يَا أَيُّهَا الَّذِينَ آمَنُوا اذْكُرُوا اللَّهَ ذِكْرًا كَثِيرًا ﴾',
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Text(
            'سورة الأحزاب: ٤١',
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  void _showDhikrDetail(BuildContext context, DhikrModel dhikr) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DhikrDetailSheet(dhikr: dhikr),
    );
  }

  void _showAddDhikrDialog(BuildContext context, TasbeehProvider provider) {
    showDialog(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: provider,
        child: const AddDhikrDialog(),
      ),
    );
  }

  void _showEditDhikrDialog(
      BuildContext context, TasbeehProvider provider, DhikrModel dhikr) {
    showDialog(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: provider,
        child: AddDhikrDialog(existingDhikr: dhikr),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, TasbeehProvider provider, DhikrModel dhikr) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('حذف الذكر'),
          content: Text('هل تريد حذف "${dhikr.arabicText}"؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () {
                provider.deleteCustomDhikr(dhikr.id);
                Navigator.pop(ctx);
              },
              child: const Text('حذف'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DhikrCard extends StatelessWidget {
  final DhikrModel dhikr;
  final int index;
  final bool isSelected;
  final bool isCustom;
  final VoidCallback onTap;
  final VoidCallback onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _DhikrCard({
    required this.dhikr,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.onDetail,
    this.isCustom = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withOpacity(0.1)
            : theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.4)
              : theme.dividerColor,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ]
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // رقم ترتيبي
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : theme.colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // النص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dhikr.arabicText,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onBackground,
                        ),
                      ),
                      if (dhikr.meaning.isNotEmpty)
                        Text(
                          dhikr.meaning,
                          style: theme.textTheme.bodyMedium,
                        ),
                      Text(
                        'الهدف: ${dhikr.defaultTarget}',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 12,
                          color: AppTheme.accentGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // أزرار التحكم
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      Icon(Icons.check_circle_rounded,
                          color: theme.colorScheme.primary, size: 22),

                    // زر التفاصيل
                    if (dhikr.hadith.isNotEmpty || dhikr.virtue.isNotEmpty)
                      GestureDetector(
                        onTap: onDetail,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.info_outline_rounded,
                            color: theme.colorScheme.onBackground
                                .withOpacity(0.4),
                            size: 20,
                          ),
                        ),
                      ),

                    // أزرار التعديل والحذف للمخصصة
                    if (isCustom) ...[
                      GestureDetector(
                        onTap: onEdit,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(Icons.edit_outlined,
                              color: Colors.blue.withOpacity(0.7), size: 20),
                        ),
                      ),
                      GestureDetector(
                        onTap: onDelete,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(Icons.delete_outline_rounded,
                              color: Colors.red.withOpacity(0.7), size: 20),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(
      duration: 300.ms,
      delay: Duration(milliseconds: 50 * index),
    );
  }
}
