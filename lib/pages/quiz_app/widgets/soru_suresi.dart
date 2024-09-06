import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/pages/quiz_app/quiz_controller.dart';

class SoruSuresi extends StatefulWidget {
  final int sureDakika;
  final VoidCallback zamanBittiCallback;
  final TextStyle? textStyle;

  const SoruSuresi({
    required this.sureDakika,
    required this.zamanBittiCallback,
    super.key,
    this.textStyle,
  });

  @override
  _SoruSuresiState createState() => _SoruSuresiState();
}

class _SoruSuresiState extends State<SoruSuresi> {
  Timer? _timer;
  late int _remainingSeconds;
  final QuizController controller = Get.find();

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.sureDakika * 60;
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant SoruSuresi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (controller.currentIndex.value != oldWidget.key) {
      _resetTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    setState(() {
      _remainingSeconds = widget.sureDakika * 60;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        widget.zamanBittiCallback();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    final timeString =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Text(
      timeString,
      style: widget.textStyle ?? Theme.of(context).textTheme.bodyLarge,
    );
  }
}
