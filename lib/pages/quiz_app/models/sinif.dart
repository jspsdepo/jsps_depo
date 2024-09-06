// pages/quiz_app/models/sinif.dart
import 'package:jsps_depo/pages/quiz_app/models/soru.dart';

class Sinif {
  Sinif({
    required this.sinifAdi,
    required this.sorular,
    required this.altKategoriler,
  });

  final String sinifAdi;
  final List<Soru> sorular;
  final List<Sinif> altKategoriler;
}
