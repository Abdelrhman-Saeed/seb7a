// widgets/tasbeeh_button.dart
// زر السبحة الرئيسي مع الرسوم المتحركة

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TasbeehButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isDarkMode;

  const TasbeehButton({
    super.key,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  State<TasbeehButton> createState() => _TasbeehButtonState();
}

class _TasbeehButtonState extends State<TasbeehButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    setState(() => _isPressed = true);
    await _controller.forward();
    widget.onTap();
    await _controller.reverse();
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                secondaryColor,
                primaryColor,
              ],
              center: const Alignment(-0.3, -0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.4),
                blurRadius: _isPressed ? 15 : 30,
                spreadRadius: _isPressed ? 2 : 8,
                offset: Offset(0, _isPressed ? 4 : 10),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(widget.isDarkMode ? 0.05 : 0.6),
                blurRadius: 15,
                spreadRadius: -5,
                offset: const Offset(-8, -8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // نقوش زخرفية
              ...List.generate(8, (i) {
                final angle = i * 45.0;
                return Transform.rotate(
                  angle: angle * 3.14159 / 180,
                  child: Container(
                    width: 200,
                    height: 1.5,
                    color: Colors.white.withOpacity(0.08),
                  ),
                );
              }),

              // دوائر داخلية
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
              ),
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),

              // النص الرئيسي
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '☽',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'اضغط للتسبيح',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.95),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
