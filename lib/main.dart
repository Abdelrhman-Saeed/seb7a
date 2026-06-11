// lib/main.dart
// نقطة الدخول الرئيسية لتطبيق سبحة

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/tasbeeh_provider.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // إجبار الاتجاه العمودي فقط
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => TasbeehProvider()..initialize(),
      child: const SubhaApp(),
    ),
  );
}

class SubhaApp extends StatelessWidget {
  const SubhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TasbeehProvider>(
      builder: (context, provider, _) {
        return MaterialApp(
          title: 'سبحة',
          debugShowCheckedModeBanner: false,

          // دعم RTL (اليمين إلى اليسار)
          locale: const Locale('ar', 'SA'),
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },

          // الثيمات
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode:
              provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

          home: const HomeScreen(),
        );
      },
    );
  }
}
