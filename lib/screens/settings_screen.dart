// lib/screens/settings_screen.dart
// شاشة الإعدادات

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/tasbeeh_provider.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TasbeehProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // قسم الصوت والاهتزاز
          _SectionHeader(title: 'الصوت والاهتزاز', icon: Icons.tune_rounded),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SwitchTile(
                icon: Icons.volume_up_rounded,
                iconColor: Colors.blue,
                title: 'صوت الخرزة',
                subtitle: 'تشغيل صوت عند كل تسبيحة',
                value: provider.isSoundEnabled,
                onChanged: (_) => provider.toggleSound(),
              ),
              const Divider(height: 1),
              _SwitchTile(
                icon: Icons.vibration_rounded,
                iconColor: Colors.purple,
                title: 'الاهتزاز',
                subtitle: 'اهتزاز خفيف عند كل تسبيحة',
                value: provider.isVibrationEnabled,
                onChanged: (_) => provider.toggleVibration(),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // قسم المظهر
          _SectionHeader(title: 'المظهر', icon: Icons.palette_rounded),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SwitchTile(
                icon: Icons.dark_mode_rounded,
                iconColor: Colors.indigo,
                title: 'الوضع الليلي',
                subtitle: 'تغيير مظهر التطبيق للوضع الداكن',
                value: provider.isDarkMode,
                onChanged: (_) => provider.toggleDarkMode(),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // قسم الهدف الافتراضي
          _SectionHeader(title: 'الهدف الافتراضي', icon: Icons.flag_rounded),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              for (final target in [33, 100, 500, 1000])
                _RadioTile(
                  title: target.toString(),
                  selected: provider.target == target,
                  onTap: () => provider.setTarget(target),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // قسم التسبيح الثلاثي
          _SectionHeader(
              title: 'التسبيح الثلاثي', icon: Icons.repeat_rounded),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SwitchTile(
                icon: Icons.repeat_rounded,
                iconColor: AppTheme.primaryGreen,
                title: 'وضع التسبيح الثلاثي',
                subtitle: 'سبحان الله ٣٣ + الحمد لله ٣٣ + الله أكبر ٣٤',
                value: provider.isTripleMode,
                onChanged: (_) => provider.toggleTripleMode(),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // قسم البيانات
          _SectionHeader(title: 'البيانات', icon: Icons.storage_rounded),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 22),
                ),
                title: const Text('إعادة ضبط جميع البيانات',
                    style: TextStyle(fontFamily: 'Tajawal')),
                subtitle: const Text('حذف جميع الإحصائيات والأذكار المخصصة',
                    style: TextStyle(fontFamily: 'Tajawal')),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () => _showResetDialog(context, provider),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // معلومات التطبيق
          _SettingsCard(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.info_outline_rounded,
                      color: AppTheme.primaryGreen, size: 22),
                ),
                title: const Text('إصدار التطبيق',
                    style: TextStyle(fontFamily: 'Tajawal')),
                trailing: Text(
                  '1.0.0',
                  style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // رسالة ختامية
          Center(
            child: Text(
              '﴿ وَذَكَرَ اللَّهَ كَثِيرًا ﴾',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppTheme.accentGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'سورة الأحزاب: ٤١',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, TasbeehProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('إعادة الضبط'),
          content: const Text(
            'سيتم حذف جميع بياناتك بما فيها الإحصائيات والأذكار المخصصة والإنجازات.\n\nهل أنت متأكد؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                provider.resetAllData();
                Navigator.pop(ctx);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تمت إعادة الضبط بنجاح',
                        style: TextStyle(fontFamily: 'Tajawal')),
                    backgroundColor: AppTheme.primaryGreen,
                  ),
                );
              },
              child: const Text('إعادة الضبط'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1);
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title,
          style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.w600)),
      subtitle:
          Text(subtitle, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12)),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryGreen,
    );
  }
}

class _RadioTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _RadioTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? theme.colorScheme.primary : null,
        ),
      ),
      trailing: selected
          ? Icon(Icons.check_circle_rounded,
              color: theme.colorScheme.primary)
          : Icon(Icons.circle_outlined,
              color: theme.colorScheme.onBackground.withOpacity(0.3)),
      onTap: onTap,
    );
  }
}
