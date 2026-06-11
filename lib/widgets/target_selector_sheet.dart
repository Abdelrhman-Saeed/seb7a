// lib/widgets/target_selector_sheet.dart
// BottomSheet لاختيار الهدف

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/tasbeeh_provider.dart';
import '../utils/app_theme.dart';

class TargetSelectorSheet extends StatefulWidget {
  const TargetSelectorSheet({super.key});

  @override
  State<TargetSelectorSheet> createState() => _TargetSelectorSheetState();
}

class _TargetSelectorSheetState extends State<TargetSelectorSheet> {
  final _customController = TextEditingController();
  final _focusNode = FocusNode();
  bool _showCustomInput = false;

  static const presets = [33, 100, 500, 1000];

  @override
  void dispose() {
    _customController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TasbeehProvider>();
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Icon(Icons.flag_rounded,
                        color: AppTheme.accentGold, size: 22),
                    const SizedBox(width: 8),
                    Text('تحديد الهدف', style: theme.textTheme.headlineSmall),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // الخيارات الجاهزة
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: presets.length,
                      itemBuilder: (_, i) {
                        final isSelected = provider.target == presets[i] &&
                            !_showCustomInput;
                        return GestureDetector(
                          onTap: () {
                            provider.setTarget(presets[i]);
                            setState(() => _showCustomInput = false);
                            Navigator.pop(context);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.dividerColor,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                presets[i].toString(),
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : theme.colorScheme.onBackground,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // هدف مخصص
                    GestureDetector(
                      onTap: () {
                        setState(() => _showCustomInput = !_showCustomInput);
                        if (_showCustomInput) {
                          Future.delayed(
                            const Duration(milliseconds: 100),
                                () => _focusNode.requestFocus(),
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: _showCustomInput
                              ? theme.colorScheme.primary.withOpacity(0.08)
                              : theme.cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _showCustomInput
                                ? theme.colorScheme.primary.withOpacity(0.3)
                                : theme.dividerColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_rounded,
                              size: 20,
                              color: _showCustomInput
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onBackground
                                  .withOpacity(0.5),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'هدف مخصص',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 15,
                                color: _showCustomInput
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onBackground
                                    .withOpacity(0.7),
                                fontWeight: _showCustomInput
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // حقل الإدخال المخصص
                    if (_showCustomInput) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _customController,
                              focusNode: _focusNode,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText: 'أدخل الهدف',
                                hintStyle: const TextStyle(
                                    fontFamily: 'Tajawal'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              final value =
                              int.tryParse(_customController.text);
                              if (value != null && value > 0) {
                                provider.setTarget(value);
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text('تأكيد'),
                          ),
                        ],
                      ).animate().fadeIn(duration: 200.ms),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
