// lib/screens/statistics_screen.dart
// شاشة الإحصائيات والإنجازات

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../data/adhkar_data.dart';
import '../providers/tasbeeh_provider.dart';
import '../utils/app_theme.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TasbeehProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('الإحصائيات والإنجازات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // بطاقة المستوى
          _buildLevelCard(provider, theme),
          const SizedBox(height: 16),

          // بطاقات الإحصائيات السريعة
          _buildStatsRow(provider, theme),
          const SizedBox(height: 20),

          // رسم بياني لآخر 7 أيام
          _buildWeeklyChart(provider, theme),
          const SizedBox(height: 20),

          // الإنجازات
          _buildAchievements(provider, theme),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLevelCard(TasbeehProvider provider, ThemeData theme) {
    final levelColors = [
      Colors.grey,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.orange,
      AppTheme.accentGold,
    ];
    final levelColor = levelColors[(provider.userLevel - 1).clamp(0, 5)];
    final progress = provider.totalLifetimeCount / provider.nextLevelTarget;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            levelColor.withOpacity(0.8),
            levelColor.withOpacity(0.4),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: levelColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المستوى ${provider.userLevel}',
                    style: const TextStyle(
                      fontFamily: 'Tajawal',
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    provider.levelTitle,
                    style: const TextStyle(
                      fontFamily: 'Tajawal',
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${provider.userLevel}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${provider.totalLifetimeCount} / ${provider.nextLevelTarget}',
            style: const TextStyle(
              fontFamily: 'Tajawal',
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1);
  }

  Widget _buildStatsRow(TasbeehProvider provider, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'اليوم',
            value: provider.todayCount.toString(),
            icon: Icons.today_rounded,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'هذا الأسبوع',
            value: provider.weeklyTotal.toString(),
            icon: Icons.date_range_rounded,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'هذا الشهر',
            value: provider.monthlyTotal.toString(),
            icon: Icons.calendar_month_rounded,
            color: Colors.purple,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildWeeklyChart(TasbeehProvider provider, ThemeData theme) {
    final stats = provider.getLast7DaysStats();
    final maxValue = stats.fold<int>(
        1, (max, e) => e.value > max ? e.value : max);

    const dayNames = ['أحد', 'إثن', 'ثلا', 'أرب', 'خمي', 'جمع', 'سبت'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart_rounded,
                  color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'نشاط آخر ٧ أيام',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                maxY: maxValue.toDouble() * 1.2,
                barGroups: List.generate(stats.length, (i) {
                  final dateKey = stats[i].key;
                  final date = DateTime.parse(dateKey);
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: stats[i].value.toDouble(),
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.secondary,
                            theme.colorScheme.primary,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 22,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final date = DateTime.parse(
                            stats[value.toInt()].key);
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            dayNames[date.weekday % 7],
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 11,
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.6),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: theme.dividerColor,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }

  Widget _buildAchievements(TasbeehProvider provider, ThemeData theme) {
    final allAchievements = AdhkarData.getAchievements();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.emoji_events_rounded,
                color: AppTheme.accentGold, size: 20),
            const SizedBox(width: 8),
            Text(
              'الإنجازات',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '${provider.unlockedAchievements.length}/${allAchievements.length}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.accentGold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.9,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: allAchievements.length,
          itemBuilder: (_, i) {
            final ach = allAchievements[i];
            final isUnlocked =
                provider.unlockedAchievements.contains(ach['id']);
            return _AchievementCard(
              icon: ach['icon'] as String,
              title: ach['title'] as String,
              description: ach['description'] as String,
              isUnlocked: isUnlocked,
            ).animate().fadeIn(
                  duration: 300.ms,
                  delay: Duration(milliseconds: 50 * i),
                );
          },
        ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 300.ms);
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final bool isUnlocked;

  const _AchievementCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked
            ? AppTheme.accentGold.withOpacity(0.12)
            : theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? AppTheme.accentGold.withOpacity(0.4)
              : theme.dividerColor,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: TextStyle(
              fontSize: 28,
              color: isUnlocked ? null : Colors.transparent,
              shadows: isUnlocked
                  ? null
                  : [Shadow(color: Colors.grey.shade400, blurRadius: 0)],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isUnlocked
                  ? theme.colorScheme.onBackground
                  : theme.colorScheme.onBackground.withOpacity(0.3),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 10,
              color: isUnlocked
                  ? theme.colorScheme.onBackground.withOpacity(0.5)
                  : theme.colorScheme.onBackground.withOpacity(0.2),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
