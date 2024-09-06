import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/pages/quiz_app/models/soru.dart';
import 'package:jsps_depo/pages/quiz_app/quiz_controller.dart';
import 'package:jsps_depo/pages/quiz_app/repositories/soru_repository.dart';
import 'package:jsps_depo/pages/quiz_app/widgets/quiz_progress_indicator.dart';
import 'package:jsps_depo/pages/quiz_app/widgets/soru_secenekleri.dart';
import 'package:jsps_depo/pages/quiz_app/widgets/soru_suresi.dart';
import 'package:jsps_depo/pages/quiz_app/widgets/soru_widget.dart';

class DenemeEkrani extends StatefulWidget {
  const DenemeEkrani({super.key});

  @override
  _DenemeEkraniState createState() => _DenemeEkraniState();
}

class _DenemeEkraniState extends State<DenemeEkrani> {
  final QuizController controller = Get.put(QuizController());

  @override
  void initState() {
    super.initState();
    _loadSorular();
  }

  Future<void> _loadSorular() async {
    final sorular = await _getAllSorular();
    controller.setSorular(sorular);
  }

  Future<List<Soru>> _getAllSorular() async {
    final tumSorular = <Soru>[];
    for (final sinif in SoruRepository.tumSiniflar) {
      tumSorular.addAll(sinif.sorular);
      for (final altKategori in sinif.altKategoriler) {
        tumSorular.addAll(altKategori.sorular);
      }
    }
    tumSorular.shuffle();
    return tumSorular.take(100).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Ekranı'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(
              () => Text(
                'Soru ${controller.currentIndex.value + 1}/${controller.sorular.length}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          Obx(
            () => SoruSuresi(
              key: ValueKey<int>(controller.currentIndex.value),
              sureDakika: 1,
              zamanBittiCallback: controller.gecisYap,
              textStyle: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.sorular.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return _quizBody();
      }),
    );
  }

  Widget _quizBody() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: <Widget>[
        QuizProgressIndicator(
          mevcutSoruIndex: controller.currentIndex.value + 1,
          toplamSoruSayisi: controller.sorular.length,
        ),
        const SizedBox(height: 20),
        SoruWidget(
          soruMetni:
              controller.sorular[controller.currentIndex.value].soruMetni,
        ),
        const SizedBox(height: 20),
        SoruSecenekleri(
          secenekler:
              controller.sorular[controller.currentIndex.value].secenekler,
          dogruCevap:
              controller.sorular[controller.currentIndex.value].dogruCevap,
          secilenCevap: controller.secilenCevap.value,
          dogruCevapGoster: controller.dogruCevap.value,
          onSecenekSecildi: (secilenCevap) => controller.cevapVer(secilenCevap),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: controller.currentIndex.value > 0
                    ? () {
                        controller.currentIndex--;
                      }
                    : null,
                child: const Text('Bir Önceki Soruya Geç'),
              ),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: controller.currentIndex.value <
                        controller.sorular.length - 1
                    ? () {
                        controller.currentIndex++;
                      }
                    : null,
                child: const Text('Bir Sonraki Soruyu Geç'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  controller.dogruCevabiGoster();
                },
                child: const Text('Doğru Cevabı Göster'),
              ),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: controller.quizBitir,
                child: const Text('Quizi Bitir'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
