import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/pages/quiz_app/quiz_controller.dart';
import 'package:jsps_depo/pages/quiz_app/widgets/quiz_progress_indicator.dart';
import 'package:jsps_depo/pages/quiz_app/widgets/soru_secenekleri.dart';
import 'package:jsps_depo/pages/quiz_app/widgets/soru_suresi.dart';
import 'package:jsps_depo/pages/quiz_app/widgets/soru_widget.dart';

class QuizEkrani extends StatelessWidget {
  const QuizEkrani({required this.sinifAdi, super.key});

  final String sinifAdi;

  @override
  Widget build(BuildContext context) {
    final QuizController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quiz Ekranı',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Obx(
                  () => Text(
                    'Soru ${controller.currentIndex.value + 1}/${controller.sorular.length}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            Obx(
              () => SoruSuresi(
                key: ValueKey<int>(controller.currentIndex.value),
                sureDakika: 1,
                zamanBittiCallback: controller.gecisYap,
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Obx(
        () => controller.sorular.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                children: <Widget>[
                  QuizProgressIndicator(
                    mevcutSoruIndex: controller.currentIndex.value + 1,
                    toplamSoruSayisi: controller.sorular.length,
                  ),
                  const SizedBox(height: 20),
                  SoruWidget(
                    soruMetni: controller
                        .sorular[controller.currentIndex.value].soruMetni,
                  ),
                  const SizedBox(height: 20),
                  SoruSecenekleri(
                    secenekler: controller
                        .sorular[controller.currentIndex.value].secenekler,
                    dogruCevap: controller
                        .sorular[controller.currentIndex.value].dogruCevap,
                    secilenCevap: controller.secilenCevap.value,
                    dogruCevapGoster: controller.dogruCevap.value,
                    onSecenekSecildi: (secilenCevap) =>
                        controller.cevapVer(secilenCevap),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controller.currentIndex.value > 0
                              ? () {
                                  controller.currentIndex--;
                                }
                              : null,
                          child: const Text('Bir Önceki Soruya Geç'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.gecisYap();
                          },
                          child: const Text('Bir Sonraki Soruyu Geç'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.dogruCevabiGoster();
                          },
                          child: const Text('Doğru Cevabı Göster'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.quizBitir();
                          },
                          child: const Text('Quizi Bitir'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
