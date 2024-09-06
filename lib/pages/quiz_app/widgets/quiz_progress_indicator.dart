import 'package:flutter/material.dart';

class QuizProgressIndicator extends StatelessWidget {
  const QuizProgressIndicator({
    required this.mevcutSoruIndex,
    required this.toplamSoruSayisi,
    super.key,
  });
  final int mevcutSoruIndex;
  final int toplamSoruSayisi;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: mevcutSoruIndex / toplamSoruSayisi,
    );
  }
}
