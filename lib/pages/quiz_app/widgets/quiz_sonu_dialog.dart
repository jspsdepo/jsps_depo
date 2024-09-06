import 'package:flutter/material.dart';

class QuizSonuDialog extends StatelessWidget {
  // ignore: lines_longer_than_80_chars
  const QuizSonuDialog({
    required this.dogruCevapSayisi,
    required this.soruSayisi,
    super.key,
  });
  final int dogruCevapSayisi;
  final int soruSayisi;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Quiz Tamamlandı!'),
      content: Text('Doğru Cevap Sayınız: $dogruCevapSayisi / $soruSayisi'),
      actions: <Widget>[
        TextButton(
          child: const Text('Tamam'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
