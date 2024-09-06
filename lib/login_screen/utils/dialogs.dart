import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/login_screen/widgets/dialog_card.dart';
import 'package:jsps_depo/login_screen/widgets/note_button.dart';

Future<bool?> showMessageDialog({
  required String message,
}) {
  return Get.dialog<bool?>(
    MessageDialog(message: message),
  );
}

Future<bool?> showConfirmationDialog({
  required String title,
}) {
  return Get.dialog<bool?>(
    ConfirmationDialog(title: title),
  );
}

class MessageDialog extends StatelessWidget {
  const MessageDialog({required this.message, super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return DialogCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NoteButton(
                child: const Text('Tamam'),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DialogCard(
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
    );
  }
}
