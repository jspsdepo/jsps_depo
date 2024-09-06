import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/pages/quiz_app/quiz_controller.dart';
import 'package:jsps_depo/pages/quiz_app/widgets/cevap_widget.dart';

class SoruSecenekleri extends StatefulWidget {
  const SoruSecenekleri({
    required this.secenekler,
    required this.onSecenekSecildi,
    required this.dogruCevap,
    this.secilenCevap,
    this.dogruCevapGoster,
    super.key,
  });

  final List<String> secenekler;
  final void Function(String secenek) onSecenekSecildi;
  final String dogruCevap;
  final String? secilenCevap;
  final String? dogruCevapGoster;

  @override
  _SoruSecenekleriState createState() => _SoruSecenekleriState();
}

class _SoruSecenekleriState extends State<SoruSecenekleri> {
  final QuizController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.secenekler.map((secenek) {
        final seciliMi = secenek == controller.secilenCevap.value;
        final dogruMu = secenek == controller.dogruCevap.value;
        final yanlisMi = seciliMi && !dogruMu;
        return CevapWidget(
          cevapMetni: secenek,
          onPressed: () {
            widget.onSecenekSecildi(secenek);
          },
          seciliMi: seciliMi,
          dogruMu: dogruMu,
          yanlisMi: yanlisMi,
        );
      }).toList(),
    );
  }
}
