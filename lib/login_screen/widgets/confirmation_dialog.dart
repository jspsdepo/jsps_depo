import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/login_screen/widgets/note_button.dart';
import 'package:jsps_depo/themes/box_decoration.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent, // Dialog kenarlığını gizlemek için
      child: Container(
        decoration: CustomBoxTheme.getBoxShadowDecoration(theme),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NoteButton(
                  onPressed: () => Get.back(result: false),
                  isOutlined: true,
                  child: Text(
                    'Hayır',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                NoteButton(
                  child: Text(
                    'Evet',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  onPressed: () => Get.back(result: true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
