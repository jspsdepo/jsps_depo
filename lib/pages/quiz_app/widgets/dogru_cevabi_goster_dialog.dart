import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DogruCevabiGosterDialog extends StatelessWidget {
  const DogruCevabiGosterDialog({
    required this.dogruCevap,
    required this.onSonrakiSoruPressed,
    super.key,
  });

  final String dogruCevap;
  final VoidCallback onSonrakiSoruPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Doğru Cevap'),
      content: Text('Doğru cevap: $dogruCevap'),
      actions: <Widget>[
        TextButton(
          child: const Text('Sonraki Soru'),
          onPressed: () {
            Get.back();
            onSonrakiSoruPressed();
          },
        ),
        TextButton(
          child: const Text('Kapat'),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }
}
