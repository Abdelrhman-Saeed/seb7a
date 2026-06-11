// lib/providers/tasbeeh_provider.dart
// مزود الحالة الرئيسي لتطبيق السبحة

import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../models/dhikr_model.dart';
import '../models/stats_model.dart';
import '../data/adhkar_data.dart';

class TasbeehProvider extends ChangeNotifier {
  // ========== المتغيرات الأساسية ==========
  int _count = 0;
  int _target = 33;
  bool _isVibrationEnabled = true;
  bool _isSoundEnabled = true;
  bool _isDarkMode = false;
  String _selectedDhikrId = 'subhanallah';
  bool _isTripleMode = false;
  int _triplePhase = 0;

  final AudioPlayer _audioPlayer = AudioPlayer();

  // الأذكار
  List<DhikrModel> _adhkar = [];
  Map<String, int> _savedCounts = {};

  // الإحصائيات
  int _totalLifetimeCount = 0;
  int _todayCount = 0;
  int _currentStreak = 0;
  Map<String, DailyStats> _dailyStats = {};
  Set<String> _unlockedAchievements = {};

  // ========== Getters ==========
  int get count => _count;
  int get target => _target;
  bool get isVibrationEnabled => _isVibrationEnabled;
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isDarkMode => _isDarkMode;
  bool get isTripleMode => _isTripleMode;
  int get triplePhase => _triplePhase;
  int get totalLifetimeCount => _totalLifetimeCount;
  int get todayCount => _todayCount;
  int get currentStreak => _currentStreak;
  List<DhikrModel> get adhkar => _adhkar;
  Set<String> get unlockedAchievements => _unlockedAchievements;
  Map<String, DailyStats> get dailyStats => _dailyStats;

  DhikrModel get selectedDhikr => _adhkar.firstWhere(
        (d) => d.id == _selectedDhikrId,
        orElse: () => _adhkar.first,
      );

  double get progress => _target > 0 ? (_count / _target).clamp(0.0, 1.0) : 0.0;
  bool get isTargetReached => _count >= _target;

  static const List<String> triplePhaseNames = [
    'سُبْحَانَ اللهِ',
    'الْحَمْدُ لِلَّهِ',
    'اللهُ أَكْبَرُ',
  ];
  static const List<int> triplePhaseTargets = [33, 33, 34];
  static const List<String> triplePhaseIds = [
    'subhanallah',
    'alhamdulillah',
    'allahuakbar',
  ];

  // ========== التهيئة ==========
  Future<void> initialize() async {
    _adhkar = AdhkarData.getDefaultAdhkar();
    await _loadData();
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // ========== تحميل البيانات ==========
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    _count = prefs.getInt('current_count') ?? 0;
    _target = prefs.getInt('target') ?? 33;
    _isVibrationEnabled = prefs.getBool('vibration') ?? true;
    _isSoundEnabled = prefs.getBool('sound') ?? true;
    _isDarkMode = prefs.getBool('dark_mode') ?? false;
    _selectedDhikrId = prefs.getString('selected_dhikr') ?? 'subhanallah';
    _isTripleMode = prefs.getBool('triple_mode') ?? false;
    _triplePhase = prefs.getInt('triple_phase') ?? 0;
    _totalLifetimeCount = prefs.getInt('total_lifetime') ?? 0;
    _currentStreak = prefs.getInt('streak') ?? 0;

    // الأذكار المخصصة
    final customDhikrJson = prefs.getString('custom_adhkar');
    if (customDhikrJson != null) {
      final List<dynamic> customList = jsonDecode(customDhikrJson);
      _adhkar.addAll(customList.map((m) => DhikrModel.fromMap(m)));
    }

    // الإحصائيات
    final statsJson = prefs.getString('daily_stats');
    if (statsJson != null) {
      final Map<String, dynamic> statsMap = jsonDecode(statsJson);
      _dailyStats = statsMap.map(
        (k, v) => MapEntry(k, DailyStats.fromMap(v)),
      );
    }

    // الإنجازات
    final achievements = prefs.getStringList('achievements') ?? [];
    _unlockedAchievements = Set.from(achievements);

    // العدد المحفوظ
    final countsJson = prefs.getString('saved_counts');
    if (countsJson != null) {
      _savedCounts = Map<String, int>.from(jsonDecode(countsJson));
    }

    _calculateTodayStats();
    _checkStreak();

    if (!_adhkar.any((d) => d.id == _selectedDhikrId)) {
      _selectedDhikrId = _adhkar.first.id;
    }

    if (_isTripleMode) {
      _target = triplePhaseTargets[_triplePhase];
    }
  }

