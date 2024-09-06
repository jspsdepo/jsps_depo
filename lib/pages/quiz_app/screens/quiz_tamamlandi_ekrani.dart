import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/pages/home_screen/screens/home_screen.dart';

class QuizTamamlandiEkrani extends StatelessWidget {
  final int dogruCevapSayisi;
  final int yanlisCevapSayisi;
  final int bosCevapSayisi;
  final int toplamSoruSayisi;

  const QuizTamamlandiEkrani({
    required this.dogruCevapSayisi,
    required this.yanlisCevapSayisi,
    required this.bosCevapSayisi,
    required this.toplamSoruSayisi,
    super.key,
  });

  Future<bool> _onWillPop() async {
    Get.to(HomeScreen);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Tamamlandı'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.celebration,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                'Tebrikler!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'Doğru Cevap Sayınız: $dogruCevapSayisi / $toplamSoruSayisi',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Yanlış Cevap Sayınız: $yanlisCevapSayisi',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Boş Bırakılan Cevap Sayınız: $bosCevapSayisi',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Geri Dön'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
