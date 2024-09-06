import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/login_screen/widgets/dialog_card.dart';

import 'package:jsps_depo/login_screen/widgets/note_button.dart';

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
