import 'dart:async';
import 'package:get/get.dart';
import 'package:jsps_depo/pages/quiz_app/models/soru.dart';
import 'package:jsps_depo/pages/quiz_app/screens/quiz_tamamlandi_ekrani.dart';
import 'package:jsps_depo/pages/quiz_app/widgets/dogru_cevabi_goster_dialog.dart';

class QuizController extends GetxController {
  RxList<Soru> sorular = <Soru>[].obs;
  RxInt currentIndex = 0.obs;
  RxInt dogruCevapSayisi = 0.obs;
  RxInt yanlisCevapSayisi = 0.obs;
  RxInt bosCevapSayisi = 0.obs;
  RxString secilenCevap = ''.obs;
  RxString dogruCevap = ''.obs;
  RxInt kalanSure = 60.obs;
  Timer? _timer;
  RxBool cevapVerildi = false.obs;

  void setSorular(List<Soru> sorularListesi) {
    sorular.assignAll(sorularListesi);
    currentIndex.value = 0; // Sıfırdan başlamak için
    dogruCevapSayisi.value = 0;
    yanlisCevapSayisi.value = 0;
    bosCevapSayisi.value = 0;
    secilenCevap.value = '';
    dogruCevap.value = '';
    cevapVerildi.value = false;
    baslatSure();
  }

  void baslatSure() {
    _timer?.cancel();
    kalanSure.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (kalanSure > 0) {
        kalanSure--;
      } else {
        _timer?.cancel();
        zamanBitti();
      }
    });
  }

  void zamanBitti() {
    if (!cevapVerildi.value) {
      bosCevapSayisi++;
      gecisYap();
    }
  }

  void cevapVer(String secilenCevap) {
    if (cevapVerildi.value) return; // İkinci kez tıklamayı önlemek için
    cevapVerildi.value = true;

    var currentSoru = sorular[currentIndex.value];
    this.secilenCevap.value = secilenCevap;

    if (secilenCevap == currentSoru.dogruCevap) {
      dogruCevapSayisi++;
      dogruCevap.value = secilenCevap;
    } else {
      yanlisCevapSayisi++;
      dogruCevap.value = currentSoru.dogruCevap;
    }

    Future.delayed(const Duration(seconds: 1), () {
      gecisYap();
    });
  }

  void gecisYap() {
    if (secilenCevap.value.isEmpty && !cevapVerildi.value) {
      bosCevapSayisi++;
    }

    if (currentIndex < sorular.length - 1) {
      currentIndex++;
      secilenCevap.value = '';
      dogruCevap.value = '';
      cevapVerildi.value = false;
      baslatSure();
    } else {
      quizBitir();
    }
  }

  void dogruCevabiGoster() {
    Get.dialog(
      DogruCevabiGosterDialog(
        dogruCevap: sorular[currentIndex.value].dogruCevap,
        onSonrakiSoruPressed: () {
          gecisYap();
        },
      ),
    );
  }

  void quizBitir() {
    if (!cevapVerildi.value && secilenCevap.value.isEmpty) {
      bosCevapSayisi++;
    }

    // Kalan tüm işaretlenmemiş soruları boş olarak say
    for (int i = currentIndex.value + 1; i < sorular.length; i++) {
      bosCevapSayisi++;
    }

    Get.off(
      () => QuizTamamlandiEkrani(
        dogruCevapSayisi: dogruCevapSayisi.value,
        yanlisCevapSayisi: yanlisCevapSayisi.value,
        bosCevapSayisi: bosCevapSayisi.value,
        toplamSoruSayisi: sorular.length,
      ),
    );
  }
}