  // ========== حفظ البيانات ==========
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_count', _count);
    await prefs.setInt('target', _target);
    await prefs.setBool('vibration', _isVibrationEnabled);
    await prefs.setBool('sound', _isSoundEnabled);
    await prefs.setBool('dark_mode', _isDarkMode);
    await prefs.setString('selected_dhikr', _selectedDhikrId);
    await prefs.setBool('triple_mode', _isTripleMode);
    await prefs.setInt('triple_phase', _triplePhase);
    await prefs.setInt('total_lifetime', _totalLifetimeCount);
    await prefs.setInt('streak', _currentStreak);

    final customDhikr = _adhkar.where((d) => d.isCustom).toList();
    await prefs.setString(
      'custom_adhkar',
      jsonEncode(customDhikr.map((d) => d.toMap()).toList()),
    );

    await prefs.setString(
      'daily_stats',
      jsonEncode(_dailyStats.map((k, v) => MapEntry(k, v.toMap()))),
    );

    await prefs.setStringList('achievements', _unlockedAchievements.toList());
    await prefs.setString('saved_counts', jsonEncode(_savedCounts));
  }

  // ========== العمليات الأساسية ==========

  void increment() {
    _count++;
    _totalLifetimeCount++;
    _todayCount++;
    _savedCounts[_selectedDhikrId] = (_savedCounts[_selectedDhikrId] ?? 0) + 1;

    _updateTodayStats();
    _checkAchievements();

    // اهتزاز
    if (_isVibrationEnabled) {
      Vibration.vibrate(duration: 30);
    }

    // صوت
    if (_isSoundEnabled) {
      _playBeadSound();
    }

    // وضع التسبيح الثلاثي
    if (_isTripleMode && _count >= _target) {
      _triplePhase = (_triplePhase + 1) % 3;
      _count = 0;
      _target = triplePhaseTargets[_triplePhase];
      _selectedDhikrId = triplePhaseIds[_triplePhase];
    }

    _saveData();
    notifyListeners();
  }

  void _playBeadSound() {
    try {
      _audioPlayer.play(AssetSource('sounds/bead.wav'));
    } catch (_) {
      // تجاهل أخطاء الصوت
    }
  }

  void resetCount() {
    _count = 0;
    _saveData();
    notifyListeners();
  }

  void selectDhikr(String dhikrId) {
    _savedCounts[_selectedDhikrId] = _count;
    _selectedDhikrId = dhikrId;
    _count = _savedCounts[dhikrId] ?? 0;

    final dhikr = _adhkar.firstWhere(
      (d) => d.id == dhikrId,
      orElse: () => _adhkar.first,
    );
    _target = dhikr.defaultTarget;

    _saveData();
    notifyListeners();
  }

  void setTarget(int newTarget) {
    _target = newTarget;
    _saveData();
    notifyListeners();
  }

  void toggleTripleMode() {
    _isTripleMode = !_isTripleMode;
    if (_isTripleMode) {
      _triplePhase = 0;
      _count = 0;
      _target = triplePhaseTargets[0];
      _selectedDhikrId = triplePhaseIds[0];
    } else {
      _selectedDhikrId = 'subhanallah';
      _target = 33;
    }
    _saveData();
    notifyListeners();
  }

  void toggleVibration() {
    _isVibrationEnabled = !_isVibrationEnabled;
    _saveData();
    notifyListeners();
  }

  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
    _saveData();
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _saveData();
    notifyListeners();
  }

  // ========== إدارة الأذكار ==========

  void addCustomDhikr(DhikrModel dhikr) {
    _adhkar.add(dhikr);
    _saveData();
    notifyListeners();
  }

  void updateCustomDhikr(DhikrModel updatedDhikr) {
    final index = _adhkar.indexWhere((d) => d.id == updatedDhikr.id);
    if (index != -1) {
      _adhkar[index] = updatedDhikr;
      _saveData();
      notifyListeners();
    }
  }

  void deleteCustomDhikr(String dhikrId) {
    _adhkar.removeWhere((d) => d.id == dhikrId && d.isCustom);
    if (_selectedDhikrId == dhikrId) {
      _selectedDhikrId = _adhkar.first.id;
      _count = 0;
    }
    _saveData();
    notifyListeners();
  }

  // ========== الإحصائيات ==========

  void _calculateTodayStats() {
    final today = _getDateKey(DateTime.now());
    _todayCount = _dailyStats[today]?.totalCount ?? 0;
  }

  void _updateTodayStats() {
    final today = _getDateKey(DateTime.now());
    final existing = _dailyStats[today];
    _dailyStats[today] = DailyStats(
      date: DateTime.now(),
      totalCount: (existing?.totalCount ?? 0) + 1,
      dhikrCounts: {
        ...?existing?.dhikrCounts,
        _selectedDhikrId: ((existing?.dhikrCounts[_selectedDhikrId] ?? 0) + 1),
      },
    );
  }

  void _checkStreak() {
    final today = _getDateKey(DateTime.now());
    final yesterday = _getDateKey(DateTime.now().subtract(const Duration(days: 1)));

    if (_dailyStats.containsKey(today)) {
      if (!_dailyStats.containsKey(yesterday) && _currentStreak == 0) {
        _currentStreak = 1;
      }
    } else if (!_dailyStats.containsKey(yesterday)) {
      _currentStreak = 0;
    }
  }

  String _getDateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  List<MapEntry<String, int>> getLast7DaysStats() {
    final result = <MapEntry<String, int>>[];
    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final key = _getDateKey(date);
      result.add(MapEntry(key, _dailyStats[key]?.totalCount ?? 0));
    }
    return result;
  }

  int get weeklyTotal {
    int total = 0;
    for (int i = 0; i < 7; i++) {
      final key = _getDateKey(DateTime.now().subtract(Duration(days: i)));
      total += _dailyStats[key]?.totalCount ?? 0;
    }
    return total;
  }

  int get monthlyTotal {
    int total = 0;
    for (int i = 0; i < 30; i++) {
      final key = _getDateKey(DateTime.now().subtract(Duration(days: i)));
      total += _dailyStats[key]?.totalCount ?? 0;
    }
    return total;
  }

  // ========== الإنجازات ==========
  String? _newAchievement;
  String? get newAchievement => _newAchievement;

  void clearNewAchievement() {
    _newAchievement = null;
  }

  void _checkAchievements() {
    for (final ach in AdhkarData.getAchievements()) {
      if (_unlockedAchievements.contains(ach['id'])) continue;
      bool shouldUnlock = ach['id'].toString().startsWith('streak_')
          ? _currentStreak >= (ach['requiredCount'] as int)
          : _totalLifetimeCount >= (ach['requiredCount'] as int);
      if (shouldUnlock) {
        _unlockedAchievements.add(ach['id'] as String);
        _newAchievement = ach['title'] as String;
      }
    }
  }

  // ========== إعادة ضبط ==========
  Future<void> resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _count = 0;
    _target = 33;
    _totalLifetimeCount = 0;
    _todayCount = 0;
    _currentStreak = 0;
    _dailyStats = {};
    _savedCounts = {};
    _unlockedAchievements = {};
    _adhkar = AdhkarData.getDefaultAdhkar();
    _selectedDhikrId = 'subhanallah';
    _isTripleMode = false;
    _triplePhase = 0;
    notifyListeners();
  }

  // ========== مستوى المستخدم ==========
  int get userLevel {
    if (_totalLifetimeCount < 1000) return 1;
    if (_totalLifetimeCount < 5000) return 2;
    if (_totalLifetimeCount < 10000) return 3;
    if (_totalLifetimeCount < 50000) return 4;
    if (_totalLifetimeCount < 100000) return 5;
    return 6;
  }

  String get levelTitle {
    const titles = ['مبتدئ', 'مواظب', 'نشيط', 'متميز', 'متفوق', 'ماهر'];
    return titles[(userLevel - 1).clamp(0, 5)];
  }

  int get nextLevelTarget {
    const targets = [1000, 5000, 10000, 50000, 100000, 999999];
    return targets[(userLevel - 1).clamp(0, 5)];
  }
}
