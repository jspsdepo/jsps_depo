import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/pages/home_screen/screens/home_screen.dart';
import 'package:jsps_depo/pages/quiz_app/quiz_controller.dart';
import 'package:jsps_depo/pages/quiz_app/quiz_ekrani.dart';
import 'package:jsps_depo/pages/quiz_app/repositories/soru_repository.dart';
import 'package:jsps_depo/pages/quiz_app/screens/alt_kategori_ekrani.dart';
import 'package:jsps_depo/themes/box_decoration.dart';

class SinifSecmekEkrani extends StatelessWidget {
  const SinifSecmekEkrani({super.key});

  Future<bool> _onWillPop() async {
    Get.offAll(
      () => const HomeScreen(),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final QuizController quizController = Get.put(QuizController());

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('SINAV UYGULAMASI')),
        body: ListView.builder(
          itemCount: SoruRepository.tumSiniflar.length,
          itemBuilder: (context, index) {
            final sinif = SoruRepository.tumSiniflar[index];
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () {
                    quizController.setSorular(sinif.sorular);
                    if (sinif.altKategoriler.isNotEmpty) {
                      Get.to(
                        () => AltKategoriSecmeEkrani(
                          sinif: sinif,
                          sinifAdi: sinif,
                        ),
                      );
                    } else {
                      Get.to(() => QuizEkrani(sinifAdi: sinif.sinifAdi));
                    }
                  },
                  child: Container(
                    decoration: CustomBoxTheme.getBoxShadowDecoration(theme),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sinif.sinifAdi,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
