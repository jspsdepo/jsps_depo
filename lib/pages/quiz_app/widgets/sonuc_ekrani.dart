import 'package:flutter/material.dart';

class SonucEkrani extends StatelessWidget {
  const SonucEkrani({required this.dogruSayisi, super.key});
  final int dogruSayisi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sonuç'),
      ),
      body: Center(
        child: Text('Doğru Cevap Sayısı: $dogruSayisi'),
      ),
    );
  }
}
