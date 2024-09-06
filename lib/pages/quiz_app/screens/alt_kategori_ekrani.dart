import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/pages/quiz_app/models/sinif.dart';
import 'package:jsps_depo/pages/quiz_app/quiz_controller.dart';
import 'package:jsps_depo/pages/quiz_app/quiz_ekrani.dart';
import 'package:jsps_depo/themes/box_decoration.dart';

class AltKategoriSecmeEkrani extends StatelessWidget {
  const AltKategoriSecmeEkrani({
    required this.sinif,
    required Sinif sinifAdi,
    super.key,
  });

  final Sinif sinif;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final QuizController quizController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('${sinif.sinifAdi} Alt Kategorileri'),
      ),
      body: ListView.separated(
        itemCount: sinif.altKategoriler.length,
        itemBuilder: (BuildContext context, int index) {
          final altKategori = sinif.altKategoriler[index];
          return Container(
            margin: const EdgeInsets.all(16),
            decoration: CustomBoxTheme.getBoxShadowDecoration(theme),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                title: Text(
                  altKategori.sinifAdi,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${altKategori.sorular.length} Soru',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                onTap: () {
                  quizController.setSorular(altKategori.sorular);
                  Get.to(() => QuizEkrani(sinifAdi: altKategori.sinifAdi));
                },
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
          height: 1,
        ),
      ),
    );
  }
}
