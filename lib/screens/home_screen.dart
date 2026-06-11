// lib/screens/home_screen.dart
// الشاشة الرئيسية - السبحة الرقمية

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/tasbeeh_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/tasbeeh_button.dart';
import '../widgets/dhikr_selector_sheet.dart';
import '../widgets/target_selector_sheet.dart';
import '../widgets/congratulations_dialog.dart';
import '../widgets/achievement_toast.dart';
import 'settings_screen.dart';
import 'statistics_screen.dart';
import 'adhkar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _wasTargetReached = false;
  late AnimationController _bgController;
  late Animation<double> _bgAnimation;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _bgAnimation = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  void _onTasbeeh(TasbeehProvider provider) {
    provider.increment();

    // عرض رسالة التهنئة عند الوصول للهدف
    if (provider.isTargetReached && !_wasTargetReached) {
      _wasTargetReached = true;
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          showDialog(
            context: context,
            builder: (_) => CongratulationsDialog(
              count: provider.count,
              dhikrText: provider.selectedDhikr.arabicText,
              onContinue: () {
                Navigator.pop(context);
                _wasTargetReached = false;
              },
              onReset: () {
                Navigator.pop(context);
                provider.resetCount();
                _wasTargetReached = false;
              },
            ),
          );
        }
      });
    } else if (!provider.isTargetReached) {
      _wasTargetReached = false;
    }

    // عرض الإنجاز الجديد
    if (provider.newAchievement != null) {
      final title = provider.newAchievement!;
      provider.clearNewAchievement();
      AchievementToast.show(context, title);
    }
  }

  void _showResetConfirmation(TasbeehProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('تصفير العداد'),
          content: const Text('هل أنت متأكد من تصفير العداد؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.resetCount();
                _wasTargetReached = false;
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('تصفير'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TasbeehProvider>();
    final theme = Theme.of(context);
    final isDark = provider.isDarkMode;

    return Scaffold(
      body: Stack(
        children: [
          // خلفية متحركة
          _buildAnimatedBackground(isDark),

          SafeArea(
            child: Column(
              children: [
                // شريط العنوان العلوي
                _buildTopBar(context, provider, theme),

                // الذكر المحدد مع فضله
                _buildSelectedDhikrBanner(provider, theme),

                // مؤشر التقدم
                _buildProgressSection(provider, theme, isDark),

                // العداد الكبير
                Expanded(child: _buildCounterSection(provider, theme, isDark)),

                // أزرار التحكم السفلية
                _buildBottomControls(context, provider, theme, isDark),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== الخلفية المتحركة ==========
  Widget _buildAnimatedBackground(bool isDark) {
    return AnimatedBuilder(
      animation: _bgAnimation,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: isDark
                  ? [
                      AppTheme.darkBackground,
                      Color.lerp(
                        AppTheme.darkBackground,
                        const Color(0xFF0A2218),
                        _bgAnimation.value,
                      )!,
                    ]
                  : [
                      AppTheme.lightBackground,
                      Color.lerp(
                        const Color(0xFFE8F5EE),
                        const Color(0xFFF0EAD6),
                        _bgAnimation.value,
                      )!,
                    ],
            ),
          ),
        );
      },
    );
  }

  // ========== شريط العنوان ==========
  Widget _buildTopBar(
      BuildContext context, TasbeehProvider provider, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // أيقونات اليمين
          Row(
            children: [
              _TopBarButton(
                icon: Icons.bar_chart_rounded,
                tooltip: 'الإحصائيات',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const StatisticsScreen()),
                ),
              ),
              const SizedBox(width: 8),
              _TopBarButton(
                icon: Icons.menu_book_rounded,
                tooltip: 'الأذكار',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdhkarScreen()),
                ),
              ),
            ],
          ),

          // عنوان التطبيق
          Column(
            children: [
              Text(
                'سبحة',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                height: 2,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: AppTheme.accentGold,
                ),
              ),
            ],
          ),

          // أيقونات اليسار
          Row(
            children: [
              _TopBarButton(
                icon: provider.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                tooltip: 'تبديل الوضع',
                onTap: provider.toggleDarkMode,
              ),
              const SizedBox(width: 8),
              _TopBarButton(
                icon: Icons.settings_rounded,
                tooltip: 'الإعدادات',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SettingsScreen()),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.3);
  }

  // ========== بانر الذكر ==========
  Widget _buildSelectedDhikrBanner(
      TasbeehProvider provider, ThemeData theme) {
    final dhikr = provider.selectedDhikr;
    return GestureDetector(
      onTap: () => _showDhikrSelector(context, provider),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: theme.colorScheme.primary,
              size: 22,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    dhikr.arabicText,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (dhikr.meaning.isNotEmpty)
                    Text(
                      dhikr.meaning,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                color: AppTheme.accentGold,
                size: 18,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
    );
  }

  // ========== قسم التقدم ==========
  Widget _buildProgressSection(
      TasbeehProvider provider, ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Column(
        children: [
          // وضع التسبيح الثلاثي
          if (provider.isTripleMode) _buildTripleModeBanner(provider, theme),

          // مؤشر التقدم
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    lineHeight: 10,
                    percent: provider.progress,
                    backgroundColor:
                        theme.colorScheme.primary.withOpacity(0.12),
                    linearGradient: LinearGradient(
                      colors: [
                        theme.colorScheme.secondary,
                        theme.colorScheme.primary,
                      ],
                    ),
                    barRadius: const Radius.circular(8),
                    animation: true,
                    animateFromLastPercent: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(provider.progress * 100).toInt()}%',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الهدف: ${provider.target}',
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                'متبقي: ${(provider.target - provider.count).clamp(0, provider.target)}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 150.ms);
  }

  Widget _buildTripleModeBanner(
      TasbeehProvider provider, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accentGold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppTheme.accentGold.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          final isActive = provider.triplePhase == i;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: [
                Text(
                  TasbeehProvider.triplePhaseNames[i].split(' ').first,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight:
                        isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive
                        ? AppTheme.accentGold
                        : theme.colorScheme.onBackground.withOpacity(0.4),
                  ),
                ),
                if (isActive)
                  Container(
                    height: 2,
                    width: 24,
                    color: AppTheme.accentGold,
                    margin: const EdgeInsets.only(top: 2),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ========== قسم العداد الرئيسي ==========
  Widget _buildCounterSection(
      TasbeehProvider provider, ThemeData theme, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // الرقم الكبير
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) => ScaleTransition(
            scale: Tween(begin: 0.8, end: 1.0).animate(anim),
            child: child,
          ),
          child: Text(
            provider.count.toArabicString(),
            key: ValueKey(provider.count),
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 96,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
              height: 1,
            ),
          ),
        ),

        const SizedBox(height: 4),
        Text(
          'اليوم: ${provider.todayCount.toArabicString()}',
          style: theme.textTheme.bodyMedium,
        ),

        const SizedBox(height: 32),

        // زر السبحة
        TasbeehButton(
          onTap: () => _onTasbeeh(provider),
          isDarkMode: isDark,
        ),

        const SizedBox(height: 24),

        // أيقونات التحكم
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ControlChip(
              icon: provider.isSoundEnabled
                  ? Icons.volume_up_rounded
                  : Icons.volume_off_rounded,
              label: provider.isSoundEnabled ? 'صوت' : 'صامت',
              isActive: provider.isSoundEnabled,
              onTap: provider.toggleSound,
            ),
            const SizedBox(width: 12),
            _ControlChip(
              icon: provider.isVibrationEnabled
                  ? Icons.vibration_rounded
                  : Icons.phone_iphone_rounded,
              label: provider.isVibrationEnabled ? 'اهتزاز' : 'بدون اهتزاز',
              isActive: provider.isVibrationEnabled,
              onTap: provider.toggleVibration,
            ),
          ],
        ),
      ],
    );
  }

  // ========== أزرار التحكم السفلية ==========
  Widget _buildBottomControls(BuildContext context, TasbeehProvider provider,
      ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // زر الهدف
          Expanded(
            child: _BottomButton(
              icon: Icons.flag_rounded,
              label: 'الهدف: ${provider.target}',
              onTap: () => _showTargetSelector(context, provider),
              isDark: isDark,
              color: AppTheme.accentGold,
            ),
          ),
          const SizedBox(width: 10),

          // زر التسبيح الثلاثي
          Expanded(
            child: _BottomButton(
              icon: Icons.repeat_rounded,
              label: provider.isTripleMode ? 'إلغاء الثلاثي' : 'التسبيح الثلاثي',
              onTap: provider.toggleTripleMode,
              isDark: isDark,
              color: provider.isTripleMode
                  ? theme.colorScheme.primary
                  : theme.colorScheme.secondary,
              isActive: provider.isTripleMode,
            ),
          ),
          const SizedBox(width: 10),

          // زر التصفير
          Expanded(
            child: _BottomButton(
              icon: Icons.refresh_rounded,
              label: 'تصفير',
              onTap: () => _showResetConfirmation(provider),
              isDark: isDark,
              color: Colors.red,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 300.ms);
  }

  void _showDhikrSelector(BuildContext context, TasbeehProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: provider,
        child: const DhikrSelectorSheet(),
      ),
    );
  }

  void _showTargetSelector(BuildContext context, TasbeehProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: provider,
        child: const TargetSelectorSheet(),
      ),
    );
  }
}

// ========== مكونات مساعدة ==========

class _TopBarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _TopBarButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 22, color: theme.colorScheme.primary),
      ),
    );
  }
}

class _ControlChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ControlChip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary.withOpacity(0.12)
              : theme.colorScheme.onBackground.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? theme.colorScheme.primary.withOpacity(0.3)
                : theme.colorScheme.onBackground.withOpacity(0.1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onBackground.withOpacity(0.4),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onBackground.withOpacity(0.4),
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final Color color;
  final bool isActive;

  const _BottomButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
    required this.color,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.2) : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(isActive ? 0.5 : 0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

extension on int {
  String toArabicString() {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return toString().split('').map((d) {
      final digit = int.tryParse(d);
      return digit != null ? arabicDigits[digit] : d;
    }).join();
  }
}
