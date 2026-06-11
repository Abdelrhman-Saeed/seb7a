// lib/widgets/add_dhikr_dialog.dart
// نافذة إضافة / تعديل ذكر مخصص

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dhikr_model.dart';
import '../providers/tasbeeh_provider.dart';

class AddDhikrDialog extends StatefulWidget {
  final DhikrModel? existingDhikr;

  const AddDhikrDialog({super.key, this.existingDhikr});

  @override
  State<AddDhikrDialog> createState() => _AddDhikrDialogState();
}

class _AddDhikrDialogState extends State<AddDhikrDialog> {
  late final TextEditingController _textController;
  late final TextEditingController _meaningController;
  late final TextEditingController _virtueController;
  late final TextEditingController _targetController;
  final _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.existingDhikr != null;

  @override
  void initState() {
    super.initState();
    final d = widget.existingDhikr;
    _textController = TextEditingController(text: d?.arabicText ?? '');
    _meaningController = TextEditingController(text: d?.meaning ?? '');
    _virtueController = TextEditingController(text: d?.virtue ?? '');
    _targetController =
        TextEditingController(text: d?.defaultTarget.toString() ?? '33');
  }

  @override
  void dispose() {
    _textController.dispose();
    _meaningController.dispose();
    _virtueController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _save(TasbeehProvider provider) {
    if (!_formKey.currentState!.validate()) return;

    final dhikr = DhikrModel(
      id: widget.existingDhikr?.id ??
          'custom_${DateTime.now().millisecondsSinceEpoch}',
      arabicText: _textController.text.trim(),
      meaning: _meaningController.text.trim(),
      virtue: _virtueController.text.trim(),
      defaultTarget: int.tryParse(_targetController.text) ?? 33,
      isCustom: true,
    );

    if (isEditing) {
      provider.updateCustomDhikr(dhikr);
    } else {
      provider.addCustomDhikr(dhikr);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TasbeehProvider>();
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isEditing ? 'تعديل الذكر' : 'إضافة ذكر مخصص'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // نص الذكر (إلزامي)
                TextFormField(
                  controller: _textController,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    labelText: 'نص الذكر *',
                    labelStyle:
                        const TextStyle(fontFamily: 'Tajawal'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: theme.colorScheme.primary, width: 2),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'أدخل نص الذكر' : null,
                ),
                const SizedBox(height: 12),

                // المعنى (اختياري)
                TextFormField(
                  controller: _meaningController,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontFamily: 'Tajawal'),
                  decoration: InputDecoration(
                    labelText: 'المعنى (اختياري)',
                    labelStyle:
                        const TextStyle(fontFamily: 'Tajawal'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: theme.colorScheme.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // الفضل (اختياري)
                TextFormField(
                  controller: _virtueController,
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  style: const TextStyle(fontFamily: 'Tajawal'),
                  decoration: InputDecoration(
                    labelText: 'الفضل أو الحديث (اختياري)',
                    labelStyle:
                        const TextStyle(fontFamily: 'Tajawal'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: theme.colorScheme.primary, width: 2),
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),

                // الهدف
                TextFormField(
                  controller: _targetController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    labelText: 'الهدف الافتراضي',
                    labelStyle:
                        const TextStyle(fontFamily: 'Tajawal'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: theme.colorScheme.primary, width: 2),
                    ),
                  ),
                  validator: (v) {
                    final n = int.tryParse(v ?? '');
                    if (n == null || n <= 0) return 'أدخل رقماً صحيحاً';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => _save(provider),
            child: Text(isEditing ? 'تحديث' : 'إضافة'),
          ),
        ],
      ),
    );
  }
}
