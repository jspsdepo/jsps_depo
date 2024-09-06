// pages/quiz_app/models/soru.dart
enum SoruTipi { coktenSecmeli, dogruYanlis, bosluklariDoldur, eslestirme }

class Soru {
  Soru({
    required this.soruMetni,
    required this.dogruCevap,
    required this.secenekler,
    this.soruTipi = SoruTipi.coktenSecmeli,
  });

  final String soruMetni;
  final String dogruCevap;
  final List<String> secenekler;
  final SoruTipi soruTipi;
}
